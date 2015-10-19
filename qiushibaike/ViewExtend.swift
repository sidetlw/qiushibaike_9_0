//
//  uiImageViewExtend.swift
//  qiushibaike
//
//  Created by test on 9/1/15.
//  Copyright (c) 2015 Mrtang. All rights reserved.
//
import Foundation
import UIKit

extension UIImageView {
   // var imageURL:String = ""
}

extension UILabel {
    func requiredHeight() -> CGFloat {
        let label:UILabel = UILabel(frame:CGRectMake(0,0,self.frame.width,CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = self.font
        label.text = self.text
        
        label.sizeToFit()
        
        return label.frame.height
    }
}