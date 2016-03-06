//
//  CircularProgressLayer.swift
//  CircularProgress
//
//  Created by  lifirewolf on 16/3/3.
//  Copyright © 2016年  lifirewolf. All rights reserved.
//

import UIKit

class CircularProgressLayer: CALayer {
    
    var trackTintColor: UIColor!
    var progressTintColor: UIColor!
    var innerTintColor: UIColor!
    var roundedCorners = false
    var thicknessRatio = CGFloat(0)
    var progress = CGFloat(0)
    var clockwiseProgress = false
    
    override class func needsDisplayForKey(key: String) -> Bool {
        if key == "progress" {
            return true
        } else {
            return super.needsDisplayForKey(key)
        }
    }
    
    override func drawInContext(context: CGContext) {
        
        let rect = bounds
        let centerPoint = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0)
        let radius = min(rect.size.height, rect.size.width) / 2.0
        
        let progress = min(self.progress, CGFloat(1.0 - FLT_EPSILON))
        var radians = CGFloat(0)
        if clockwiseProgress {
            radians = CGFloat((Double(progress) * 2.0 * M_PI) - M_PI_2)
        } else {
            radians = CGFloat(3 * M_PI_2 - (Double(progress) * 2.0 * M_PI))
        }
        
        CGContextSetFillColorWithColor(context, trackTintColor.CGColor)
        let trackPath = CGPathCreateMutable()
        CGPathMoveToPoint(trackPath, nil, centerPoint.x, centerPoint.y)
        CGPathAddArc(trackPath, nil, centerPoint.x, centerPoint.y, radius, CGFloat(2.0 * M_PI), 0.0, true)
        CGPathCloseSubpath(trackPath)
        CGContextAddPath(context, trackPath)
        CGContextFillPath(context)
        
        if progress > 0.0 {
            CGContextSetFillColorWithColor(context, progressTintColor.CGColor)
            let progressPath = CGPathCreateMutable()
            CGPathMoveToPoint(progressPath, nil, centerPoint.x, centerPoint.y);
            CGPathAddArc(progressPath, nil, centerPoint.x, centerPoint.y, radius, CGFloat(3.0 * M_PI_2), radians, !clockwiseProgress)
            CGPathCloseSubpath(progressPath)
            CGContextAddPath(context, progressPath)
            CGContextFillPath(context)
        }
        
        if progress > 0.0 && roundedCorners {
            let pathWidth = radius * thicknessRatio
            let xOffset = radius * (1.0 + ((1.0 - (thicknessRatio / 2.0)) * cos(radians)))
            let yOffset = radius * (1.0 + ((1.0 - (thicknessRatio / 2.0)) * sin(radians)))
            let endPoint = CGPointMake(xOffset, yOffset)
            
            let startEllipseRect = CGRect(x: centerPoint.x - pathWidth / 2.0, y: 0, width: pathWidth, height: pathWidth)
            CGContextAddEllipseInRect(context, startEllipseRect)
            CGContextFillPath(context)
            
            let endEllipseRect = CGRect(x: endPoint.x - pathWidth / 2.0, y: endPoint.y - pathWidth / 2.0, width: pathWidth, height: pathWidth)
            CGContextAddEllipseInRect(context, endEllipseRect)
            CGContextFillPath(context)
        }
        
        CGContextSetBlendMode(context, CGBlendMode.Clear)
        let innerRadius = radius * (1.0 - thicknessRatio)
        let clearRect = CGRect(x: centerPoint.x - innerRadius, y: centerPoint.y - innerRadius, width: innerRadius * 2.0, height: innerRadius * 2.0)
        CGContextAddEllipseInRect(context, clearRect)
        CGContextFillPath(context)
        
        if self.innerTintColor != nil {
            CGContextSetBlendMode(context, CGBlendMode.Normal)
            CGContextSetFillColorWithColor(context, innerTintColor.CGColor)
            CGContextAddEllipseInRect(context, clearRect)
            CGContextFillPath(context)
        }
    }
    
}
