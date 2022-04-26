//
//  NSNotification.Name+AppConfig.swift
//  
//
//  Created by Andrew Seregin on 26.04.2022.
//

import Foundation

extension NSNotification.Name {
    static let AppConfigDidReceiveValues: NSNotification.Name = "appConfigDidReceiveValues"
    static let AppConfigDidReceiveSubscriber: NSNotification.Name = "appConfigDidReceiveSubscriber"
    static let AppConfigWillReloadConfig: NSNotification.Name = "appConfigWillReloadConfig"
}
