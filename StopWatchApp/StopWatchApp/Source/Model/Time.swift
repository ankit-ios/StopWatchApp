//
//  StopWatch.swift
//  StopWatchApp
//
//  Created by Ankit Sharma on 21/11/16.
//  Copyright © 2016 Robosoft Technology. All rights reserved.
//

import Foundation

struct Time {
    
    private static var startTime: NSDate?
    static var pauseTime = 0.0
    
    var elapsedTime: NSTimeInterval {
        if let startTime = Time.startTime {
            return -startTime.timeIntervalSinceNow + Time.pauseTime
        } else {
            return 0
        }
    }
    
    var elapsedTimeAsString: String {
        return String(format: "%02d:%02d.%d", Int(elapsedTime / 60), Int(elapsedTime % 60), Int(elapsedTime * 10 % 10))
    }
    
    var isRunning: Bool {
        return Time.startTime != nil
    }
    
    static func start() {
        startTime = NSDate()
    }
    
    static func stop() {
        startTime = nil
    }
    
}