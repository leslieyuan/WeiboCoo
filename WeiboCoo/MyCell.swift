//
//  MyCell.swift
//  WeiboCoo
//
//  Created by Leslie Yuan on 14/11/16.
//  Copyright (c) 2014年 Yuan's. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {
    
    @IBOutlet weak var weiboImageView: UIImageView!
    @IBOutlet weak var weiboUserNameLable: UILabel!
    
    //@IBOutlet weak var weiboUserTextLable: UILabel!
    var weiboTextLable: UILabel!
    var weiboImageUrl: String = "default"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    override init() {
//        super.init()
//        self.weiboTextLable = UILabel()
//    }
//
//    convenience required init(coder aDecoder: NSCoder) {
//        self.init()
//        //fatalError("init(coder:) has not been implemented")
//    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(image_url: String, user_name: String, weibo_text: String) {
        //Caculate fram of Text Lable
        var hang = weibo_text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)/45 + 1
        //println("Hang is \(hang) all is \(weibo_text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))")
        println(hang)
        self.weiboTextLable = UILabel(frame: CGRectMake(8, 70, 304, CGFloat(hang * 25)))
        self.addSubview(self.weiboTextLable)
        self.weiboTextLable.numberOfLines = hang
        self.weiboTextLable.highlightedTextColor = UIColor.brownColor()
        //self.weiboTextLable.preferredMaxLayoutWidth = 304

        //Set content
        self.weiboImageUrl = image_url
        self.weiboUserNameLable.text = user_name
        self.weiboTextLable.text = weibo_text
        self.weiboImageView.image = UIImage(named: "Head.png")
        //Set frame
        //self.weiboImageView.frame = CGRectMake(0, 0, 66, 66)
        
        //self.weiboTextLable.frame = CGRectMake(8, 70, 304, CGFloat(hang*20))
        
        //self.weiboUserTextLable.preferredMaxLayoutWidth = 304
        
        //let width =  self.weiboUserTextLable.text?.(UIFont(name: "ChaparralPro_Bold", size: 40)).width //[UIFont fontWithName:@"ChaparralPro-Bold" size:40 ]].width;
        //let width: CGFloat =
        //let height: CGFloat = user_name.sizeWithFont(UIFont.systemFontOfSize(40)).height
        //self.weiboUserTextLable.frame.width = 300
    }
}
