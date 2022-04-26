//
//  ConfigValue.swift
//  
//
//  Created by Andrew Seregin on 26.04.2022.
//

import protocol Combine.TopLevelDecoder
import Foundation

@propertyWrapper
final public class ConfigValue<Value> {
    private var subscription: NSObjectProtocol?
    private var completion: (Value, Value) -> Void = { _, _ in }
    
    private var value: Value {
        didSet {
            completion(oldValue, value)
        }
    }
    
    @available(*, unavailable, message: "@ConfigValue can only be applied to classes")
    public var wrappedValue: Value {
        fatalError()
    }
    
    public var projectedValue: ConfigValue {
        self
    }
    
    public static subscript<T: AnyObject>(
        _enclosingInstance instance: T,
        wrapped wrappedKeyPath: KeyPath<T, Value>,
        storage storageKeyPath: KeyPath<T, ConfigValue>
    ) -> Value {
        instance[keyPath: storageKeyPath].value
    }
    
    public init(
        wrappedValue value: Value = false,
        _ keyPath: KeyPath<RawConfig, Any?>
    ) where Value == Bool {
        defer {
            initializeSubscription(by: keyPath)
        }
        self.value = value
    }
    
    public init(
        wrappedValue value: Value = nil,
        _ keyPath: KeyPath<RawConfig, Any?>
    ) where Value == Optional<Bool> {
        defer {
            initializeSubscription(by: keyPath)
        }
        self.value = value
    }
    
    public init(
        wrappedValue value: Value = .zero,
        _ keyPath: KeyPath<RawConfig, Any?>
    ) where Value == Int {
        defer {
            initializeSubscription(by: keyPath)
        }
        self.value = value
    }
    
    public init(
        wrappedValue value: Value = nil,
        _ keyPath: KeyPath<RawConfig, Any?>
    ) where Value == Optional<Int> {
        defer {
            initializeSubscription(by: keyPath)
        }
        self.value = value
    }
    
    public init(
        wrappedValue value: Value = .zero,
        _ keyPath: KeyPath<RawConfig, Any?>
    ) where Value == Double {
        defer {
            initializeSubscription(by: keyPath)
        }
        self.value = value
    }
    
    public init(
        wrappedValue value: Value = nil,
        _ keyPath: KeyPath<RawConfig, Any?>
    ) where Value == Optional<Double> {
        defer {
            initializeSubscription(by: keyPath)
        }
        self.value = value
    }
    
    public init(
        wrappedValue value: Value = "",
        _ keyPath: KeyPath<RawConfig, Any?>
    ) where Value == String {
        defer {
            initializeSubscription(by: keyPath)
        }
        self.value = value
    }
    
    public init(
        wrappedValue value: Value = nil,
        _ keyPath: KeyPath<RawConfig, Any?>
    ) where Value == Optional<String> {
        defer {
            initializeSubscription(by: keyPath)
        }
        self.value = value
    }
    
    public init(
        wrappedValue value: Value,
        _ keyPath: KeyPath<RawConfig, Any?>
    ) where Value: RawRepresentable {
        defer {
            initializeSubscription(by: keyPath) {
                let rawValue = $0 as? Value.RawValue
                return rawValue.flatMap { .init(rawValue: $0) }
            }
        }
        self.value = value
    }
    
    public init<R>(
        wrappedValue value: Value = nil,
        _ keyPath: KeyPath<RawConfig, Any?>
    ) where Value == Optional<R>, R: RawRepresentable {
        defer {
            initializeSubscription(by: keyPath) {
                let rawValue = $0 as? R.RawValue
                return rawValue.flatMap { .init(rawValue: $0) }
            }
        }
        self.value = value
    }
    
    public init(
        wrappedValue value: Value,
        _ keyPath: KeyPath<RawConfig, Any?>
    ) where Value == URL {
        defer {
            initializeSubscription(by: keyPath) {
                let object = $0 as? String
                return object.flatMap { .init(string: $0) }
            }
        }
        self.value = value
    }
    
    public init(
        wrappedValue value: Value = nil,
        _ keyPath: KeyPath<RawConfig, Any?>
    ) where Value == Optional<URL> {
        defer {
            initializeSubscription(by: keyPath) {
                let object = $0 as? String
                return object.flatMap { .init(string: $0) }
            }
        }
        self.value = value
    }
    
    public init(
        wrappedValue value: Value = Data(),
        _ keyPath: KeyPath<RawConfig, Any?>
    ) where Value == Data {
        defer {
            initializeSubscription(by: keyPath)
        }
        self.value = value
    }
    
