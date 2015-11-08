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
    var labelHeightOfIndex = [CGFloat](count: 25, repeatedValue: 0)
    var imageHeightOfIndex = [CGFloat](count: 25, repeatedValue: 180.0)
    var startIndex = 0
    var blackImageView:UIView!
    var animateimageView:UIView!
    var tempx:Int!
    var tempy:Int!
    
    @IBOutlet var testimage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mainTableView.dataSource = self
        mainTableView.delegate = self
        self.indicator.hidden = true
        
        largeImageURLArry.reserveCapacity(25)
        largeImageURLArry = [String](count: 25, repeatedValue: "")
        
        labelHeightOfIndex.reserveCapacity(25)
        labelHeightOfIndex = [CGFloat](count: 25, repeatedValue: 0.0)
        
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
        let dictionary:Dictionary<String,AnyObject> = dataArray[indexPath.row]
        if let _ =  dictionary["image"] as? String {
            return 43 + 5 + self.labelHeightOfIndex[indexPath.row] + 8 + 180 + 8 + 33
        }
        else {
            return self.labelHeightOfIndex[indexPath.row ] + 90
    }
    }


    
    
    /*
    if self.imageHeightOfIndex[indexPath.row ] == 0.0 {
                // return 43 + 5 + labelHeightOfIndex[indexPath.row] + 8 + 33
            return self.labelHeightOfIndex[indexPath.row ] + 90
            }
        else {
        
            return 43 + 5 + self.labelHeightOfIndex[indexPath.row] + 8 + 180 + 8 + 33
            }
*/
    



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
        print(indexPath.row)
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
                  var preId = id.substringToIndex(id.startIndex.advancedBy(id.characters.count - 4))
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
                    var preId = id.substringToIndex(id.startIndex.advancedBy(id.characters.count - 4))
                     var imagURL = "http://pic.qiushibaike.com/system/pictures/\(preId)/\(id)/small/\((image))"
                                cell.photoimage.hidden = false
                               //self.imageHeightOfIndex[indexPath.row] = 162.0
                               cell.bottomViewVonatraint.constant = 190

                Alamofire.request(.GET, imagURL).response(){ (_,_,var data,error) in
                    if let image = UIImage(data: data!) {
                        cell.photoimage.image = image
                    }
                }
                self.largeImageURL = "http://pic.qiushibaike.com/system/pictures/\(preId)/\(id)/medium/\(image)"
               // largeImageURLArry.insert(largeImageURL, atIndex: indexPath.row)
                    largeImageURLArry[indexPath.row] = largeImageURL
                    cell.imageURL = largeImageURL
                    cell.mainView = self.view
                }
        }
        else {
            cell.photoimage.hidden = true
            //cell.photoimage.removeFromSuperview()
           self.imageHeightOfIndex[indexPath.row] = 0.0
            cell.bottomViewVonatraint.constant = 8
            //cell.bottomView.center.y -= 162
        }
        let comments_count = dictionary["comments_count"] as! Int
        commentsLabel.text = String( "评论(\(comments_count))" )

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
       
        Alamofire.request(.GET, URL).responseJSON { response -> Void in
            if response.result.error == nil {
                self.updateUI(JSON(response.result.value!))
                self.page++
                self.freshButton.hidden = false
                self.indicator.hidden = true
                self.indicator.stopAnimating()
            }
            else {
                print("ERROR: " +  response.result.error!.localizedDescription)
            }
        }
    }
    
    func updateUI(jsonStr:JSON) {
        if let arr = jsonStr["items"].arrayObject {
            let arr1 = arr as! Array<Dictionary<String,AnyObject>>
            for data in arr1 {
                dataArray.append( data as Dictionary<String,AnyObject> )
            }
        updateArrayCapatity(dataArray.count)
        mainTableView.reloadData()
        }
    }
    
    func updateArrayCapatity(num:Int) {
        labelHeightOfIndex.reserveCapacity(num)
        imageHeightOfIndex.reserveCapacity(num)
        largeImageURLArry.reserveCapacity(num)
        
        for( var i = self.startIndex ; i < num; i++ ){
            labelHeightOfIndex.append(0.0)
            imageHeightOfIndex.append(180.0)
            largeImageURLArry.append("") 
        }
        self.startIndex = num
    }
            
    
    func imageViewTapped(noti:NSNotification)
    {
        /*
        var photoVC = PhotoViewController()
        photoVC.imageURL = noti.object as! String
        self.navigationController?.pushViewController(photoVC, animated: true)
        */
        
        let dictionary = noti.object as! Dictionary<String,AnyObject>
        self.largeImageURL = dictionary["imageUrl"] as! String
        //self.performSegueWithIdentifier("segueToPhotoView", sender: self)  //这是特效1 实现跳转  下面是特效2
        
        
        var x:String = dictionary["photoPointX"] as! String
        var y:String = dictionary["photoPointY"] as! String
        
        self.tempx = (x as NSString).integerValue
        self.tempy = (y as NSString).integerValue
        
        self.blackImageView = UIView(frame: self.view.frame)
        self.view.addSubview(self.blackImageView)
        self.blackImageView.backgroundColor = UIColor.clearColor()
        UIView.animateWithDuration(0.3) { () -> Void in
            self.blackImageView.backgroundColor = UIColor.blackColor()
        }
        
        
        animateimageView = UIView()
        self.view.addSubview(animateimageView)
        
        let bigPhotoGesture = UITapGestureRecognizer(target: self, action: "bigPhotoGestureTapped")
        let bigPhotoGesture1 = UITapGestureRecognizer(target: self, action: "bigPhotoGestureTapped")

        self.animateimageView.addGestureRecognizer(bigPhotoGesture1)
        self.blackImageView.addGestureRecognizer(bigPhotoGesture)

        
        
        animateimageView.frame = CGRect(x: tempx , y: tempy , width: 181, height: 162)
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: animateimageView.bounds.width, height: animateimageView.bounds.height))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.animateimageView.addSubview(imageView)
        
        var label = UILabel(frame: CGRect(x: 0, y: self.view.bounds.height / 2 + 10, width: self.view.bounds.width, height: 12))
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.text = "加载中..."
        self.view.addSubview(label)
        
        
        Alamofire.request(.GET, self.largeImageURL).response(){ (_,_,data,error) in
            if let image = UIImage(data: data!) {
                imageView.image = image
                label.removeFromSuperview()
            }
        }

        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.animateimageView.frame = CGRect(x: 8, y: self.view.bounds.height / 2 - 250, width: self.view.bounds.width - 16, height: 500)
            
            imageView.frame = CGRect(x: 0, y: 0, width: self.animateimageView.bounds.width, height: self.animateimageView.bounds.height)
            }, completion: nil)
        
        
    }
    
    func bigPhotoGesture1() {
        bigPhotoGestureTapped()
    }
    
    func bigPhotoGestureTapped() {
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.blackImageView.backgroundColor = UIColor.clearColor()
            }) { (_) -> Void in
                self.blackImageView.removeFromSuperview()
        }
        
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.animateimageView.frame = CGRect(x: self.tempx , y: self.tempy , width: 181, height: 162)
            self.animateimageView.subviews[0].frame = CGRect(x: 0, y: 0, width: self.animateimageView.bounds.width, height: self.animateimageView.bounds.height)
            }) { (_) -> Void in
                self.animateimageView.removeFromSuperview()

        }
    }
    
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         if segue.identifier == "segueToCommentsView" {
            let commentVC = segue.destinationViewController as! CommentsViewController
            commentVC.jokeID = self.jokeid
        }
        else if segue.identifier == "segueToPhotoView" {
            let photoVC = segue.destinationViewController as! PhotoViewController
            photoVC.imageURL = self.largeImageURL
        }
    }

}

