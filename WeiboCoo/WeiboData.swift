//
//  WeiboData.swift
//  WeiboCoo
//
//  Created by Leslie Yuan on 14/11/14.
//  Copyright (c) 2014年 Yuan's. All rights reserved.
//

import Foundation

class WeiboData {
    
    var useName: String
    var weiboText: String
    var headImageUrl: String
    var createAt: String
    
    init(useName: String, andCreateAt: String, andText: String, andHeadImageUrl: String) {
        self.useName = useName
        self.createAt = andCreateAt
        self.weiboText = andText
        self.headImageUrl = andHeadImageUrl
    }
    
}
