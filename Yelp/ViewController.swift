//
//  ViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FilterViewControllerDelegate{
    var client: YelpClient!
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
    let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
    let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
    let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchBar = UISearchBar()
    
    var businesses:[NSDictionary]=[]
    
    var searchText = ""
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 125.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        
        for subView in searchBar.subviews {
            if(subView.conformsToProtocol(NSProtocolFromString("UITextInputTraits"))) {
                var sv = subView as UITextField
                sv.returnKeyType = UIReturnKeyType.Search
            }
        }
        
        var filterBtn = UIButton()
        filterBtn.bounds = CGRectMake(0, 0, 40, 20)
        filterBtn.setTitle("Filter", forState: UIControlState.Normal)
        filterBtn.addTarget(self, action: "presentFilter", forControlEvents: UIControlEvents.TouchUpInside)
        var leftBarItem = UIBarButtonItem(customView: filterBtn)
        navigationItem.leftBarButtonItem = leftBarItem
        
        var spaceBtn = UIButton()
        spaceBtn.bounds = CGRectMake(0, 0, 40, 20)
        spaceBtn.alpha = 0
        var rightBarItem = UIBarButtonItem(customView: spaceBtn)
        navigationItem.rightBarButtonItem = rightBarItem
        
        searchWithTerm("")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentFilter() {
        performSegueWithIdentifier("toFilter", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toFilter") {
            let detailVC = segue.destinationViewController as FilterViewController
            detailVC.delegate = self
        }
    }

    func applyFilterSearch(controller: FilterViewController, deal: Bool, radius: Int, sort: Int, category: String) {
        client.searchWithTerm(searchBar.text, deal: deal, radius :radius, sort: sort, categories: category, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println(response)
            var total = response["total"] as Int
            if total != 0 {
                self.businesses = response["businesses"] as [NSDictionary]
                var business :NSDictionary = NSDictionary()
                business = self.businesses[0]
            } else {
                self.businesses.removeAll(keepCapacity: false)
            }
            self.tableView.reloadData()
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }    }

    
    func searchWithTerm(term :String) {
        client.searchWithTerm(term, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println(response)
            var total = response["total"] as Int
            if total != 0 {
                self.businesses = response["businesses"] as [NSDictionary]
                var business :NSDictionary = NSDictionary()
                business = self.businesses[0]
            } else {
                self.businesses.removeAll(keepCapacity: false)
            }
            self.tableView.reloadData()
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchWithTerm(searchText)
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell") as BusinessCell
        
        var business: NSDictionary = NSDictionary()
        business = self.businesses[indexPath.row]
        
        cell.nameLabel.text = business["name"] as? String
        
        var review = business["review_count"] as Int
        cell.reviewLabel.text = String(review) + " Reviews"
        
        var location = business["location"] as NSDictionary
        var address = location["address"] as NSArray
        cell.locationLabel.text = address.firstObject as? String
        cell.locationLabel.text? += " ,"
        var city = location["city"] as? String
        cell.locationLabel.text? += city!
        
        var distance = business["distance"] as? Float
        distance = distance! * 0.000621371
        cell.distanceLabel.text = String(format: "%.02f", distance!) + " mi"
        
        var categ = business["categories"] as? NSArray
        if let categories = categ {
            for index in 0...(categories.count - 1) {
                var category = categories[index] as NSArray
                if (index == 0) {
                    cell.categoryLabel.text = category[0] as? String
                }
                else {
                    var cate = category[0] as? String
                    cell.categoryLabel.text = cell.categoryLabel.text! + ", " + cate!
                }
            }
        }
        
        var imageURL = business["image_url"] as? String
        if let imURL = imageURL {
            cell.businessImageView.setImageWithURL(NSURL(string: imURL))
        }
        
        var ratingURL = business["rating_img_url_large"] as? String
        if let rURL = ratingURL {
            cell.ratingImageView.setImageWithURL(NSURL(string: rURL))
        }
        
        return cell
    }
}

