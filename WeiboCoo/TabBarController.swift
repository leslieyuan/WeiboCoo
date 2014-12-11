//
//  TabViewController.swift
//  WeiboCoo
//
//  Created by Leslie Yuan on 14/11/13.
//  Copyright (c) 2014年 Yuan's. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        
        
//        var wbTVC = WeiboTableViewController()
//        var otTVC = OtherTableViewController()
//        wbTVC.title = "首页"
//        otTVC.title = "热门"
//        
//        self.viewControllers = [UINavigationController(rootViewController: wbTVC), UINavigationController(rootViewController: otTVC)]
        self.selectedIndex = 0
        
        
    }
   
}
