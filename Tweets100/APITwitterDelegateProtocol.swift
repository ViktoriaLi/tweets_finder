//
//  APITwitterDelegateProtocol.swift
//  Tweets100
//
//  Created by Viktoriia LIKHOTKINA on 1/17/19.
//  Copyright © 2019 Viktoriia LIKHOTKINA. All rights reserved.
//

import UIKit
import Foundation

protocol APITwitterDelegate: NSObjectProtocol {
    func processingTweets (tweets : [Tweet])
    func ifError (error : NSError)
}
