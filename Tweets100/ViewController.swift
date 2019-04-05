//
//  ViewController.swift
//  Tweets100
//
//  Created by Viktoriia LIKHOTKINA on 1/17/19.
//  Copyright © 2019 Viktoriia LIKHOTKINA. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, APITwitterDelegate {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchField: UITextField!

    var search : String = "school 42"

    var tweets = [Tweet]()
    let customerKey = ""
    let customerSecret = ""
    var api : APIController?
    var token : String?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as! TableViewCell
        cell.nameLabel.text = self.tweets[indexPath.row].name
        cell.tweetLabel.text = self.tweets[indexPath.row].text
        cell.dateLabel.text = self.tweets[indexPath.row].date
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchField.text = "school 42"
        searchField.delegate = self
        searchField.returnKeyType = .done
        makeRequest()
    }

    func makeRequest() {
        let bearer = ((customerKey + ":" + customerSecret).data(using: String.Encoding.utf8))!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue : 0))
        let url = URL(string : "https://api.twitter.com/oauth2/token")
        var request = URLRequest(url : url!)
        request.httpMethod = "POST"
        request.setValue("Basic " + bearer, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if data != nil {
                do {
                    if let dict : NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print(dict)
                        self.token = (dict["access_token"] as? String)!
                        self.api = APIController(delegate: self, token: self.token!)
                        self.api?.twitter(searchPhrase: self.search)
                    }
                }
                catch (let err) {
                    print(err)
                }
            }
        }
        task.resume()
    }

    func processingTweets(tweets: [Tweet]) {

        self.tweets = tweets
        for t in tweets {
            print(t)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func ifError(error: NSError) {
        print("Error: \(error)")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        searchField.text = textField.text
        search = (searchField?.text)!
    }

    @IBAction func try2(_ sender: UITextField) {
        let newApi = APIController(delegate: self, token: self.token!)
        newApi.twitter(searchPhrase: self.search)
    }
}
