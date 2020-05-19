//
//  Constants.swift
//  WMImageSearch
//
//  Created by Sanjay Mohnani on 19/05/20.
//  Copyright © 2020 Sanjay Mohnani. All rights reserved.
//

import Foundation

struct Constants{
    static let kBaseURL = "https://pixabay.com/api/?"
    static let kAPIKey = "16563135-6a0a672cfe9b82bc726f30bc8"
    static let kKey = "key"
    static let kSearchString = "q"
    static let kHTTPMethodGET = "GET"
    static let kMainStoryboardName = "Main"
    static let kBaseWidth = 320.0
}

struct UserDefaultKeys {
    static let kSavedListKey = "savedListKey"
}

struct MessageStrings{
    static let kErrorString = "Error"
    static let kMessageString = "Error occured while loading images! Please Retry!"
    static let kOK = "Ok"
    static let kNoInputString = "No Input"
    static let kNoInputMessage = "Please enter some text to search!"
    static let kSorryString = "Sorry"
    static let kNoRecordsMessage = "No records found with the searched text"
    
}

struct CellReuseIdentifier {
    static let kIVCReuseIdentifier = "CollectionViewCell"
    static let kIVCTableCellReuseIdentifier = "TableViewCell"
    static let kDIVCCollectionCellReuseId = "DetailImageCollectionViewCell"
}

struct ViewControllerIdentifier{
    static let kDetailViewControllerId = "DetailImageViewController"
}
