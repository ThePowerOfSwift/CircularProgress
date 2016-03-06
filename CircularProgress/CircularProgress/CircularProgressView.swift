//
//  CircularProgressView.swift
//  CircularProgress
//
//  Created by  lifirewolf on 16/3/3.
//  Copyright © 2016年  lifirewolf. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {

    var trackTintColor: UIColor {
        set {
            self.circularProgressLayer.trackTintColor = newValue
            self.circularProgressLayer.setNeedsDisplay()
        }
        get {
            return self.circularProgressLayer.trackTintColor
        }
    }
    
    var progressTintColor: UIColor {
        get {
            return self.circularProgressLayer.progressTintColor
        }
        set {
            self.circularProgressLayer.progressTintColor = newValue
            self.circularProgressLayer.setNeedsDisplay()
        }
    }
    
    var innerTintColor: UIColor? {
        get {
            return self.circularProgressLayer.innerTintColor
        }
        set {
            self.circularProgressLayer.innerTintColor = innerTintColor
            self.circularProgressLayer.setNeedsDisplay()
        }
    }
    
    var roundedCorners: Bool {
        get {
            // differ
            return self.circularProgressLayer.roundedCorners
        }
        set {
            self.circularProgressLayer.roundedCorners = newValue
            self.circularProgressLayer.setNeedsDisplay()
        }
    }
    
    var thicknessRatio: CGFloat {
        get {
            return self.circularProgressLayer.thicknessRatio
        }
        set {
            self.circularProgressLayer.thicknessRatio = min(max(newValue, 0.0), 1.0)
            self.circularProgressLayer.setNeedsDisplay()
        }
    }
    var clockwiseProgress: Bool {
        get {
            return self.circularProgressLayer.clockwiseProgress
        }
        set {
            self.circularProgressLayer.clockwiseProgress = newValue
            self.circularProgressLayer.setNeedsDisplay()
        }
    }
    
    var progress: CGFloat {
        get {
            return circularProgressLayer.progress
        }
        set {
            setProgress(newValue, animated: false)
        }
    }
    
    func setProgress(progress: CGFloat, animated: Bool) {
        setProgress(progress, animated: animated, initialDelay: 0.0)
    }
    
    func setProgress(progress: CGFloat, animated: Bool, initialDelay: CFTimeInterval) {
        let pinnedProgress = min(max(progress, 0.0), 1.0)
        
        setProgress(pinnedProgress, animated: animated, initialDelay: initialDelay, duration: Double(fabs(self.progress - pinnedProgress)))
    }
    
    func setProgress(progress: CGFloat, animated: Bool, initialDelay: CFTimeInterval, duration: CFTimeInterval) {
        
        self.layer.removeAnimationForKey("indeterminateAnimation")
        self.circularProgressLayer.removeAnimationForKey("progress")
        
        let pinnedProgress = min(max(progress, 0.0), 1.0)
        if animated {
            let animation = CABasicAnimation(keyPath: "progress")
            animation.duration = duration
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.fillMode = kCAFillModeForwards
            animation.fromValue = self.progress
            animation.toValue = pinnedProgress
            animation.beginTime = CACurrentMediaTime() + initialDelay
            animation.delegate = self
            self.circularProgressLayer.addAnimation(animation, forKey: "progress")
        } else {
            self.circularProgressLayer.setNeedsDisplay()
            self.circularProgressLayer.progress = pinnedProgress
        }
    }
    
    var indeterminateDuration = CGFloat(0)
    var indeterminate: Bool {
        get {
            let spinAnimation = self.layer.animationForKey("indeterminateAnimation")
            return spinAnimation != nil
        }
        set {
            if newValue {
                if !indeterminate {
                    let spinAnimation = CABasicAnimation(keyPath: "transform.rotation")
                    spinAnimation.byValue = Int(indeterminate ? 2.0*M_PI : -2.0*M_PI)
                    spinAnimation.duration = Double(self.indeterminateDuration)
                    spinAnimation.repeatCount = Float.infinity
                    self.layer.addAnimation(spinAnimation, forKey: "indeterminateAnimation")
                }
            } else {
                self.layer.removeAnimationForKey("indeterminateAnimation")
            }
        }
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override class func initialize () {
        
    }
    
    override class func layerClass() -> AnyClass {
        return CircularProgressLayer.self
    }
    
    var circularProgressLayer: CircularProgressLayer {
        return layer as! CircularProgressLayer
    }
    
    var once: dispatch_once_t = 0
    func setup() {
        
        self.trackTintColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
        
        self.progressTintColor = UIColor.whiteColor()
        self.innerTintColor = nil
        self.backgroundColor = UIColor.clearColor()
        self.thicknessRatio = 0.3
        self.roundedCorners = false
        self.clockwiseProgress = true
        
        self.indeterminateDuration = 2.0
        self.indeterminate = false
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        let windowContentsScale = self.window!.screen.scale
        self.circularProgressLayer.contentsScale = windowContentsScale
        self.circularProgressLayer.setNeedsDisplay()
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        let pinnedProgressNumber = anim.valueForKey("toValue")
        self.circularProgressLayer.progress = CGFloat(pinnedProgressNumber! as! NSNumber)
    }
    
}
