//
//  WriteWeiboViewController.swift
//  WeiboCoo
//
//  Created by Leslie Yuan on 14/12/6.
//  Copyright (c) 2014年 Yuan's. All rights reserved.
//

import Foundation
import UIKit

class WriteWeiboViewController: UIViewController, UITextViewDelegate{
    
    
    @IBOutlet weak var weiboTextView: UITextView!
    
    let access_token = "https://api.weibo.com/2/statuses/update.json"
    
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "sendWeibo")
        self.weiboTextView.delegate = self
        self.weiboTextView.resignFirstResponder()
    }
    
    //微博文字URLencode
    func urlEncode(originalString : String) -> String {
        var customAllowedSet =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|}").invertedSet
        var escapedString = originalString.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        return escapedString
    }
    
    //Send weibo function
    func sendWeibo() {
        var weiboUrlEncodeString = urlEncode(self.weiboTextView.text)
        var urlstring = "https://api.weibo.com/2/statuses/update.json?access_token=\(WeiboTableViewController.ACCESS_TOKEN)"
        var url = NSURL(string: urlstring)
        var request = NSMutableURLRequest(URL: url!)
        
        var bodyString = "status=\(weiboUrlEncodeString)" as NSString
        var httpBody = NSData(bytes: bodyString.UTF8String, length: bodyString.length)
        request.HTTPBody = httpBody
        request.HTTPMethod = "POST"
        //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        if let received = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil) {
            var error: NSError?
            let jsonData = NSJSONSerialization.JSONObjectWithData(received, options: NSJSONReadingOptions(), error: &error) as NSDictionary
            //发送是否成功...
            if let error = jsonData["error_code"] as? Int {
                println("Send faild,error code is:\(error)")
            }else {
                println("Send success!")
                self.weiboTextView.resignFirstResponder()
                
                self.navigationController?.popToRootViewControllerAnimated(true)
                
            }
        }
        
        
    }
    
    //响应键盘
    func textViewDidBeginEditing(textView: UITextView) {
        println("tap on textView")
        self.weiboTextView.becomeFirstResponder()
    }
    
}