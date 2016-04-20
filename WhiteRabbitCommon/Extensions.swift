//
//  Extensions.swift
//  WhiteRabbitCommon
//
//  Created by Michael Bina on 4/18/16.
//  Copyright © 2016 White Rabbit Apps. All rights reserved.
//

import Foundation

extension UIColor {
    public class func mainColor() -> UIColor {
        return UIColor(red: 0/255, green: 42/255, blue: 79/255, alpha: 1.0)
    }
    
    public func secondaryColor() -> UIColor {
        return UIColor.lightGrayColor()
    }
    
    public func linkColor() -> UIColor {
        return UIColor(red: 0/255, green: 94/255, blue: 183/255, alpha: 1.0)
    }
}