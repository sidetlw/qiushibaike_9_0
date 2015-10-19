//
//  ViewController.swift
//  qiushibaike
//
//  Created by test on 8/28/15.
//  Copyright (c) 2015 Mrtang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var freshButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
        
    var imageURL:String = ""
    var page:Int = 1
    var dataArray:Array<Dictionary<String,AnyObject>> = []
    var largeImageURL:String = ""
    var largeImageURLArry = [String]()
    var jokeid:Int!
    var labelHeightOfIndex = [CGFloat]()
    var imageHeightOfIndex = [CGFloat](count: 100, repeatedValue: 162.0)
    
    @IBOutlet var testimage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mainTableView.dataSource = self
        mainTableView.delegate = self
        self.indicator.hidden = true
        
        largeImageURLArry.reserveCapacity(100)
        largeImageURLArry = [String](count: 100, repeatedValue: "")
        
        labelHeightOfIndex.reserveCapacity(100)
        labelHeightOfIndex = [CGFloat](count: 100, repeatedValue: 0.0)
        
        //imageHeightOfIndex.reserveCapacity(100)
       // imageHeightOfIndex = [CGFloat](count: 100, repeatedValue: 0.0)

        
        loadTableViewData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "imageViewTapped", object:nil)
        
    }
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "imageViewTapped:", name: "imageViewTapped", object: nil)
        
    }
    
    
    @IBAction func close(segue: UIStoryboardSegue) {
        
    }
    
   func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.imageHeightOfIndex[indexPath.row] == 0.0 {
                // return 43 + 5 + labelHeightOfIndex[indexPath.row] + 8 + 33
            return labelHeightOfIndex[indexPath.row] + 90
        }
        else {
            return 43 + 5 + labelHeightOfIndex[indexPath.row] + 8 + 162 + 8 + 33
            }
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       /* if !(dataArray.isEmpty) {
            largeImageURLArry.reserveCapacity(dataArray.count + 10)
            largeImageURLArry = [String](count: (dataArray.count + 10), repeatedValue: "")
            
            labelHeightOfIndex.reserveCapacity(dataArray.count + 10)
            labelHeightOfIndex = [CGFloat](count: (dataArray.count + 10), repeatedValue: 0.0)
            
            imageHeightOfIndex.reserveCapacity(dataArray.count + 10)
            imageHeightOfIndex = [CGFloat](count: (dataArray.count + 10), repeatedValue: 0.0)
            
        }
        else {
            largeImageURLArry.reserveCapacity(100)
            largeImageURLArry = [String](count: 100, repeatedValue: "")
            
            labelHeightOfIndex.reserveCapacity(100)
            labelHeightOfIndex = [CGFloat](count: 100, repeatedValue: 0.0)
            
            imageHeightOfIndex.reserveCapacity(100)
            imageHeightOfIndex = [CGFloat](count: 100, repeatedValue: 0.0)
            
        }*/
        return !(dataArray.isEmpty) ? dataArray.count:0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let dictionary:Dictionary<String,AnyObject> = dataArray![indexPath.row]
        let dictionary:Dictionary<String,AnyObject> = dataArray[indexPath.row]
        if let jokeid = dictionary["id"] as? Int {
            self.jokeid = jokeid
            self.performSegueWithIdentifier("segueToCommentsView", sender: self)

        }
        println(indexPath.row)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mainTableViewCell", forIndexPath: indexPath) as! mainTableViewCell
        var avatarimage = cell.viewWithTag(101) as! UIImageView
        var nikeLabel = cell.viewWithTag(102) as! UILabel
        var contendLabel = cell.viewWithTag(103) as! UILabel
        //var photoimage = cell.viewWithTag(104) as! UIImageView
        var commentsLabel = cell.viewWithTag(105) as! UILabel
        
        var commentsTapGuesture = UITapGestureRecognizer(target: self, action: "commentsLabelTapped")
        commentsLabel.userInteractionEnabled = true
        commentsLabel.addGestureRecognizer(commentsTapGuesture)

       let dictionary:Dictionary<String,AnyObject> = dataArray[indexPath.row]
        if let user:Dictionary<String,AnyObject> = dictionary["user"] as? Dictionary<String, AnyObject> {
            nikeLabel.text = user["login"] as? String //昵称
            
            var userIcon = user["icon"] as? String
            if let testid = user["id"] as? Int {
                var id = String( stringInterpolationSegment: testid )
                if !(id.isEmpty) {
                  var preId = id.substringToIndex(advance(id.startIndex, count(id) - 4))
                    var userImageURL = "http://pic.qiushibaike.com/system/avtnew/\(preId)/\(id)/medium/\((userIcon)!)"
                    Alamofire.request(.GET, userImageURL).response(){ (_,_,data,error) in
                        if let image = UIImage(data: data!) {
                            avatarimage.image = image
                        }
                    }
                }
            }//头像
        }
        
        if let content = dictionary["content"] as? String {
                    contendLabel.text = content
                   // contendLabel.sizeToFit()
                    contendLabel.lineBreakMode = .ByWordWrapping
                    contendLabel.numberOfLines = 0
            
                    labelHeightOfIndex[indexPath.row] = contendLabel.requiredHeight()
        }
        
        if let image =  dictionary["image"] as? String {
                            if let testid = dictionary["id"] as? Int {
                    var id = String( stringInterpolationSegment: testid )
                    var preId = id.substringToIndex(advance(id.startIndex, count(id) - 4))
                     var imagURL = "http://pic.qiushibaike.com/system/pictures/\(preId)/\(id)/small/\((image))"
                
                                cell.photoimage.hidden = false
                               // self.imageHeightOfIndex[indexPath.row] = 162.0
                               // cell.bottomViewVonatraint.constant = 178

                Alamofire.request(.GET, imagURL).response(){ (_,_,data,error) in
                    if let image = UIImage(data: data!) {
                        cell.photoimage.image = image
                        
                    }
                }
                self.largeImageURL = "http://pic.qiushibaike.com/system/pictures/\(preId)/\(id)/medium/\(image)"
               // largeImageURLArry.insert(largeImageURL, atIndex: indexPath.row)
                    largeImageURLArry[indexPath.row] = largeImageURL
                    cell.imageURL = largeImageURL
                }
        }
        else {
            cell.photoimage.hidden = true
           self.imageHeightOfIndex[indexPath.row] = 0.0
            //cell.bottomViewVonatraint.constant = 8

            //var rect1:CGRect = CGRectMake(cell.photoimage.frame.origin.x, cell.photoimage.frame.origin.y, 0, 0)
            //cell.photoimage.frame = rect1
            
        }
        let comments_count = dictionary["comments_count"] as! Int
        commentsLabel.text = String( "评论(\(comments_count))" )
        
        cell.setNeedsUpdateConstraints()
        cell.setNeedsLayout()
        return cell
    }
    

    
    func commentsLabelTapped(/*jokeID:String*/) {
       // self.performSegueWithIdentifier("segueToCommentsView", sender: self)
    }
    @IBAction func freshButtonClicked(sender: AnyObject) {
        self.freshButton.hidden = true
        indicator.hidden = false
        indicator.startAnimating()
        loadTableViewData()
    }
    
    func loadTableViewData () {
        //dataArray = nil
        //let URL = "http://m2.qiushibaike.com/article/list/latest?count=20&page=\(page)" //最新
      let URL = "http://m2.qiushibaike.com/article/list/suggest?count=20&page=\(page)"  //最热
        //let URL = "http://m2.qiushibaike.com/article/list/imgrank?count=20&page=\(page)"  //有图
        Alamofire.request(.GET, URL).responseJSON(){ (_, _, json, error) in
            if error == nil {
                //println(json!)
                self.updateUI(JSON(json!))
                self.page++
                self.freshButton.hidden = false
                self.indicator.hidden = true
                self.indicator.stopAnimating()
                }
            else {
                println("ERROR: " + error!.localizedDescription)
            }
        }
    }
    
    func updateUI(jsonStr:JSON) {
        if let arr = jsonStr["items"].arrayObject {
            let arr1 = arr as! Array<Dictionary<String,AnyObject>>
            for data in arr1 {
                dataArray.append( data as Dictionary<String,AnyObject> )
            }
        mainTableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
       // mainTableView.reloadData()
        mainTableView.setNeedsUpdateConstraints()
        mainTableView.setNeedsLayout()
    }
    
    func imageViewTapped(noti:NSNotification)
    {
        /*
        var photoVC = PhotoViewController()
        photoVC.imageURL = noti.object as! String
        self.navigationController?.pushViewController(photoVC, animated: true)
        */
        
        self.largeImageURL = noti.object as! String
        self.performSegueWithIdentifier("segueToPhotoView", sender: self)
       
    }
    
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         if segue.identifier == "segueToCommentsView" {
            var commentVC = segue.destinationViewController as! CommentsViewController
            commentVC.jokeID = self.jokeid
        }
        else if segue.identifier == "segueToPhotoView" {
            var photoVC = segue.destinationViewController as! PhotoViewController
            photoVC.imageURL = self.largeImageURL
        }
    }

}

