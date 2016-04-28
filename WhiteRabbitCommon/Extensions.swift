//
//  Extensions.swift
//  WhiteRabbitCommon
//
//  Created by Michael Bina on 4/18/16.
//  Copyright © 2016 White Rabbit Apps. All rights reserved.
//

import Foundation

//import Parse

//public extension UIApplicationDelegate {
//    func initializeWhiteRabbitCommon() {
//        self.initializeParse()
//        self.initializeUI()
//    }
//    
//    func initializeParse() {
//        Parse.enableLocalDatastore()
//        PFUser.enableRevocableSessionInBackground()
//        
//        Parse.initializeWithConfiguration(ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
//            configuration.applicationId = "IWr9xzTirLbjXH80mbTCtT9lWB73ggQe3PhA6nPg"
//            configuration.clientKey = "Yxdst3hz76abMoAwG7FLh0NwDmPvYHFDUPao9WJJ"
//            configuration.server = "http://www.whiterabbitapps.net/api"
//        }))
//    }
//    
//    func initializeUI() {
//        UILabel.appearance().substituteFontName = "Avenir"
//        UITabBar.appearance().barTintColor = UIColor.mainColor()
//        UITabBar.appearance().tintColor = UIColor.whiteColor()
//    }
//}

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
    
    func goBackWithCompletionBlock(completion: ()->()) {
        self.navigationController?.popViewControllerWithCompletionBlock(completion)
    }
    
    func getNavBarItem(imageId : String, action : Selector, height : CGFloat, width: CGFloat) -> UIBarButtonItem! {
        let bundle = NSBundle(path: "Resources/WhiteRabbitAssets.xcassets")
        let editImage = UIImage(named: imageId, inBundle: bundle, compatibleWithTraitCollection: nil)

        let editButton = UIButton(type: .Custom)
        editButton.setImage(editImage, forState: .Normal)
        editButton.frame = CGRectMake(0, 0, width, height)
        editButton.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        return UIBarButtonItem(customView: editButton)
    }
    
    func getNavBarItem(imageId : String, height : CGFloat, width: CGFloat) -> UIBarButtonItem! {
        let bundle = NSBundle(path: "Resources/WhiteRabbitAssets.xcassets")
        let editImage = UIImage(named: imageId, inBundle: bundle, compatibleWithTraitCollection: nil)
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
        email = email.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())!
        
        UIApplication.sharedApplication().openURL(NSURL(string: email)!)
    }
    
    func displayAlert(title:String, message:String, buttonText: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func displayAlert(message: String) {
        displayAlert("Alert", message: message, buttonText: "OK")
    }
    
    
    
    
    func setUpNavigationBar() {
        self.setUpNavigationBar("")
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
        
        self.navigationItem.leftBarButtonItem = self.getNavBarItem("back_white", action: "goBack", height: 25, width: 25)
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
        
        self.navigationItem.leftBarButtonItem = self.getNavBarItem("back_white", action: "goBack", height: 25, width: 25)
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
    
    func showMenu() {
    }
}

public extension UINavigationController {
    func popViewControllerWithCompletionBlock(completion: ()->()) {
        CATransaction.begin()
        self.popViewControllerAnimated(true)
        CATransaction.setCompletionBlock(completion)
        CATransaction.commit()
    }
}


public extension UITabBar {
    override public func sizeThatFits(size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 50
        return sizeThatFits
    }
}

public extension Int {
    public static func random (lower: Int , upper: Int) -> Int {
        let limit = UInt32(upper - lower + 1)
        return lower + Int(arc4random_uniform(limit))
    }
}

public extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
    
    func forEach(doThis: (element: Element) -> Void) {
        for e in self {
            doThis(element: e)
        }
    }
    
    func slice(args: Int...) -> Array {
        var s = args[0]
        var e = self.count - 1
        if args.count > 1 { e = args[1] }
        
        if e < 0 {
            e += self.count
        }
        
        if s < 0 {
            s += self.count
        }
        
        let count = (s < e ? e-s : s-e)+1
        let inc = s < e ? 1 : -1
        var ret = Array()
        
        var idx = s
        for _ in 0..<count  {
            ret.append(self[idx])
            idx += inc
        }
        return ret
    }
}

