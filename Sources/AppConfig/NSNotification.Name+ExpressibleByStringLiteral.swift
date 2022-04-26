//
//  NSNotification.Name+ExpressibleByStringLiteral.swift
//  
//
//  Created by Andrew Seregin on 26.04.2022.
//

import Foundation

extension NSNotification.Name: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}
