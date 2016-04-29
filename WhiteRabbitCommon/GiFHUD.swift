//
//  GiFHUD.swift
//  GiFHUD-Swift
//
//  Created by Cem Olcay on 07/11/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import ImageIO
import MobileCoreServices


class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
}

// MARK: - UIImageView Extension

extension UIImageView {
    
    // MARK: Computed Properties
    
    var animatableImage: AnimatedImage? {
        if image is AnimatedImage {
            return image as? AnimatedImage
        } else {
            return nil
        }
    }
    
    var isAnimatingGif: Bool {
        return animatableImage?.isAnimating() ?? false
    }
    
    var animatable: Bool {
        return animatableImage != nil
    }
    
    
    // MARK: Method Overrides
    
    override public func displayLayer(layer: CALayer) {
        if let image = animatableImage {
            if let frame = image.currentFrame {
                layer.contents = frame.CGImage
            }
        }
    }
    
    
    // MARK: Setter Methods
    
    func setAnimatableImage(named name: String) {
        image = AnimatedImage.imageWithName(name, delegate: self)
        layer.setNeedsDisplay()
    }
    
    func setAnimatableImage(data data: NSData) {
        image = AnimatedImage.imageWithData(data, delegate: self)
        layer.setNeedsDisplay()
    }
    
    
    // MARK: Animation
    
    func startAnimatingGif() {
        if animatable {
            animatableImage!.resumeAnimation()
        }
    }
    
    func stopAnimatingGif() {
        if animatable {
            animatableImage!.pauseAnimation()
        }
    }
    
}


// MARK: - UIImage Extension

class AnimatedImage: UIImage {
    
    func CGImageSourceContainsAnimatedGIF(imageSource: CGImageSource) -> Bool {
        let isTypeGIF = UTTypeConformsTo(CGImageSourceGetType(imageSource)!, kUTTypeGIF)
        let imageCount = CGImageSourceGetCount(imageSource)
        return isTypeGIF != false && imageCount > 1
    }
    
    func CGImageSourceGIFFrameDuration(imageSource: CGImageSource, index: Int) -> NSTimeInterval {
        let containsAnimatedGIF = CGImageSourceContainsAnimatedGIF(imageSource)
        if !containsAnimatedGIF { return 0.0 }
        
        var duration = 0.0
        let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, Int(index), nil)! as Dictionary
        let GIFProperties: NSDictionary? = imageProperties[String(kCGImagePropertyGIFDictionary)] as? NSDictionary
        
        if let properties = GIFProperties {
            duration = properties[String(kCGImagePropertyGIFUnclampedDelayTime)] as! Double
            
            if duration <= 0 {
                duration = properties[String(kCGImagePropertyGIFDelayTime)] as! Double
            }
        }
        
        let threshold = 0.02 - Double(FLT_EPSILON)
        
        if duration > 0 && duration < threshold {
            duration = 0.1
        }
        