public extension Dictionary {
    mutating func merge<K, V>(dictionaries: Dictionary<K, V>...) {
        for dict in dictionaries {
            for (key, value) in dict {
                self.updateValue(value as! Value, forKey: key as! Key)
            }
        }
    }
}

public extension UITextField {
    @IBInspectable public var leftSpacer:CGFloat {
        get {
            if let l = leftView {
                return l.frame.size.width
            } else {
                return 0
            }
        } set {
            leftViewMode = .Always
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
        }
    }
}

public extension Float {
    // Format a price with currency based on the device locale.
    var asCurrency: String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale.currentLocale()
        return formatter.stringFromNumber(self)!
    }
}

public extension UIView {
    // Draw a border at the top of a view.
    func drawTopBorderWithColor(color: UIColor, height: CGFloat) {
        let topBorder = CALayer()
        topBorder.backgroundColor = color.CGColor
        topBorder.frame = CGRectMake(0, 0, self.bounds.width, height)
        self.layer.addSublayer(topBorder)
    }
}

public extension UIStoryboard {
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}

public extension String {
    func stringByRemovingOccurrencesOfCharacters(chars: String) -> String {
        let cs = characters.filter {
            chars.characters.indexOf($0) == nil
        }
        
        return String(cs)
    }
    
    func replace(target: String, withString: String) -> String {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    var capitalizeFirst:String {
        var result = self
        result.replaceRange(startIndex...startIndex, with: String(self[startIndex]).capitalizedString)
        return result
    }
    
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[start..<end]
    }
    
    func removeCharsFromEnd(count_:Int) -> String {
        let stringLength = self.characters.count
        
        let substringIndex = (stringLength < count_) ? 0 : stringLength - count_
        
        return self.substringToIndex(self.startIndex.advancedBy(substringIndex))
    }
}

public extension UILabel {
    func resizeHeightToFit(heightConstraint: NSLayoutConstraint) {
        let attributes = [NSFontAttributeName : font]
        numberOfLines = 0
        lineBreakMode = NSLineBreakMode.ByWordWrapping
        let rect = text!.boundingRectWithSize(CGSizeMake(frame.size.width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil)
        heightConstraint.constant = rect.height
        setNeedsLayout()
    }
    
    var substituteFontName : String {
        get { return self.font.fontName }
        set { self.font = UIFont(name: newValue, size: self.font.pointSize) }
    }
}

public extension UIImage {
    class func imageWithImage(image: UIImage, scaledToScale scale: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, true, scale)
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetInterpolationQuality(context, .High)
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    var circle: UIImage {
        let square = size.width < size.height ? CGSize(width: size.width, height: size.width) : CGSize(width: size.height, height: size.height)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = square.width/50
        imageView.layer.borderColor = CGColorCreateCopyWithAlpha(UIColor.whiteColor().CGColor, 0.75)
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

var ActionBlockKey: UInt8 = 0
public typealias BlockButtonActionBlock = (sender: UIButton) -> Void

public class ActionBlockWrapper : NSObject {
    var block : BlockButtonActionBlock
    init(block: BlockButtonActionBlock) {
        self.block = block
    }
}

public extension UIButton {
    func setActionBlock(block: BlockButtonActionBlock) {
        objc_setAssociatedObject(self, &ActionBlockKey, ActionBlockWrapper(block: block), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(self, action: "handleActionBlock:", forControlEvents: .TouchUpInside)
    }
    
    func handleActionBlock(sender: UIButton) {
        let wrapper = objc_getAssociatedObject(self, &ActionBlockKey) as! ActionBlockWrapper
        wrapper.block(sender: sender)
    }
}