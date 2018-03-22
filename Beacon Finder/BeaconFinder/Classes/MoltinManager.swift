//
//  MoltinManager.swift
//  BeaconFinder
//
//  Created by George FitzGibbons on 3/21/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import Foundation
import Moltin

class MoltinManager : NSObject
{
    // MARK: - properties
    var products = [AnyObject]()

    // MARK: - instance
    private static let instanceVar = MoltinManager()
    
    private override init()
    {
        super.init();
    }
    
    static func instance() -> MoltinManager
    {
        return instanceVar
    }
    
    func getProducts() -> [AnyObject]
    {
        //Make a call to retrieve the store products
        Moltin.sharedInstance().product.listing(withParameters: nil, success: { (responseDictionary) in
            
            self.products = responseDictionary?["result"] as! [AnyObject]
            print("Objects: \(self.products)")
            
            
        }) { (responseDictionary, error) in
            print("Something went wrong")
        }
    
        return products
    }
    
}