        return duration
    }
    
    
    // MARK: Constants
    
    let framesToPreload = 10
    let maxTimeStep = 1.0
    
    
    // MARK: Public Properties
    
    var delegate: UIImageView?
    var frameDurations = [NSTimeInterval]()
    var frames = [UIImage?]()
    var totalDuration: NSTimeInterval = 0.0
    
    
    // MARK: Private Properties
    
    private lazy var displayLink: CADisplayLink = CADisplayLink(target: self, selector: #selector(AnimatedImage.updateCurrentFrame))
    private lazy var preloadFrameQueue: dispatch_queue_t! = dispatch_queue_create("co.kaishin.GIFPreloadImages", DISPATCH_QUEUE_SERIAL)
    private var currentFrameIndex = 0
    private var imageSource: CGImageSource?
    private var timeSinceLastFrameChange: NSTimeInterval = 0.0
    
    
    // MARK: Computed Properties
    
    var currentFrame: UIImage? {
        return frameAtIndex(currentFrameIndex)
    }
    
    private var isAnimated: Bool {
        return imageSource != nil
    }
    
    
    // MARK: Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init(data: NSData, delegate: UIImageView?) {
        let imageSource = CGImageSourceCreateWithData(data, nil)
        self.delegate = delegate
        
        super.init()
        attachDisplayLink()
        prepareFrames(imageSource)
        pauseAnimation()
    }

    required convenience init(imageLiteral name: String) {
        fatalError("init(imageLiteral:) has not been implemented")
    }
    
    
    // MARK: Factories
    
    class func imageWithName(name: String, delegate: UIImageView?) -> Self? {
        let path = (NSBundle.mainBundle().bundlePath as NSString).stringByAppendingPathComponent(name)
        let data = NSData (contentsOfFile: path)
        return (data != nil) ? imageWithData(data!, delegate: delegate) : nil
    }
    
    class func imageWithData(data: NSData, delegate: UIImageView?) -> Self? {
        return self.init(data: data, delegate: delegate)
    }
    
    
    // MARK: Display Link Helpers
    
    func attachDisplayLink() {
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    
    // MARK: Frame Methods
    
    private func prepareFrames(source: CGImageSource!) {
        imageSource = source
        
        let numberOfFrames = Int(CGImageSourceGetCount(self.imageSource!))
        frameDurations.reserveCapacity(numberOfFrames)
        frames.reserveCapacity(numberOfFrames)
        
        for index in 0..<numberOfFrames {
            let frameDuration = CGImageSourceGIFFrameDuration(source, index: index)
            frameDurations.append(frameDuration)
            totalDuration += frameDuration
            
            if index < framesToPreload {
                let frameImageRef = CGImageSourceCreateImageAtIndex(self.imageSource!, Int(index), nil)
                let frame = UIImage(CGImage: frameImageRef!, scale: 0.0, orientation: UIImageOrientation.Up)
                frames.append(frame)
            } else {
                frames.append(nil)
            }
        }
    }
    
    func frameAtIndex(index: Int) -> UIImage? {
        if Int(index) >= self.frames.count { return nil }
        
        let image: UIImage? = self.frames[Int(index)]
        updatePreloadedFramesAtIndex(index)
        
        return image
    }
    
    private func updatePreloadedFramesAtIndex(index: Int) {
        if frames.count <= framesToPreload { return }
        
        if index != 0 {
            frames[index] = nil
        }
        
        for internalIndex in (index + 1)...(index + framesToPreload) {
            let adjustedIndex = internalIndex % frames.count
            
            if frames[adjustedIndex] == nil {
                dispatch_async(preloadFrameQueue) {
                    let frameImageRef = CGImageSourceCreateImageAtIndex(self.imageSource!, Int(adjustedIndex), nil)
                    self.frames[adjustedIndex] = UIImage(CGImage: frameImageRef!)
                }
            }
        }
    }
    
    func updateCurrentFrame() {
        if !isAnimated { return }
        
        timeSinceLastFrameChange += min(maxTimeStep, displayLink.duration)
        let frameDuration = frameDurations[currentFrameIndex]
        
        while timeSinceLastFrameChange >= frameDuration {
            timeSinceLastFrameChange -= frameDuration
            currentFrameIndex += 1
            
            if currentFrameIndex >= frames.count {
                currentFrameIndex = 0
            }
            
            delegate?.layer.setNeedsDisplay()
        }
    }
    
    
    // MARK: Animation
    
    func pauseAnimation() {
        displayLink.paused = true
    }
    
    func resumeAnimation() {
        displayLink.paused = false
    }
    
    func isAnimating() -> Bool {
        return !displayLink.paused
    }
}


// MARK: - GiFHUD

class GiFHUD: UIView {
    
    // MARK: Constants
    
    var Height            : CGFloat           = 300
    var Width            : CGFloat           = 300
    let FadeDuration    : NSTimeInterval    = 0.3
    let GifSpeed        : CGFloat           = 0.3
    let OverlayAlpha    : CGFloat           = 0.3
    let Window          : UIWindow = (UIApplication.sharedApplication().delegate as! AppDelegate).window!
    
    
    // MARK: Variables
    
    var overlayView     : UIView?
    var imageView       : UIImageView?
    var shown           : Bool
    private var tapGesture: UITapGestureRecognizer?
    private var didTapClosure: (() -> Void)?
    private var swipeGesture: UISwipeGestureRecognizer?
    private var didSwipeClosure: (() -> Void)?
    
    // MARK: Singleton
    
    class var instance : GiFHUD {
        struct Static {
            static let inst : GiFHUD = GiFHUD ()
        }
        return Static.inst
    }
    
    
    // MARK: Init
    
