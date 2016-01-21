//
//  mainTableViewCell.swift
//  qiushibaike
//
//  Created by test on 9/1/15.
//  Copyright (c) 2015 Mrtang. All rights reserved.
//

import UIKit
import Alamofire

class mainTableViewCell: UITableViewCell {
    
    var mainView:UIView?
    var imageURL:String?
    var photoimage:UIImageView!
    @IBOutlet weak var bottomView: UIView!
    //@IBOutlet weak var pictureTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewVonatraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        photoimage = self.viewWithTag(104) as! UIImageView
        
        let imageTapGuesture = UITapGestureRecognizer(target: self, action: "imageViewTapped")
        self.photoimage.userInteractionEnabled = true
        self.photoimage.addGestureRecognizer(imageTapGuesture)
        self.photoimage.hidden = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func imageViewTapped() {
        //var vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("mainViewController") as! UIViewController
        //vc.hidesBottomBarWhenPushed = true
       let photoPoint = self.photoimage.convertPoint(CGPointZero, toView: self.mainView!)
       // var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]

        var dictionary: [String: String] = [String: String]() //= ["imageUrl": self.imageURL, "photoPoint": photoPoint]
        dictionary["imageUrl"] = self.imageURL
        dictionary["photoPointX"] = String( photoPoint.x )
        dictionary["photoPointY"] = String( photoPoint.y )

        NSNotificationCenter.defaultCenter().postNotificationName("imageViewTapped", object:dictionary)
        
     
    }
}
