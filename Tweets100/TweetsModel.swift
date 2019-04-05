//
//  TweetsModel.swift
//  Tweets100
//
//  Created by Viktoriia LIKHOTKINA on 1/17/19.
//  Copyright © 2019 Viktoriia LIKHOTKINA. All rights reserved.
//

struct Tweet {
    let name : String
    let text : String
    let date : String
}

extension Tweet : CustomStringConvertible {
    var description: String {
        return "\(name), \(text), \(date)"
    }
}