    init () {
        self.shown = false
        super.init(frame: CGRect (x: 0, y: 0, width: Width, height: Height))
        
        alpha = 0
        center = Window.center
        clipsToBounds = false
        layer.backgroundColor = UIColor (white: 0, alpha: 0.5).CGColor
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        imageView = UIImageView (frame: CGRectInset(bounds, 20, 20))
        addSubview(imageView!)
        
        Window.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reframe() {
//        self.frame = CGRectMake(0, 0, Width, Height)
    }
    
    
    // MARK: HUD
    
    class func showWithOverlay () {
        dismiss ({
            self.instance.Window.addSubview(self.instance.overlay())
            self.show()
        })
    }
    
    class func show () {
        if (!self.instance.shown) {
            dismiss({
                
                if let _ = self.instance.imageView?.animationImages {
                    self.instance.imageView?.startAnimating()
                } else {
                    self.instance.imageView?.startAnimatingGif()
                }
                
                self.instance.Window.bringSubviewToFront(self.instance)
                self.instance.shown = true
                self.instance.fadeIn()
            })
        }
    }
    
    class func showForSeconds (seconds: Double) {
        show()
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), {
            GiFHUD.dismiss()
        })
    }
    
    class func dismissOnTap (didTap: (() -> Void)? = nil) {
        self.instance.tapGesture = UITapGestureRecognizer(target: self, action: #selector(GiFHUD.userTapped))
        self.instance.addGestureRecognizer(self.instance.tapGesture!)
        self.instance.didTapClosure = didTap
    }

    @objc private class func userTapped () {
        GiFHUD.dismiss()
        self.instance.tapGesture = nil
        self.instance.didTapClosure?()
        self.instance.didTapClosure = nil
    }
    
    class func dismissOnSwipe (didTap: (() -> Void)? = nil) {
        self.instance.swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(GiFHUD.userSwiped))
        self.instance.addGestureRecognizer(self.instance.swipeGesture!)
    }
    
    @objc private class func userSwiped () {
        GiFHUD.dismiss()
        self.instance.swipeGesture = nil
        self.instance.didSwipeClosure?()
        self.instance.didSwipeClosure = nil
    }

    class func dismiss () {
        if (!self.instance.shown) {
            return
        }
        
        self.instance.overlay().removeFromSuperview()
        self.instance.fadeOut()
        
        if let _ = self.instance.imageView?.animationImages {
            self.instance.imageView?.stopAnimating()
        } else {
            self.instance.imageView?.stopAnimatingGif()
        }
    }
    
    class func dismiss (complete: ()->Void) {
        if (!self.instance.shown) {
            return complete()
        }
        
        self.instance.fadeOut({
            self.instance.overlay().removeFromSuperview()
            complete()
        })
        
        if let _ = self.instance.imageView?.animationImages {
            self.instance.imageView?.stopAnimating()
        } else {
            self.instance.imageView?.stopAnimatingGif()
        }
    }
    
    
    // MARK: Effects
    
    func fadeIn () {
        imageView?.startAnimatingGif()
        UIView.animateWithDuration(FadeDuration, animations: {
            self.alpha = 1
        })
    }
    
    func fadeOut () {
        UIView.animateWithDuration(FadeDuration, animations: {
            self.alpha = 0
            }, completion: { (complate) in
                self.shown = false
                self.imageView?.stopAnimatingGif()
        })
    }
    
    func fadeOut (complated: ()->Void) {
        UIView.animateWithDuration(FadeDuration, animations: {
            self.alpha = 0
            }, completion: { (complate) in
                self.shown = false
                self.imageView?.stopAnimatingGif()
                complated ()
        })
    }
    
    func overlay () -> UIView {
        if (overlayView == nil) {
            overlayView = UIView (frame: Window.frame)
            overlayView?.backgroundColor = UIColor.blackColor()
            overlayView?.alpha = 0
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.overlayView!.alpha = self.OverlayAlpha
            })
        }
        
        return overlayView!
    }
    
    
    // MARK: Gif
    
    class func setGif (name: String) {
        
        self.instance.imageView?.animationImages = nil
        self.instance.imageView?.stopAnimating()
        
        self.instance.imageView?.image = AnimatedImage.imageWithName(name, delegate: self.instance.imageView)
    }
    
    class func setGifBundle (bundle: NSBundle) {
        self.instance.imageView?.animationImages = nil
        self.instance.imageView?.stopAnimating()
        
        self.instance.imageView?.image = AnimatedImage (data: NSData(contentsOfURL: bundle.resourceURL!)!, delegate: nil)
    }
    
    class func setGifImages (images: [UIImage]) {
        self.instance.imageView?.stopAnimatingGif()
        
        self.instance.imageView?.animationImages = images
        self.instance.imageView?.animationDuration = NSTimeInterval(self.instance.GifSpeed)
    }
}
