//
//  CommentsViewController.swift
//  qiushibaike
//
//  Created by test on 8/28/15.
//  Copyright (c) 2015 Mrtang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CommentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var jokeID:Int!
    var page:Int = 1
    var dataArray:Array<Dictionary<String,AnyObject>> = []
    var heightOfIndexpath = [CGFloat](count: 100, repeatedValue: 0)
    
    @IBOutlet weak var commentsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        
        loadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80 + heightOfIndexpath[indexPath.row]
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return !(dataArray.isEmpty) ? dataArray.count:0
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentTableCell", forIndexPath: indexPath) as! UITableViewCell
        
        var avatarimage = cell.viewWithTag(201) as! UIImageView
        var nikeLabel = cell.viewWithTag(202) as! UILabel
        var floorLabel = cell.viewWithTag(203) as! UILabel
        var contentsLabel = cell.viewWithTag(204) as! UILabel
        var timeLabel = cell.viewWithTag(205) as! UILabel
        
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
            var timeStamp = user["created_at"] as! Int
            var date = self.dateStringFromTimestamp(timeStamp)
            timeLabel.text = date
            
            var content = dictionary["content"] as! String
            contentsLabel.text = content
            heightOfIndexpath[indexPath.row] = contentsLabel.requiredHeight()
            
            var floor = dictionary["floor"] as! Int
            floorLabel.text = "\(floor)楼"

        
        }
        
        return cell
    }
    
    func dateStringFromTimestamp(timeStamp:Int)->String
    {
        var ts = Double( timeStamp )
        var  formatter = NSDateFormatter ()
        formatter.dateFormat = "yyyy年MM月dd日 HH:MM:ss"
        var date = NSDate(timeIntervalSince1970 : ts)
        return  formatter.stringFromDate(date)
        
    }

    
    func loadData()
    {
        var URL = "http://m2.qiushibaike.com/article/\(self.jokeID)/comments?count=20&page=\(self.page)"
       // dataArray = nil
        Alamofire.request(.GET, URL).responseJSON(){ (_, _, json, error) in
            if error == nil {
                //println(json!)
                self.updateUI(JSON(json!))
                self.page++
            }
            else {
                println("ERROR: " + error!.localizedDescription)
            }
        }

    }
    
    func updateUI(jsonStr:JSON) {
        if let arr = jsonStr["items"].arrayObject {
            
            let arr = arr as! Array<Dictionary<String,AnyObject>>
            for data in arr {
                dataArray.append(data as Dictionary<String,AnyObject>)
            }
            commentsTableView.reloadData()
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
