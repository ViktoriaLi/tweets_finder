//
//  ViewController.swift
//  Tweets100
//
//  Created by Viktoriia LIKHOTKINA on 1/17/19.
//  Copyright © 2019 Viktoriia LIKHOTKINA. All rights reserved.
//

import UIKit
import Foundation

class APIController {
    weak var delegate : APITwitterDelegate?
    var token : String
    
    init(delegate: APITwitterDelegate?, token: String) {
        self.delegate = delegate
        self.token = token
    }
    
    var displayTweets = [Tweet]()
    
    func twitter(searchPhrase : String)
    {
        var name : String?
        var date : String?
        var text : String?
        var dateTruncate : DateFormatter?
        var newDate : String?
        
        let q = searchPhrase.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlPath: String = "https://api.twitter.com/1.1/search/tweets.json?q=\(q)&lang=en&count=100&result_type=recent"
        let url: URL = URL(string: urlPath)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " +  self.token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String, Any> {
                    print(jsonResult)
                    let tweetsInfo = jsonResult["statuses"] as? [[String:AnyObject]]
                    for statuses in tweetsInfo!
                    {
                        text = (statuses["text"] as! String)
                        name = statuses["user"]!["name"] as? String
                        date = statuses["created_at"] as? String
                        dateTruncate = DateFormatter()
                        dateTruncate?.dateFormat =  "E MMM dd HH:mm:ss Z yyyy"
                        
                        if let date = dateTruncate?.date(from: date!) {
                            dateTruncate?.dateFormat = "dd/MM/yyyy HH:mm"
                            newDate = dateTruncate?.string(from: date)
                        }
                        self.displayTweets.append(Tweet(name : name!, text : text!, date : newDate!))
                    }
                    if self.delegate != nil  {
                        self.delegate?.processingTweets(tweets: self.displayTweets)
                    }
                }
            } catch let error as NSError {
                if self.delegate != nil {
                    self.delegate?.ifError(error: error)
                    }
                }
            }
            task.resume()
        }
}


