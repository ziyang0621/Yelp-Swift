//
//  FilterViewController.swift
//  Yelp
//
//  Created by Ziyang Tan on 10/2/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate {
    func applyFilterSearch(controller:FilterViewController,deal:Bool, radius:Int, sort:Int, category:String)
}

class FilterViewController: UIViewController, UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var naviBar: UINavigationBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate:FilterViewControllerDelegate!
    
    var isExpended: [Int:Bool]! = [Int:Bool]()
    
    var selectedDistance = 0
    
    var selectedSort = 0
    
    var categoryMap :[String:String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cancelBtn = UIButton()
        cancelBtn.bounds = CGRectMake(0, 0, 60, 20)
        cancelBtn.setTitle("Cancel", forState: UIControlState.Normal)
        cancelBtn.addTarget(self, action: "cancelFilter", forControlEvents: UIControlEvents.TouchUpInside)
        var leftBarItem = UIBarButtonItem(customView: cancelBtn)
        
        var filterBtn = UIButton()
        filterBtn.bounds = CGRectMake(0, 0, 60, 20)
        filterBtn.setTitle("Filter", forState: UIControlState.Normal)
        filterBtn.addTarget(self, action: "applyFilter", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarItem = UIBarButtonItem(customView: filterBtn)

        var naviItem = UINavigationItem()
        naviItem.title = "Filters"
        naviItem.leftBarButtonItem = leftBarItem
        naviItem.rightBarButtonItem = rightBarItem
        naviBar.items = [naviItem]
        
        categoryMap = ["Amusement Parks" : "amusementparks", "Badminton" : "badminton", "Climbing" : "climbing", "Day Camps" : "daycamps", "Fencing Clubs" : "fencing"]

        naviBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: "PopularCell", bundle: nil), forCellReuseIdentifier: "popularCell")
        tableView.registerNib(UINib(nibName: "DistanceCell", bundle: nil), forCellReuseIdentifier: "distanceCell")
        tableView.registerNib(UINib(nibName: "SortedCell", bundle: nil), forCellReuseIdentifier: "sortedCell")
        tableView.registerNib(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        tableView.registerNib(UINib(nibName: "SeeAllCell", bundle: nil), forCellReuseIdentifier: "seeAllCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelFilter() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func applyFilter() {
        var deal = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as PopularCell
        
        var radius = -1
        if selectedDistance == 0 {
            radius = -1
        } else if selectedDistance == 1 {
            radius = 1
        } else {
            radius = 5
        }
        
        var categories = ""
        var addedCategory = 0
        var numOfRow = ((tableView.numberOfRowsInSection(3) == 5) ? 5 : 3)
        for index in 0...(numOfRow-1)  {
            var categoryCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 3)) as CategoryCell
            if categoryCell.categorySwitch.on {
                var text = categoryCell.categoryLabel.text
                var key = categoryMap[text!]
                if (addedCategory == 0) {
                    categories += key!
                }
                else {
                    categories += "," + key!
                }
                addedCategory++
            }
        }
        
        delegate.applyFilterSearch(self, deal: deal.dealSwitch.on, radius: radius, sort: selectedSort, category: categories)
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
        if section == 1 || section == 2 {
            if let expanded = isExpended[section] {
                return expanded ? 3 : 1
            } else {
                return 1
            }
        }
        else if section == 3 {
            if let expended = isExpended[section] {
                return expended ? 5 : 4
            } else {
                return 4
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
            
        else  {
            var cell = tableView.dequeueReusableCellWithIdentifier("categoryCell") as CategoryCell
            
            if indexPath.row == 0 {
                cell.categoryLabel.text = "Amusement Parks"
            }
            else if indexPath.row == 1 {
                cell.categoryLabel.text = "Badminton"
            }
            else if indexPath.row == 2 {
                cell.categoryLabel.text = "Climbing"
            }
            else if indexPath.row == 3 {
                if tableView.numberOfRowsInSection(indexPath.section) == 5 {
                    cell.categoryLabel.text = "Day Camps"
                }
                else {
                    var seeAllCell = tableView.dequeueReusableCellWithIdentifier("seeAllCell") as SeeAllCell
                    return seeAllCell
                }
            }
            else {
                cell.categoryLabel.text = "Fencing Clubs"
            }
            
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
        else if indexPath.section == 3  {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            if indexPath.row == 3 && tableView.numberOfRowsInSection(indexPath.section) == 4 {
                if let expanded = isExpended[indexPath.section] {
                    isExpended[indexPath.section] = !expanded
                } else {
                    isExpended[indexPath.section] = true
                }
                tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)

            }
        }
        
    }
}
