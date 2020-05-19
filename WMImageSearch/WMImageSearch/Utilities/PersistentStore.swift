//
//  PersistentStore.swift
//  WMImageSearch
//
//  Created by Sanjay Mohnani on 18/05/20.
//  Copyright © 2020 Sanjay Mohnani. All rights reserved.
//

import UIKit

class PersistentStore {
    class func savaSearchedText(_ text:String){
        let defaults = UserDefaults.standard
        if var array = getRecentSearchedText(){
            if array.contains(text), let indexOfText = array.firstIndex(of:text){
                array.remove(at: indexOfText)
                array.insert(text, at: 0)
            }else{
                array.insert(text, at: 0)
                if array.count > 10{
                    array.removeLast()
                }
            }
            defaults.setValue(array, forKey: UserDefaultKeys.kSavedListKey)
        }else{
            defaults.setValue([text], forKey: UserDefaultKeys.kSavedListKey)
        }
    }
    class func getRecentSearchedText() -> [String]?{
        let defaults = UserDefaults.standard
        return defaults.value(forKey: UserDefaultKeys.kSavedListKey) as? [String]
    }
}
