//
//  JWStarRatingView.swift
//  WapaKit
//
//  Created by Joey on 1/21/15.
//  Copyright (c) 2015 Joeytat. All rights reserved.
//

import UIKit

@IBDesignable class JWStarRatingView: UIView {
    
    @IBInspectable var starColor: UIColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1)
    @IBInspectable var starHighlightColor: UIColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 0/255.0, alpha: 1)
    @IBInspectable var starCount:Int = 5
    @IBInspectable var spaceBetweenStar:CGFloat = 5.0
    
    #if TARGET_INTERFACE_BUILDER
        override func willMoveToSuperview(newSuperview: UIView?) {
        let starRating = JWStarRating(frame: self.bounds, starCount: self.starCount, starColor: self.starColor, starHighlightColor: self.starHighlightColor, spaceBetweenStar: self.spaceBetweenStar)
        addSubview(starRating)
    }
    
    #else
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let starRating = JWStarRating(frame: self.bounds, starCount: self.starCount, starColor: self.starColor, starHighlightColor: self.starHighlightColor, spaceBetweenStar: self.spaceBetweenStar)
        starRating.addTarget(self, action: "valueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        addSubview(starRating)
        
    }
    #endif
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let starRating = JWStarRating(frame: frame, starCount: self.starCount, starColor: self.starColor, starHighlightColor: self.starHighlightColor, spaceBetweenStar: self.spaceBetweenStar)
        starRating.addTarget(self, action: "valueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        addSubview(starRating)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func valueChanged(starRating:JWStarRating){
        // Do something with the value...
        println("Value changed \(starRating.ratedStarIndex)")
    }
}