//
//  mainTableViewCell.swift
//  qiushibaike
//
//  Created by test on 9/1/15.
//  Copyright (c) 2015 Mrtang. All rights reserved.
//

import UIKit

class mainTableViewCell: UITableViewCell {
    
    var imageURL:String?
    var photoimage:UIImageView!

    //@IBOutlet weak var pictureTopConstraint: NSLayoutConstraint!
    //@IBOutlet weak var bottomViewVonatraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        photoimage = self.viewWithTag(104) as! UIImageView
        
        var imageTapGuesture = UITapGestureRecognizer(target: self, action: "imageViewTapped")
        self.photoimage.userInteractionEnabled = true
        self.photoimage.addGestureRecognizer(imageTapGuesture)
        self.photoimage.hidden = true
        //var rect1:CGRect = CGRectMake(0, 0, 0, 0)
        //self.photoimage.frame = rect1

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func imageViewTapped() {
        //var vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("mainViewController") as! UIViewController
        //vc.hidesBottomBarWhenPushed = true
        NSNotificationCenter.defaultCenter().postNotificationName("imageViewTapped", object:self.imageURL!)
     
    }
}
