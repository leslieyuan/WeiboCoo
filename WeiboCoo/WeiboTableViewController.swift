//
//  WeiboTableViewController.swift
//  WeiboCoo
//
//  Created by Leslie Yuan on 14/11/12.
//  Copyright (c) 2014年 Yuan's. All rights reserved.
//

import UIKit




class WeiboTableViewController: UITableViewController {
    //Cell 最低高度
    let CELL_TOP_MARGIN = 70
    
    var allItems =  [WeiboData]()
    class var ACCESS_TOKEN: String {
        get {
            let path = NSBundle.mainBundle().pathForResource("Token", ofType: "plist")
            let dic = NSDictionary(contentsOfFile: path!)
            return dic!.valueForKey("token") as String
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "writeWeibo")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshWeibo")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        refreshWeibo()
    }
    
    override func viewWillAppear(animated: Bool) {
        refreshWeibo()
    }
    

    
    //刷新微博
    func refreshWeibo() {
        let urlstring = "https://api.weibo.com/2/statuses/friends_timeline.json?access_token=\(WeiboTableViewController.ACCESS_TOKEN)"
        let url = NSURL(string: urlstring)
        let request = NSURLRequest(URL: url!)
        //清空微博数组
        self.allItems.removeAll(keepCapacity: false)
        //获取所有微博
        if let received = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil) {
            var error: NSError?
            let jsonData = NSJSONSerialization.JSONObjectWithData(received, options: NSJSONReadingOptions(), error: &error) as NSDictionary
            let allWeibos: NSArray = jsonData.valueForKey("statuses") as NSArray
            for weibo in allWeibos  {
                var user: NSDictionary = weibo.valueForKey("user") as NSDictionary
                var wb = WeiboData(useName: user.valueForKey("name") as String,
                    andCreateAt: weibo.valueForKey("created_at") as String,
                    andText: weibo.valueForKey("text") as String,
                    andHeadImageUrl: user.valueForKey("profile_image_url") as String)
                self.allItems.append(wb)
            }
        } else {
            println("Token can't work,it's ridiculous!")
        }
        self.tableView.reloadData()
    }
    
    //Write weibo
    func writeWeibo() {
        //self.performSegueWithIdentifier("WWB", sender: self)
        var writeWeiboVC = self.storyboard?.instantiateViewControllerWithIdentifier("WriteWeibo") as WriteWeiboViewController
        writeWeiboVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(writeWeiboVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return allItems.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let weibo = allItems[indexPath.row]
        var  cell = self.tableView.dequeueReusableCellWithIdentifier("weiboCell") as? MyCell
        if (cell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("WeiboCell", owner: self, options: nil) as NSArray
            cell = nib.objectAtIndex(0) as? MyCell
        //移除旧cell的微博文字子视图，因为setCell方法回重新创建新的weiboTextLable
        } else {
            cell?.weiboTextLable.removeFromSuperview()
        }
        cell?.setCell(weibo.headImageUrl, user_name: weibo.useName, weibo_text: weibo.weiboText)
        return cell!
    }
    

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let weibo = allItems[indexPath.row]
        var hang = weibo.weiboText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)/45 + 1
        return CGFloat(CELL_TOP_MARGIN + hang * 25)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
