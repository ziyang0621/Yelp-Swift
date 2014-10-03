//
//  FilterViewController.swift
//  Yelp
//
//  Created by Ziyang Tan on 10/2/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var naviBar: UINavigationBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var isExpended: [Int:Bool]! = [Int:Bool]()
    
    var selectedDistance = 0
    
    var selectedSort = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var filterBtn = UIButton()
        filterBtn.bounds = CGRectMake(0, 0, 60, 20)
        filterBtn.setTitle("Cancel", forState: UIControlState.Normal)
        filterBtn.addTarget(self, action: "cancelFilter", forControlEvents: UIControlEvents.TouchUpInside)
        var leftBarItem = UIBarButtonItem(customView: filterBtn)
        
        var naviItem = UINavigationItem()
        naviItem.title = "Filters"
        naviItem.leftBarButtonItem = leftBarItem
        naviBar.items = [naviItem]

        naviBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: "PopularCell", bundle: nil), forCellReuseIdentifier: "popularCell")
        tableView.registerNib(UINib(nibName: "DistanceCell", bundle: nil), forCellReuseIdentifier: "distanceCell")
        tableView.registerNib(UINib(nibName: "SortedCell", bundle: nil), forCellReuseIdentifier: "sortedCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelFilter() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UIView(frame: CGRectMake(0, 0, 320, 40))
        var headerLabel = UILabel(frame: CGRectMake(10, 10, 320, 40))
        headerLabel.textColor = UIColor.grayColor()
        if section == 0 {
            headerLabel.text = "Most Popular"
        }
        else if section == 1 {
            headerLabel.text = "Distance"
        }
        else if section == 2 {
            headerLabel.text = "Sort by"
        }
        else {
            headerLabel.text = "General Features"
        }
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 || section == 2{
            if let expanded = isExpended[section] {
                return expanded ? 3 : 1
            } else {
                return 1
            }
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("popularCell") as PopularCell
            return cell
        }
        else if indexPath.section == 1 {
            var cell = tableView.dequeueReusableCellWithIdentifier("distanceCell") as DistanceCell

            var rowIndex = 0
            
            if tableView.numberOfRowsInSection(indexPath.section) == 1 {
                rowIndex = selectedDistance
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            else {
                rowIndex = indexPath.row
                if (indexPath.row == selectedDistance) {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
                else {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            }

            if rowIndex == 0 {
                cell.distanceLabel.text = "Auto"
            }
            else if rowIndex == 1 {
                cell.distanceLabel.text = "1 mile"
            }
            else {
                cell.distanceLabel.text = "5 miles"
            }
            
            return cell
        }
            
        else if indexPath.section == 2 {
            var cell = tableView.dequeueReusableCellWithIdentifier("sortedCell") as SortedCell
            
            var rowIndex = 0
            
            if tableView.numberOfRowsInSection(indexPath.section) == 1 {
                rowIndex = selectedSort
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            else {
                rowIndex = indexPath.row
                if (indexPath.row == selectedSort) {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
                else {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            }
            
            if rowIndex == 0 {
                cell.sortedLabel.text = "Best Matched"
            }
            else if rowIndex == 1 {
                cell.sortedLabel.text = "Distance"
            }
            else {
                cell.sortedLabel.text = "Highest Rated"
            }
            
            return cell
        }
        else {
            var cell = tableView.dequeueReusableCellWithIdentifier("distanceCell") as DistanceCell
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 || indexPath.section == 2 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)

            if let expanded = isExpended[indexPath.section] {
                isExpended[indexPath.section] = !expanded
                if (isExpended[indexPath.section] == false) {
                    if (indexPath.section == 1) {
                        selectedDistance = indexPath.row
                    }
                    else if (indexPath.section == 2) {
                        selectedSort = indexPath.row
                    }
                }
            } else {
                isExpended[indexPath.section] = true
            }
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
        }
        
    }
}
