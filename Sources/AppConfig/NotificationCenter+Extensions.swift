//
//  NotificationCenter+Extensions.swift
//  
//
//  Created by Andrew Seregin on 26.04.2022.
//

import Foundation

public extension NotificationCenter {
    func addObserver<Value>(
        forName name: NSNotification.Name,
        object obj: Any? = nil,
        queue: OperationQueue? = nil,
        userInfoKey: String,
        with block: @escaping (AnyObject?, Value) -> Void
    ) -> NSObjectProtocol {
        addObserver(
            forName: name,
            object: obj,
            queue: queue
        ) {
            guard let value = $0.userInfo?[userInfoKey] as? Value else {
                return
            }
            let object = $0.object as AnyObject?
            block(object, value)
        }
    }
}
