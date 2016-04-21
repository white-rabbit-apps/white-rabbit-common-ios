//
//  Extensions.swift
//  WhiteRabbitCommon
//
//  Created by Michael Bina on 4/18/16.
//  Copyright © 2016 White Rabbit Apps. All rights reserved.
//

import Foundation

public extension UIColor {
    public class func mainColor() -> UIColor {
        return UIColor(red: 0/255, green: 42/255, blue: 79/255, alpha: 1.0)
    }
    
    public class func secondaryColor() -> UIColor {
        return UIColor.lightGrayColor()
    }
    
    public class func linkColor() -> UIColor {
        return UIColor(red: 0/255, green: 94/255, blue: 183/255, alpha: 1.0)
    }
}

public extension UIViewController {
    func getNavBarItem(imageId : String, action : Selector, height : CGFloat, width: CGFloat) -> UIBarButtonItem! {
        let editImage = UIImage(named: imageId)
        let editButton = UIButton(type: .Custom)
        editButton.setImage(editImage, forState: .Normal)
        editButton.frame = CGRectMake(0, 0, width, height)
        editButton.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        return UIBarButtonItem(customView: editButton)
    }
    
    func getNavBarItem(imageId : String, height : CGFloat, width: CGFloat) -> UIBarButtonItem! {
        let editImage = UIImage(named: imageId)
        let editButton = UIButton(type: .Custom)
        editButton.setImage(editImage, forState: .Normal)
        editButton.frame = CGRectMake(0, 0, width, height)
        return UIBarButtonItem(customView: editButton)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func composeEmail(emailAddress: String, subject: String, body: String) {
        var email: String = "mailto:\(emailAddress)?subject=\(subject)&body=\(body)"
        email = email.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        UIApplication.sharedApplication().openURL(NSURL(string: email)!)
    }
}