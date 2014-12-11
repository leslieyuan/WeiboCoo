//
//  AutherPageViewController.swift
//  WeiboCoo
//
//  Created by Leslie Yuan on 14/11/7.
//  Copyright (c) 2014年 Yuan's. All rights reserved.
//

import UIKit
import Foundation

class AutherPageViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var authWebView: UIWebView!
    let clientID = "3375021160"
    let redirectURL = "http://img3.douban.com/view/photo/photo/public/p1548626671.jpg"
    let clientSecret = "fb2a85e418a4a2980cbb3347ffca2149"
    var TOKEN: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlstring = "https://api.weibo.com/oauth2/authorize?client_id=\(clientID)&redirect_uri=\(redirectURL)&response_type=code"
        let url = NSURL(string: urlstring)
        let request = NSURLRequest(URL: url!)
        authWebView.loadRequest(request)
        authWebView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(animated: Bool) {
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        var urlString = webView.request?.URL.absoluteString
        println(urlString)
        if urlString!.hasPrefix("\(redirectURL)") {
            let urlStringArr = urlString?.componentsSeparatedByString("code=")
            var urlCode = urlStringArr![1]  //获取code
            println(urlCode)
            let requestURL = NSURL(string:
                NSString(string: "https://api.weibo.com/oauth2/access_token?client_id=\(clientID)&client_secret=\(clientSecret)&grant_type=authorization_code&redirect_uri=\(redirectURL)&code=\(urlCode)"))
            let request: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL!)
            //设置请求方式
            request.HTTPMethod = "POST"
            let str = "type=focus-c"
            let data = NSData(data: str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            //设置编码方式
            request.HTTPBody = data
            //POST并且得到返回的NSData
            let received = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
            //解析NSData为Dictionary
            var error: NSError?
            let tokenDic: NSDictionary = NSJSONSerialization.JSONObjectWithData(received!, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
            //得到token
            TOKEN = tokenDic.objectForKey("access_token") as? String
            println(TOKEN)
            //把token存到属性列表中
            if let path = NSBundle.mainBundle().pathForResource("Token", ofType: "plist") {
                var dic = NSDictionary(contentsOfFile: path)?.mutableCopy() as? NSDictionary
                dic?.setValue(TOKEN, forKey: "token")
                dic?.writeToFile(path, atomically: false)
                
            }
            ///跳转到主界面
            //let welVC = WelcomePageViewController()
           // welVC.startStoryboard("main")
            self.performSegueWithIdentifier("mainSegue", sender: nil)
        }
    }
    
    //读出手机模拟器的plist上的token值
    func readPlist() -> String {
        if let path = NSBundle.mainBundle().pathForResource("Token", ofType: "plist") {
            var dic = NSDictionary(contentsOfFile: path)
            return dic?.valueForKey("token") as String
        }
        return "No things"
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
