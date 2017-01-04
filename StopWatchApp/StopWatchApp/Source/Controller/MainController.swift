//
//  File.swift
//  StopWatchApp
//
//  Created by Ankit Sharma on 18/11/16.
//  Copyright © 2016 Robosoft Technology. All rights reserved.
//

import Foundation
import UIKit

class MainController: UIViewController {
    
    enum States {
        case initial
        case running
        case pause
    }
    
    //Outelets
    @IBOutlet weak var timeLabelOutlet: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var lapHistoryTableView: UITableView!
    
    @IBOutlet weak var startButtonOutlet: UIButton!
    @IBOutlet weak var lapButtonOutlet: UIButton!
    
    //Properties
    
    private var lappedHistory = [String]()
    var stopWatch = StopWatch()
    
    var state: States = .initial {
        
        didSet {
            updateUI(state)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - ViewController Life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    
    // MARK: -IBOutlet methods
    @IBAction func startButtonAction(sender: AnyObject) {
        
        switch state {
        case .initial:
            state = .running
            stopWatch.start()
            
        case .running:
            state = .pause
            stopWatch.pause()
            
        case .pause:
            state = .running
            stopWatch.start()
        }
    }
    
    @IBAction func lapButtonAction(sender: AnyObject) {
        
        switch state {
        case .initial:
            return
            
        case .running:
            let lapTime = stopWatch.lap()
            print(lapTime)
            lappedHistory.insert(lapTime, atIndex: 0)
            lapHistoryTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Middle)

        case .pause:
            state = .initial
            resetStopWatch()
        }
    }
}

// MARK: - Helper Methods
extension MainController {
    
    func initialSetup() {
        navigationBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(20)]
        view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        stopWatch.delegate = self
        state = .initial
    }
    
    func resetStopWatch() {
        stopWatch.reset()
        timeLabelOutlet.text = "00:00.0"
        lappedHistory.removeAll(keepCapacity: true)
        lapHistoryTableView.reloadData()
    }
    
    func updateUI(state: States) {
        switch state {
        case .initial:
            startButtonOutlet.setTitle("Start", forState: .Normal)
            lapButtonOutlet.setTitle("Reset", forState: .Normal)
            
        case .running:
            startButtonOutlet.setTitle("Pause", forState: .Normal)
            lapButtonOutlet.setTitle("Lap", forState: .Normal)
            
        case .pause:
            startButtonOutlet.setTitle("Restart", forState: .Normal)
            lapButtonOutlet.setTitle("Reset", forState: .Normal)
        }
    }
}

// MARK: -UITableView Datasource methods
extension MainController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lappedHistory.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = lappedHistory[indexPath.row] ?? ""
        cell.textLabel?.textAlignment = .Center
        cell.textLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        
        return cell ?? UITableViewCell()
    }
}

//Stopwatch Delegate confirm
extension MainController: StopWatchDelegate {
    
    func updateElapsedTime(updatedTime: String) {
        if stopWatch.time.isRunning {
            timeLabelOutlet.text = updatedTime
        } else {
            stopWatch.reset()
        }
    }
}













