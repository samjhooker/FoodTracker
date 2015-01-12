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
    
    var searchController: UISearchController! //more or less allows us to make a search bar
    
    var suggestedSearchFoods:[String]=[]        // all items
    var filteredSuggestedSearchFoods:[String]=[]// all items after searched
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.searchController = UISearchController(searchResultsController: nil) //can choose a seperate tableView controllerif necessary
        
        self.searchController.searchResultsUpdater = self
        
        self.searchController.dimsBackgroundDuringPresentation = false
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        
        
        self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0)
        
        self.tableView.tableHeaderView = self.searchController.searchBar //header is alto created with the table view
        
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
    
    
    
    
    
    
    
    
    //UISearchResultsUpdatingDelegate
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    


}

