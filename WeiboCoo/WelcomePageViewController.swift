//
//  ViewController.swift
//  WeiboCoo
//
//  Created by Leslie Yuan on 14/10/30.
//  Copyright (c) 2014年 Yuan's. All rights reserved.
//

import UIKit
import Foundation


class WelcomePageViewController: UIViewController {
    
//    //AutherPageViewController的实例
//    var autherViewController: AutherPageViewController {
//        return self.storyboard?	.instantiateViewControllerWithIdentifier("autherStoryboard") as AutherPageViewController
//    }
//    //TabBarController的实例
//    var mainViewController: TabBarController {
//        return self.storyboard?.instantiateViewControllerWithIdentifier("mainStoryboard") as TabBarController
//    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        //打开plist，查找token
        if let token = WelcomePageViewController.getToken() {
            println("Old token in plist is:\(token).")
            if tokenIsWork(token) {
                println("The token works!")
                startStoryboard("main")
            }else {
                println("Need new token.")
                startStoryboard("auth")
            }
        //第一次用，token为空
        }else {
            println("First use,token is blank!")
            //去授权界面获取token
            startStoryboard("auth")
        }
    }
    
    //Class func --- 在plist中查找token
    class func getToken()->String? {
        if let path = NSBundle.mainBundle().pathForResource("Token", ofType: "plist") {
            if let dic = NSDictionary(contentsOfFile: path) {
                if let token = dic.valueForKey("token") as? String {
                    if token == "" {
                        return nil
                    }
                    return token
                }
                return nil
            }
            return nil
        }
        return nil
    }
    
    //跳转到授权页面，或首页
    func startStoryboard(pageName: String) {
        switch pageName {
        case "auth" :
            //self.presentViewController(autherViewController, animated: true, completion: nil)
            self.performSegueWithIdentifier("autherSegue", sender: nil)
        case "main" :
            //self.presentViewController(mainViewController, animated: true, completion: nil)
            self.performSegueWithIdentifier("mainSegue", sender: nil)
        default :
            println("Wrong ID for storyboard to init")
        }
    }
    
    //Segue trans information
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    
    //测试token是否还有效
    func tokenIsWork(token: String)-> Bool {
        // if can use , https://api.weibo.com/2/statuses/public_timeline.json?access_token=2.00NpDNMCKLP6gDa3ab3200470_BVy3
        let urlstring = "https://api.weibo.com/2/statuses/public_timeline.json?access_token=\(token)"
        let url = NSURL(string: urlstring)
        let request = NSURLRequest(URL: url!)
        //获取所有微博，失败的话就去验证页面
        if let received = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil) {
            return true
        }
        return false
    }
}

