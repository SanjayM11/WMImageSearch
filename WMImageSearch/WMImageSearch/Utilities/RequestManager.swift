//
//  RequestManager.swift
//  WMImageSearch
//
//  Created by Sanjay Mohnani on 19/05/20.
//  Copyright © 2020 Sanjay Mohnani. All rights reserved.
//

import Foundation

class RequestManager {
    class func executeRequestWithSearchedText(_ text:String, pageNumber : Int, completion:@escaping (_ errorMessage:ErrorMessage?, _ data:ImageList?) -> ()){
        let url : String = "\(Constants.kBaseURL)\(Constants.kKey)=\(Constants.kAPIKey)&\(Constants.kSearchString)=\(text)&image_type=photo&page=\(pageNumber)"
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = Constants.kHTTPMethodGET
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                //onFailure(error!)
                let error = ErrorMessage.init(title: MessageStrings.kErrorString, message: MessageStrings.kMessageString, buttonTitle: MessageStrings.kOK)
                completion(error, nil)
            } else if let data = data{
                let decoder = JSONDecoder()
                do {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print(jsonString)
                    }
                    let listData = try decoder.decode(ImageList.self, from: data)
                    completion(nil, listData)
                } catch {
                    let error = ErrorMessage.init(title: MessageStrings.kErrorString, message: MessageStrings.kMessageString, buttonTitle: MessageStrings.kOK)
                    completion(error, nil)
                }
            }
        })
        task.resume()
    }
}
