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
    
    
    
    
    //saves stuff to coredata
    func saveUSDAItemsForId(idValue:String, json:NSDictionary) {
        
        if json["hits"] != nil {
            let results:[AnyObject] = json["hits"]! as [AnyObject]
            
            for itemDictionary in results {
                
                if itemDictionary["_id"] != nil && itemDictionary["_id"] as String == idValue { //finds the correct dictionary reference
                    
                    //confirm the dictionanry isnt already in core data
                    
                    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
                    
                    var requestForUSDAItem = NSFetchRequest(entityName: "USDAItem")
                    
                    let itemDictionaryId = itemDictionary["_id"]! as String
                    
                    let predicate = NSPredicate(format: "idValue == %@", itemDictionaryId)  // %@ is replaced by itemDictionaryID
                    
                    requestForUSDAItem.predicate = predicate
                    
                    var error:NSError?
                    
                    var items = managedObjectContext?.executeFetchRequest(requestForUSDAItem, error: &error)
                    
                    
                    
                    
                    if items?.count != 0 {
                        //the item is already saved
                        return
                    }else{
                        //havnt yet saved in coredata
                        println("Lets save this DATA")
                        
                        
                        let entityDescription = NSEntityDescription.entityForName("USDAItem", inManagedObjectContext: managedObjectContext!)
                        
                        let usdaItem = USDAItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!) //made new coredata object
                        
                        usdaItem.idValue = itemDictionary["_id"]! as String //assigning attributes to the newobject
                        usdaItem.dateAdded = NSDate()
                        
                        if itemDictionary["fields"] != nil {
                            let fieldsDictionary = itemDictionary["fields"]! as NSDictionary
                            if fieldsDictionary["item_name"] != nil {
                                usdaItem.name = fieldsDictionary["item_name"]! as String
                            }
                            
                            if fieldsDictionary["usda_fields"] != nil {
                                let usdaFieldsDictionary = fieldsDictionary["usda_fields"]! as NSDictionary
                                
                                if usdaFieldsDictionary["CA"] != nil {
                                    let calciumDictionary = usdaFieldsDictionary["CA"]! as NSDictionary
                                    let calciumValue:AnyObject = calciumDictionary["value"]!
                                    usdaItem.calcium = "\(calciumValue)"
                                }else{
                                    usdaItem.calcium = "0"
                                }
                                
                                
                                
                                if usdaFieldsDictionary["CHOCDF"] != nil {
                                    let carbohydrateDictionary = usdaFieldsDictionary["CHOCDF"]! as NSDictionary
                                    if carbohydrateDictionary["value"] != nil {
                                        let carbohydrateValue: AnyObject = carbohydrateDictionary["value"]!
                                        usdaItem.carbohydrate = "\(carbohydrateValue)"
                                    }
                                }
                                else {
                                    usdaItem.carbohydrate = "0"
                                }
                                
                                
                                
                                
                                if usdaFieldsDictionary["FAT"] != nil {
                                    let fatTotalDictionary = usdaFieldsDictionary["FAT"]! as NSDictionary
                                    if fatTotalDictionary["value"] != nil {
                                        let fatTotalValue:AnyObject = fatTotalDictionary["value"]!
                                        usdaItem.fatTotal = "\(fatTotalValue)"
                                    }
                                }
                                else {
                                    usdaItem.fatTotal = "0"
                                }
                                
                                
                                
                                
                                // Cholesterol Grouping
                                if usdaFieldsDictionary["CHOLE"] != nil {
                                    let cholesterolDictionary = usdaFieldsDictionary["CHOLE"]! as NSDictionary
                                    if cholesterolDictionary["value"] != nil {
                                        let cholesterolValue: AnyObject = cholesterolDictionary["value"]!
                                        usdaItem.cholesterol = "\(cholesterolValue)"
                                    }
                                }
                                else {
                                    usdaItem.cholesterol = "0"
                                }
                                
                                // Protein Grouping
                                if usdaFieldsDictionary["PROCNT"] != nil {
                                    let proteinDictionary = usdaFieldsDictionary["PROCNT"]! as NSDictionary
                                    if proteinDictionary["value"] != nil {
                                        let proteinValue: AnyObject = proteinDictionary["value"]!
                                        usdaItem.protein = "\(proteinValue)"
                                    }
                                }
                                else {
                                    usdaItem.protein = "0"
                                }
                                
                                // Sugar Total
                                if usdaFieldsDictionary["SUGAR"] != nil {
                                    let sugarDictionary = usdaFieldsDictionary["SUGAR"]! as NSDictionary
                                    if sugarDictionary["value"] != nil {
                                        let sugarValue:AnyObject = sugarDictionary["value"]!
                                        usdaItem.sugar = "\(sugarValue)"
                                    }
                                }
                                else {
                                    usdaItem.sugar = "0"
                                }
                                
                                // Vitamin C
                                if usdaFieldsDictionary["VITC"] != nil {
                                    let vitaminCDictionary = usdaFieldsDictionary["VITC"]! as NSDictionary
                                    if vitaminCDictionary["value"] != nil {
                                        let vitaminCValue: AnyObject = vitaminCDictionary["value"]!
                                        usdaItem.vitaminC = "\(vitaminCValue)"
                                    }
                                }
                                else {
                                    usdaItem.vitaminC = "0"
                                }
                                
                                // Energy
                                if usdaFieldsDictionary["ENERC_KCAL"] != nil {
                                    let energyDictionary = usdaFieldsDictionary["ENERC_KCAL"]! as NSDictionary
                                    if energyDictionary["value"] != nil {
                                        let energyValue: AnyObject = energyDictionary["value"]!
                                        usdaItem.energy = "\(energyValue)"
                                    }
                                }
                                else {
                                    usdaItem.energy = "0"
                                }
                                
                                
                                //saves everything to core data
                                (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
                                
                                
                            }
                        }
                        
                        
                    }
                }
                
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}