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
    //记录微博文字数目的view
    var characterCount: UILabel!
    let toolBarHeight: CGFloat = 20.0
    
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "sendWeibo")
        self.weiboTextView.delegate = self
        self.weiboTextView.resignFirstResponder()
        self.navigationController?.toolbarHidden = false
        setCustomToolBarItems()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.toolbarHidden = true
    }
    
    // Set toolbar items
    func setCustomToolBarItems() {
        let photoIMG: UIImage! = UIImage(named: "photo25.png", inBundle: NSBundle.mainBundle(), compatibleWithTraitCollection: nil)
        let photoBarItem = UIBarButtonItem(image: photoIMG, style: UIBarButtonItemStyle.Bordered, target: self, action: nil)    //Todo:Set a action
        let screenWidth = self.view.frame.size.width
        characterCount = UILabel(frame: CGRectMake(5, 5, screenWidth/5, toolBarHeight))
        characterCount.text = "140"
        characterCount.textAlignment = NSTextAlignment.Right
        //ToolBar上可放置任意uiview类型，但是要用到下面的函数
        let characterCountBarButtonItem = UIBarButtonItem(customView: characterCount)
        //可变的填充item，用来让toolbar上的按钮分布更好
        let itemFlexbaleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        self.setToolbarItems([photoBarItem, itemFlexbaleSpace,characterCountBarButtonItem], animated: false)
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
        println("Start edit weibo")
        self.weiboTextView.becomeFirstResponder()
        //Todo：self.toolBar.setFrame(CGFrameMake()) 移动toolbar到键盘顶端
    }
    
    //统计剩余可输入字符数并显示在lable上
    func textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
        characterCount.text = 140 - countElements(self.weiboTextView.text)
    }
}