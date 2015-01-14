//
//  DataController.swift
//  FoodTracker
//
//  Created by Samuel Hooker on 14/01/15.
//  Copyright (c) 2015 Jocus Interactive. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataController{
    
    
    
    
    //gets dictionary and returns relevent name and id for displaying a list of objects
    
    class func jsonAsUSDAIdAndNameSearchResults(json: NSDictionary) -> [(name:String, idValue:String)]{
        
        
        var usdaItemsSearchResults:[(name:String, idValue:String)] = [] //array of tuples
        
        var searchResult: (name:String, idValue:String)
        
        if json["hits"] != nil {
            let results:[AnyObject] = json["hits"]! as [AnyObject] // specify any object oinstead of worrying about both strings and ints etc
            
            for itemDictionary in results {
                
                if itemDictionary["_id"] != nil {
                    
                    if itemDictionary["fields"] != nil {
                        
                        let fieldsDictionary = itemDictionary["fields"] as NSDictionary
                        if fieldsDictionary["item_name"] != nil {
                            
                            let idValue:String = itemDictionary["_id"]! as String
                            let name = fieldsDictionary["item_name"]! as String
                            searchResult = (name:name, idValue:idValue)
                            usdaItemsSearchResults += [searchResult]
                        }
                        
                    }
                    
                }
                
            }
            
        }
        return usdaItemsSearchResults
    }
    
    
}