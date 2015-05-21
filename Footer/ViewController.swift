//
//  ViewController.swift
//  Footer
//
//  Created by Victor on 20/05/15.
//
//

import UIKit

let SHEET_COLOR = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)

let DUMMYIMG_URL = "http://dummyimage.com/100x100/000000/fff.png&text="

class ViewController: UIViewController, UIScrollViewDelegate, LTBounceSheetDelegate {

    var sheet: LTBounceSheet!
    var shown: Bool = false
    var badgeCount:Int = 10
    var currentSelectedBadgeInd:Int = -1
    var badgeLabelWidth:CGFloat = 216
    var badgeWidth:CGFloat = 40

    @IBOutlet var mFooterView: UIView!
    @IBOutlet var mProfileImageView:UIImageView!
    @IBOutlet var mProfileRatingView :JWStarRatingView!
    @IBOutlet var m2ndRowScrView :UIScrollView!
    @IBOutlet var m3rdRowScrView :UIScrollView!
    @IBOutlet var mBadgePreview :UIView!
    @IBOutlet var mBadgePreviewImg1 :UIImageView!
    @IBOutlet var mBadgePreviewImg2 :UIImageView!
    @IBOutlet var mBadgePreviewImg3 :UIImageView!
    @IBOutlet var mPageControl :UIPageControl!
    @IBOutlet var mToggleButton :UIButton!
    @IBOutlet var mMessageView: UIView!
    
    //initialize 2nd scrollview
    func setUp2ndScrollView()
    {
        var centerX : CGFloat = 30
        var ind:Int = 0
        
        for (ind = 0; ind < badgeCount; ind++)
        {
            var imageView = UIImageView(frame: CGRectMake(0, 0, badgeWidth, badgeWidth))
            imageView.tag = ind
            imageView.setImageWithURL(NSURL(string:DUMMYIMG_URL + String(ind + 1) as String))
            imageView.center = CGPointMake(centerX, 30)
            imageView.layer.cornerRadius = imageView.frame.size.width / 2
            imageView.layer.masksToBounds = true
            imageView.userInteractionEnabled = true
            
            var tapGes = UITapGestureRecognizer(target: self, action: "respondToTapGesture:")
            tapGes.numberOfTapsRequired = 1
            imageView.addGestureRecognizer(tapGes)
            
            m2ndRowScrView.addSubview(imageView)
            
            centerX = centerX + 60;
        }

        var label = UILabel(frame: CGRectMake(0, 0, badgeLabelWidth, badgeWidth))
        label.text = "Extended Badge Comment"
        label.textAlignment = NSTextAlignment.Left
        m2ndRowScrView.addSubview(label)
        label.hidden = true
        
        m2ndRowScrView.contentSize = CGSizeMake(centerX - 30, m2ndRowScrView.frame.size.height)
    }
    
    //initialize 3rd scrollview
    func setUp3rdScrollView()
    {
        var centerX : CGFloat = m3rdRowScrView.frame.size.width / 2
        var ind:Int = 0
        for (ind = 0; ind < 5; ind++)
        {
            var ratingView:JWStarRatingView = JWStarRatingView(frame: CGRectMake(0, 0, 128, 30))
            ratingView.center = CGPointMake(centerX, 20)
            ratingView.userInteractionEnabled = false
            m3rdRowScrView.addSubview(ratingView)
            
            var label = UILabel(frame: CGRectMake(0, 0, m3rdRowScrView.frame.size.width, m3rdRowScrView.frame.size.height))
            label.center = CGPointMake(centerX, 50)
            label.text = "This is Comment" + String(ind + 1)
            label.textAlignment = NSTextAlignment.Center
            m3rdRowScrView.addSubview(label)
            
            centerX = centerX + self.view.frame.size.width;
        }
        m3rdRowScrView.contentSize = CGSizeMake(centerX - self.view.frame.size.width / 2, m3rdRowScrView.frame.size.height)
        m3rdRowScrView.delegate = self
        mPageControl.numberOfPages = ind
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        self.sheet = LTBounceSheet(height: mFooterView.frame.size.height, bgColor: SHEET_COLOR)
        mFooterView.frame = CGRectMake(0, 0, mFooterView.frame.size.width, mFooterView.frame.size.height);
        self.sheet.addView(mFooterView)
        
        mProfileImageView.setImageWithURL(NSURL(string: DUMMYIMG_URL + "P"))
        mProfileImageView.layer.cornerRadius = mProfileImageView.frame.size.width/2
        mProfileImageView.layer.masksToBounds = true;
        
        mBadgePreviewImg1.setImageWithURL(NSURL(string: DUMMYIMG_URL + "1"))
        mBadgePreviewImg1.layer.cornerRadius = mBadgePreviewImg1.frame.size.width/2
        mBadgePreviewImg1.layer.masksToBounds = true;

        mBadgePreviewImg2.setImageWithURL(NSURL(string: DUMMYIMG_URL + "2"))
        mBadgePreviewImg2.layer.cornerRadius = mBadgePreviewImg2.frame.size.width/2
        mBadgePreviewImg2.layer.masksToBounds = true;

        mBadgePreviewImg3.setImageWithURL(NSURL(string: DUMMYIMG_URL + "3"))
        mBadgePreviewImg3.layer.cornerRadius = mBadgePreviewImg3.frame.size.width/2
        mBadgePreviewImg3.layer.masksToBounds = true;

        
        sheet.setDelegate(self)
        
        mMessageView.center = CGPointMake(CGFloat(self.view.frame.size.width / 2),  self.view.frame.size.height - sheet.getFooter() - mMessageView.frame.height / 2 )
        
        setUp2ndScrollView()
        setUp3rdScrollView()
    }
    
