//
//  LTBounceSheet.swift
//  LTBounceSheet
//
//  Created by vale on 5/20/15.
//  Copyright (c) 2015 changweitu@gmail.com. All rights reserved.
//

import UIKit
let duration = Double(0.1)
let sideViewDamping = CGFloat(0.87)
let sideViewVelocity = CGFloat(10)
let centerViewDamping = CGFloat(1.0)
let centerViewVelocity = CGFloat(8)
let footer = CGFloat(75)

protocol LTBounceSheetDelegate
{
    func onSheetAnimationEnded()
}

class LTBounceSheet: UIView {

    private var sideHelperView: UIView!
    private var centerHelperView: UIView!
    private var displayLink: CADisplayLink!
    private var contentView: UIView!
    private var bgColor: UIColor!
    
    private var shown: Bool!
    private var counter: Int!
    private var height: CGFloat!
    private let screenHeight: CGFloat!
    
    private var mDelegate:LTBounceSheetDelegate!
    
    init(height: CGFloat, bgColor: UIColor) {
        
        self.height = height
        self.bgColor = bgColor
        self.counter = 0
        self.shown = false
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = CGRectGetWidth(screenRect)
        screenHeight = CGRectGetHeight(screenRect)
        
        super.init(frame: CGRect(x: 0, y:screenHeight-height , width: screenWidth, height: height))
        
        
        self.contentView = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.contentView.transform = CGAffineTransformMakeTranslation(0, height-footer)
        self.contentView.backgroundColor = bgColor
        self.addSubview(self.contentView)
        
        var swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.contentView.addGestureRecognizer(swipeUp)
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.contentView.addGestureRecognizer(swipeDown)
        
        self.sideHelperView = UIView(frame: CGRectMake(0, height-footer, 0, 0))
        self.sideHelperView.backgroundColor = UIColor.blackColor()
        self.addSubview(self.sideHelperView)
        
        self.centerHelperView = UIView(frame: CGRectMake(screenWidth/2, height-footer, 0, 0))
        self.addSubview(self.centerHelperView)
        
        self.backgroundColor = UIColor.clearColor()
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func respondToSwipeGesture(gesture: UISwipeGestureRecognizer) {
        
        if gesture.direction == UISwipeGestureRecognizerDirection.Up {
            
            self.show()
            
        } else {
            
         
            self.hide()
        }
    }
    func addView(view: UIView) {
        
        self.contentView.addSubview(view)
    }
    
    func toggle() {
        
        if self.shown == true {
            
            self.hide()
            
        } else {
            
            self.show()
            
        }
    }
    
    
    func show() {
        
        if self.counter != 0 {
            
            return
        }
        self.shown = true
        
        self.start()
        self.animateSideHelperViewToPoint(CGPointMake(self.sideHelperView.center.x, 0))
        self.animateCenterHelperViewToPoint(CGPointMake(self.centerHelperView.center.x, 0))
        self.animateContentViewToHeight(0)
        
    }
    
    func hide() {
        
        
        if self.counter != 0 {
            
            return
        }
        self.shown = false
        self.start()
        let height = CGRectGetHeight(self.bounds)
        self.animateSideHelperViewToPoint(CGPointMake(self.sideHelperView.center.x, height-footer))
        self.animateCenterHelperViewToPoint(CGPointMake(self.centerHelperView.center.x, height-footer))
        self.animateContentViewToHeight(self.height-footer)
    }
    
    func animateSideHelperViewToPoint(point: CGPoint) {
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: sideViewDamping, initialSpringVelocity: sideViewVelocity, options: UIViewAnimationOptions(0), animations: { () -> Void in
            
            self.sideHelperView.center = point
            
            }) { (finished: Bool) -> Void in
                
                self.complete()
        }
    
    }
    
    func animateCenterHelperViewToPoint(point: CGPoint) {
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: centerViewDamping, initialSpringVelocity: centerViewVelocity, options: UIViewAnimationOptions(0), animations: { () -> Void in
            
            self.centerHelperView.center = point
            
            }) { (finished: Bool) -> Void in
                
                self.complete()
                self.mDelegate.onSheetAnimationEnded()
        }
    }
    func animateContentViewToHeight(height: CGFloat) {
        
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: centerViewDamping, initialSpringVelocity: centerViewVelocity, options: UIViewAnimationOptions(0), animations: ({
            
            self.contentView.transform = CGAffineTransformMakeTranslation(0, height);
            
        }), completion: nil)
        
    }
    
    func tick(displayLink: CADisplayLink) {
        
        self.setNeedsDisplay()
    }
    
    func start() {
        
        if self.displayLink == nil {
            
            self.displayLink = CADisplayLink(target: self, selector: "tick:")
            self.displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            
            self.counter = 2
        }
    }
    
    func complete() {
        
        self.counter = self.counter-1
        if self.counter==0 {
            
            self.displayLink.invalidate()
            self.displayLink = nil
          
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        if self.counter == 0 {
            
            super.drawRect(rect)
            return
        }
        
        if self.sideHelperView.layer.presentationLayer() != nil {
            
            let sideLayer = self.sideHelperView.layer.presentationLayer() as! CALayer
            let sidePoint = sideLayer.frame.origin
            
            let centerLayer = self.centerHelperView.layer.presentationLayer() as! CALayer
            let centerPoint = centerLayer.frame.origin
            
            let path = UIBezierPath()
            self.bgColor.setFill()
            
            path.moveToPoint(sidePoint)
            path.addQuadCurveToPoint(CGPointMake(320, sidePoint.y), controlPoint: centerPoint)
            path.addLineToPoint(CGPointMake(320, CGRectGetHeight(self.bounds)))
            path.addLineToPoint(CGPointMake(0, CGRectGetHeight(self.bounds)))
            path.closePath()
            path.fill()
        }
    }
    
    func setDelegate(delegate:LTBounceSheetDelegate)
    {
        mDelegate = delegate
    }
    
    func getFooter()->CGFloat
    {
        return footer;
    }
}
