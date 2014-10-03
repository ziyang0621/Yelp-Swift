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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("test") as UITableViewCell
        return cell
    }
}
