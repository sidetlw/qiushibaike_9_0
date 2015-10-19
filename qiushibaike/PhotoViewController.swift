//
//  PhotoViewController.swift
//  qiushibaike
//
//  Created by test on 8/28/15.
//  Copyright (c) 2015 Mrtang. All rights reserved.
//

import UIKit
import Alamofire

class PhotoViewController: UIViewController,UIScrollViewDelegate{
    var imageURL:String = ""

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var filename = "me"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        /*
        var imageview = UIImageView()
        imageview.contentMode = UIViewContentMode.ScaleAspectFit
        
        var view = UIView(frame: self.view.frame)
        view.backgroundColor = UIColor.blackColor()
        var rect = CGRectMake(0, 20, self.view.frame.width, self.view.frame.height - 20)
        imageview.frame = rect
        view.addSubview(imageview)
        self.view.addSubview(view)
*/
        self.scrollView.delegate = self
       self.scrollView.addSubview(imageview)
        self.scrollView.minimumZoomScale = 1
        self.scrollView.maximumZoomScale = 3
        
        Alamofire.request(.GET, imageURL).response(){ (_,_,data,error) in
            if let image = UIImage(data: data!) {
                self.imageview.image = image
            }
            else {
               self.imageview.image = UIImage(named: self.filename)
            }
        }

        
        
        navigationItem.title = "图片"
        
        var doubleTapGuesture = UITapGestureRecognizer(target: self, action: "doubleTapped:")
        doubleTapGuesture.numberOfTapsRequired = 2
        self.scrollView.addGestureRecognizer(doubleTapGuesture)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageview
        
    }
    
    func doubleTapped(sender:UITapGestureRecognizer) {
        if self.scrollView.zoomScale == 1 {
            var point = sender.locationInView(self.view)
            self.scrollView.zoomToRect(CGRectMake(point.x - 50, point.y - 50, 100, 100), animated: true)
        }
        else {
            self.scrollView.setZoomScale(1, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
