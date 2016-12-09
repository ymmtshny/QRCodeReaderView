//
//  extension+NSObject.swift
//  plantio
//
//  Created by Shinya Yamamoto on 2016/09/26.
//  Copyright © 2016年 vforce. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func singleBtnAlertWithTitle(_ title: String,
                                       message: String,
                                       action: (() -> Void)) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            if let completion = action {
                completion
            }
        }))
        
        return alert
    }
    
    class func doubleBtnAlertWithTitle(_ title: String,
                                       message: String,
                                       option1: String,
                                       action1:@escaping (()-> Void),
                                       option2:String,
                                       action2:@escaping (()->Void)) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: option1, style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            action1()
            
        }))
        
        
        alert.addAction(UIAlertAction(title: option2, style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            action2()
            
        }))
        
        return alert
    }
    
}

