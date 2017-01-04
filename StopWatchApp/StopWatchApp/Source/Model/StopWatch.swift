//
//  StopWatch.swift
//  StopWatchApp
//
//  Created by Ankit Sharma on 30/11/16.
//  Copyright © 2016 Robosoft Technology. All rights reserved.
//

import Foundation
import UIKit

protocol StopWatchDelegate: NSObjectProtocol {
    func updateElapsedTime(updatedTime: String)
}

class StopWatch{
    
    private var nsTimer: NSTimer = NSTimer()
    var time = Time()
    private var oldLapTime: Double = 0.0
    weak var delegate: StopWatchDelegate?
    
    
    func start() {
        if (!nsTimer.valid) {
            self.nsTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(StopWatch.didFireTimer), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(self.nsTimer, forMode: NSRunLoopCommonModes)
            Time.start()
        }
    }
    
    func pause() {
        Time.pauseTime = time.elapsedTime
        nsTimer.invalidate()
    }
    
    func reset() {
        Time.pauseTime = 0.0
        oldLapTime = 0.0
        nsTimer.invalidate()
    }
    
    func lap() -> String {
        let gapTime = time.elapsedTime - oldLapTime
        oldLapTime = time.elapsedTime
        return String(format: "%02d:%02d.%d", UInt(gapTime / 60), UInt(gapTime % 60), UInt(gapTime * 10 % 10)) ?? "00:00:0"
    }
    
    @objc private func didFireTimer()  {
        delegate?.updateElapsedTime(time.elapsedTimeAsString)
    }
}







