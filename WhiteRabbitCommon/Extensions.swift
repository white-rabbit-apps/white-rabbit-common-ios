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
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
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
    
    
    
    
    
    
    
    
    func setUpNavigationBar() {
        self.setUpNavigationBar("")
    }
    
    func setUpTransparentNavigationBar() {
        self.setUpTransparentNavigationBar("")
    }
    
    func setUpTransparentNavigationBar(title: String) {
        self.setUpNavigationBar(title)
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.BlackTranslucent
        nav?.translucent = true
        nav?.backgroundColor = UIColor.clearColor()
        nav?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        nav?.shadowImage = UIImage()
        
        if var frame = nav?.frame {
            frame.size.height = 45
            nav?.frame = frame
        }
    }
    
    func setUpTransparentMenuBar() {
        self.setUpTransparentMenuBar("")
    }
    
    func setUpTransparentMenuBar(title: String) {
        self.setUpMenuBarController(title)
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.BlackTranslucent
        nav?.translucent = true
        nav?.backgroundColor = UIColor.clearColor()
        nav?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        nav?.shadowImage = UIImage()
        
        if var frame = nav?.frame {
            frame.size.height = 45
            nav?.frame = frame
        }
    }
    
    func setUpNavigationBar(title: String) {
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Default
        nav?.backgroundColor = UIColor.mainColor()
        nav?.barTintColor = UIColor.mainColor()
        nav?.tintColor = UIColor.whiteColor()
        
        nav?.setBackgroundImage(nil, forBarMetrics: .Default)
        if var frame = nav?.frame {
            frame.size.height = 45
            nav?.frame = frame
        }
        
        nav?.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir", size: 19)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationItem.title = title
        
        self.navigationItem.leftBarButtonItem = self.getNavBarItem("back_white", action: #selector(UIViewController.goBack), height: 25, width: 25)
    }
    
    func setUpNavigationBarImage(image: UIImage, height: CGFloat) {
        self.setUpNavigationBarImage(image, height: height, title: "")
    }
    
    func setUpNavigationBarImage(image: UIImage, height: CGFloat, title: String) {
        let nav = self.navigationController?.navigationBar
        
        nav?.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir", size: 19)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationItem.title = title
        
        nav?.barStyle = UIBarStyle.BlackOpaque
        
        nav!.translucent = false
        nav!.setBackgroundImage(image.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .Stretch), forBarMetrics: .Default)
        var frame = nav!.frame
        frame.size.height = height
        nav!.frame = frame
        
        self.navigationItem.leftBarButtonItem = self.getNavBarItem("back_white", action: #selector(UIViewController.goBack), height: 25, width: 25)
    }
    
    func setUpMenuBarController() {
        self.setUpMenuBarController("")
    }
    
    func setUpMenuBarController(title: String) {
        self.setUpNavigationBar(title)
        
        self.navigationItem.leftBarButtonItem = self.getNavBarItem("menu_white", action: "showMenu", height: 20, width: 25)
    }
    
    func setUpMenuBarImageController(image: UIImage, height: CGFloat, title: String) {
        self.setUpNavigationBarImage(image, height: height, title: title)
        
        self.navigationItem.leftBarButtonItem = self.getNavBarItem("menu_white", action: "showMenu", height: 20, width: 25)
    }
    
    func setUpMenuBarImageController(image: UIImage, height: CGFloat) {
        self.setUpMenuBarImageController(image, height: height, title: "")
    }
    
}