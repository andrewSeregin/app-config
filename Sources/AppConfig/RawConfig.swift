//
//  RawConfig.swift
//  
//
//  Created by Andrew Seregin on 26.04.2022.
//

@dynamicMemberLookup
public struct RawConfig {
    private let rawValues: [AnyHashable: Any]
    
    init(_ rawValues: [AnyHashable: Any]? = nil) {
        self.rawValues = rawValues ?? [:]
    }
    
    public subscript(dynamicMember member: String) -> Any? {
        rawValues[member]
    }
    
    public subscript(key: String) -> Any? {
        rawValues[key]
    }
}

