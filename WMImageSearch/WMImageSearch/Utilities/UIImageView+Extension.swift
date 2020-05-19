//
//  UIImageView+Extension.swift
//  WMImageSearch
//
//  Created by Sanjay Mohnani on 19/05/20.
//  Copyright © 2020 Sanjay Mohnani. All rights reserved.
//

import UIKit

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        self.image = nil
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
    }).resume()
}}
