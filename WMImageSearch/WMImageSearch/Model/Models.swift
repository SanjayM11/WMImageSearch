//
//  Models.swift
//  WMImageSearch
//
//  Created by Sanjay Mohnani on 19/05/20.
//  Copyright © 2020 Sanjay Mohnani. All rights reserved.
//

import UIKit

struct ImageModel:Codable {
    var comments:Int
    var downloads:Int
    var favorites:Int
    var id:Int
    var imageHeight:Int
    var imageSize:Int
    var imageWidth:Int
    var largeImageURL:String
    var likes:Int
    var pageURL:String
    var previewHeight:Int
    var previewURL:String
    var previewWidth:Int
    var tags:String
    var type:String
    var user:String
    var userImageURL:String
    var user_id:Int
    var views:Int
    var webformatHeight:Int
    var webformatURL:String
    var webformatWidth:Int
}

struct ImageList:Codable {
    var total:Int
    var totalHits:Int
    var hits:[ImageModel]
}

struct ErrorMessage{
    var title:String
    var message:String
    var buttonTitle:String
}