    public init(
        wrappedValue value: Value = nil,
        _ keyPath: KeyPath<RawConfig, Any?>
    ) where Value == Optional<Data> {
        defer {
            initializeSubscription(by: keyPath)
        }
        self.value = value
    }
    
    public init<Decoder: TopLevelDecoder>(
        wrappedValue value: Value,
        _ keyPath: KeyPath<RawConfig, Any?>,
        _ decoder: Decoder
    ) where Value: Decodable, Decoder.Input == Data {
        defer {
            initializeSubscription(by: keyPath) {
                guard JSONSerialization.isValidJSONObject($0) else {
                    return nil
                }
                let data = try? JSONSerialization.data(withJSONObject: $0!)
                return data.flatMap { try? decoder.decode(Value.self, from: $0) }
            }
        }
        self.value = value
    }
    
    public init<Decoder: TopLevelDecoder, T: Decodable>(
        wrappedValue value: Value = nil,
        _ keyPath: KeyPath<RawConfig, Any?>,
        _ decoder: Decoder
    ) where Value == Optional<T>, Decoder.Input == Data {
        defer {
            initializeSubscription(by: keyPath) {
                guard JSONSerialization.isValidJSONObject($0) else {
                    return nil
                }
                let data = try? JSONSerialization.data(withJSONObject: $0!)
                return data.flatMap { try? decoder.decode(Value.self, from: $0) }
            }
        }
        self.value = value
    }
    
    deinit {
        if let subscription = subscription {
            NotificationCenter.default.removeObserver(subscription)
        }
    }
}

private extension ConfigValue {
    func initializeSubscription(
        by keyPath: KeyPath<RawConfig, Any?>,
        _ transform: @escaping (Any?) -> Value? = { $0 as? Value }
    ) {
        self.subscription = NotificationCenter.default.addObserver(
            forName: .AppConfigDidReceiveValues,
            userInfoKey: .AppConfigUserInfoKey
        ) { [weak self] (subscriber: AnyObject?,
                         rawConfig: RawConfig) in
            guard
                let self = self,
                subscriber === self || subscriber == nil,
                let value = rawConfig[keyPath: keyPath].flatMap(transform)
            else {
                return
            }
            self.value = value
        }
        
        NotificationCenter.default.post(
            name: .AppConfigDidReceiveSubscriber,
            object: self
        )
    }
}

private extension ConfigValue {
    func withUnretained<Object: AnyObject>(
        _ object: Object,
        then completion: @escaping (Object, Value, Value) -> Void
    ) {
        self.completion = { [weak object] oldValue, newValue in
            guard let object = object else {
                return
            }
            completion(object, oldValue, newValue)
        }
    }
    
    func retaining(
        then completion: @escaping (Value, Value) -> Void
    ) {
        self.completion = { oldValue, newValue in
            completion(oldValue, newValue)
        }
    }
}

public extension ConfigValue {
    func withUnretained<Object: AnyObject>(
        _ object: Object,
        then completion: @escaping (Object, Value) -> Void
    ) {
        withUnretained(object) { object, _, newValue in
            completion(object, newValue)
        }
    }
    
    func withUnretained<Object: AnyObject>(
        _ object: Object,
        then completion: @escaping (Object) -> Void
    ) {
        withUnretained(object) { object, _ in
            completion(object)
        }
    }

    func retaining(
        then completion: @escaping (Value) -> Void
    ) {
        retaining { _, newValue in
            completion(newValue)
        }
    }

    func retaining(
        then completion: @escaping () -> Void
    ) {
        retaining { _ in
            completion()
        }
    }
}

public extension ConfigValue where Value: Equatable {
    func removeDuplicatesForUnretained<Object: AnyObject>(
        _ object: Object,
        then completion: @escaping (Object, Value) -> Void
    ) {
        withUnretained(object) { object, oldValue, newValue in
            guard oldValue != newValue else {
                return
            }
            completion(object, newValue)
        }
    }
    
    func removeDuplicatesForUnretained<Object: AnyObject>(
        _ object: Object,
        then completion: @escaping (Object) -> Void
    ) {
        withUnretained(object) { object, oldValue, newValue in
            guard oldValue != newValue else {
                return
            }
            completion(object)
        }
    }
    
    func removeDuplicates(
        then completion: @escaping (Value) -> Void
    ) {
        retaining { oldValue, newValue in
            guard oldValue != newValue else {
                return
            }
            completion(newValue)
        }
    }
    
    func removeDuplicates(
        then completion: @escaping () -> Void
    ) {
        retaining { oldValue, newValue in
            guard oldValue != newValue else {
                return
            }
            completion()
        }
    }
}
