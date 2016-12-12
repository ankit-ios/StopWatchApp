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
            if state == .initial {
                startButtonOutlet.setTitle("Start", forState: .Normal)
                lapButtonOutlet.setTitle("Reset", forState: .Normal)
                
            } else if state == .running {
                startButtonOutlet.setTitle("Pause", forState: .Normal)
                lapButtonOutlet.setTitle("Lap", forState: .Normal)
                
            } else {
                startButtonOutlet.setTitle("Restart", forState: .Normal)
                lapButtonOutlet.setTitle("Reset", forState: .Normal)
                
            }
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
        
        if state == .initial {
            state = .running
            stopWatch.start()
            
        } else if state == .running {
            state = .pause
            stopWatch.pause()
            
        } else {
            state = .running
            stopWatch.start()
        }
    }
    
    @IBAction func lapButtonAction(sender: AnyObject) {
        
        if state == .running {
            let lapTime = stopWatch.lap()
            print(lapTime)
            lappedHistory.insert(lapTime, atIndex: 0)
            lapHistoryTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Middle)
            
        } else if state == .pause {
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


extension MainController: StopWatchDelegate {
    
    func updateElapsedTime(updatedTime: String) {
        if stopWatch.time.isRunning {
            timeLabelOutlet.text = updatedTime
        } else {
            stopWatch.reset()
        }
    }
}













