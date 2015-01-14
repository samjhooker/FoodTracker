//
//  ViewController.swift
//  FoodTracker
//
//  Created by Samuel Hooker on 12/01/15.
//  Copyright (c) 2015 Jocus Interactive. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let kAppID = "e5940273"
    let kAppKey = "05c892b7bd34a2de757d71cba512d322"
    
    var searchController: UISearchController! //more or less allows us to make a search bar
    
    var suggestedSearchFoods:[String]=[]        // all items
    var filteredSuggestedSearchFoods:[String]=[]// all items after searched
    
    var scopeButtonTitles = ["Recommended", "Search Results", "Saved"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.searchController = UISearchController(searchResultsController: nil) //can choose a seperate tableView controllerif necessary
        
        self.searchController.searchResultsUpdater = self
        
        self.searchController.dimsBackgroundDuringPresentation = false
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        
        
        self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0)
        
        self.tableView.tableHeaderView = self.searchController.searchBar //header is alto created with the table view
        
        
        self.searchController.searchBar.scopeButtonTitles = self.scopeButtonTitles
        
        
        
        self.searchController.searchBar.delegate = self //allows us to access searchbar data
        self.definesPresentationContext = true // makes it display??
        
        
        self.suggestedSearchFoods = ["apple", "bagel", "banana", "beer", "bread", "carrots", "cheddar cheese", "chicen breast", "chili with beans", "chocolate chip cookie", "coffee", "cola", "corn", "egg", "graham cracker", "granola bar", "green beans", "ground beef patty", "hot dog", "ice cream", "jelly doughnut", "ketchup", "milk", "mixed nuts", "mustard", "oatmeal", "orange juice", "peanut butter", "pizza", "pork chop", "potato", "potato chips", "pretzels", "raisins", "ranch salad dressing", "red wine", "rice", "salsa", "shrimp", "spaghetti", "spaghetti sauce", "tuna", "white wine", "yellow cake"]
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell //use defult cell instead of creating a custom class
        var foodName:String
        if self.searchController.active{
            foodName = filteredSuggestedSearchFoods[indexPath.row]
        }else{
            foodName = suggestedSearchFoods[indexPath.row]
        }
        
        cell.textLabel?.text = foodName
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    

    
    }
    
    
    
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if searching and not searching, different number of rows will be reuqired.
        
        if self.searchController.active {
            return self.filteredSuggestedSearchFoods.count
        }
        else{
            return self.suggestedSearchFoods.count
        }
        
        
    }
    
    
    //UISearchBarDelegate
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        makeRequest(searchBar.text)
    }

    
    
    
    
    
    
    
    
    //UISearchResultsUpdatingDelegate
    
    func updateSearchResultsForSearchController(searchController: UISearchController) { //required function; updates everytime an update is made within the search bar
        
        
        let searchString = searchController.searchBar.text
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        self.filterContentForSearch(searchString, scope: selectedScopeButtonIndex)
        
        self.tableView.reloadData()
    }
    
    
    
    
    
    
    func filterContentForSearch(searchText:String, scope:Int){
        
        
        // this uses a filter function to go through each item in the list and see if it meets the search filter, adds it to the filtered list if applicable.
        
        self.filteredSuggestedSearchFoods = self.suggestedSearchFoods.filter({ (food:String) -> Bool in // iterates each element as 'food', return true or false for each
            var foodMatch = food.rangeOfString(searchText)
            return foodMatch != nil
        })
    }
    
    
    func makeRequest(searchString:String){
        
        
        
        ///GET REQUEST
        
//        let url = NSURL(string: "https://api.nutritionix.com/v1_1/search/\(searchString)?results=0%3A20&cal_min=0&cal_max=50000&fields=item_name%2Cbrand_name%2Citem_id%2Cbrand_id&appId=\(kAppID)&appKey=\(kAppKey)")
//        
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, responce, error) -> Void in //access the internet with the a completion handeler
//            
//            //when info comes back, do this...
//            println(data)
//            println(responce)
//        })
//        task.resume() //starts get request
        
        
        /// POST REQUEST
        
        //nsurl mutable request (can easily be changed)
        
        var request = NSMutableURLRequest(URL: NSURL(string: "https://api.nutritionix.com/v1_1/search/")!)
        
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = [
            "appId" : kAppID,
            "appKey" : kAppKey,
            "fields" : ["item_name", "brand_name", "Keywords", "usda_fields"],
            "limit" : "50",
            "query" : searchString,
            "filters" : ["exists":["usda_fields":true]] //dictionaryception
        ]
        
        var error:NSError?
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: { (data, responce, err) -> Void in
            
            //gets string from data
            var stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            //gets dictionary fro string
            var error: NSError?
            
            var jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: &error) as? NSDictionary
            println(jsonDictionary)
            
        })

        task.resume()
        
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}