    @IBAction func onPageControl(sender: UIPageControl)
    {
        var selectedInd:CGFloat = CGFloat(sender.currentPage)
        m3rdRowScrView.contentOffset = CGPointMake(selectedInd * m3rdRowScrView.frame.size.width, 0)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        var selInd:Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        mPageControl.currentPage = selInd;
    }
    
    //expand badge with label when badge is tapped
    func respondToTapGesture(gesture: UISwipeGestureRecognizer)
    {
        var imageView:UIImageView = gesture.view as! UIImageView
        var selectedInd:Int = imageView.tag
        
        var commentLabel = Array(m2ndRowScrView.subviews)[badgeCount] as! UILabel
        
        var centerX : CGFloat = 30
        var ind:Int = 0
        if currentSelectedBadgeInd == selectedInd
        {
            for (ind = 0; ind < badgeCount; ind++)
            {
                var subView:UIImageView = Array(m2ndRowScrView.subviews)[ind] as! UIImageView
                subView.center = CGPointMake(centerX, 30)
                centerX = centerX + 60
            }
            
            commentLabel.hidden = true
            
            currentSelectedBadgeInd = -1
        }
        else
        {
            for (ind = 0; ind < badgeCount; ind++)
            {
                var subView:UIImageView = Array(m2ndRowScrView.subviews)[ind] as! UIImageView
                subView.center = CGPointMake(centerX, 30)

                if ind == selectedInd
                {
                    m2ndRowScrView.contentOffset = CGPointMake(subView.center.x - badgeWidth / 2 - 10, 0)

                    commentLabel.center = CGPointMake(centerX + badgeLabelWidth / 2 + badgeWidth / 2 + 10, 30)
                    centerX = centerX + badgeLabelWidth
                }
                
                centerX = centerX + 60
            }
            
            commentLabel.hidden = false

            currentSelectedBadgeInd = selectedInd
        }
        
        m2ndRowScrView.contentSize = CGSizeMake(centerX - 30, m2ndRowScrView.frame.size.height)

    }
    
    //delegate function for sheet animation completion
    func onSheetAnimationEnded()
    {
        if shown == true
        {
            mBadgePreview.hidden = false
            mProfileRatingView.hidden = true
            mToggleButton.hidden = false
            shown = false
            mMessageView.center = CGPointMake(CGFloat(self.view.frame.size.width / 2),  self.view.frame.size.height - sheet.getFooter() - mMessageView.frame.height / 2 )
        }
        else
        {
            mBadgePreview.hidden = true
            mProfileRatingView.hidden = false
            mToggleButton.hidden = true
            shown = true
            mMessageView.center = CGPointMake(CGFloat(self.view.frame.size.width / 2),  sheet.center.y - sheet.frame.size.height / 2 - mMessageView.frame.height / 2 )
        }
    }
    
    @IBAction func onShowSheet(sender:UIButton)
    {
        if shown == true
        {
            sheet.hide();
        }
        else
        {
            sheet.show();
        }
    }
}