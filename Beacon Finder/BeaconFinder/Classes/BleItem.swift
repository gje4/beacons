//
//  BleItem.swift
//  BeaconFinder
//
//  Created by George FitzGibbons on 2/27/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import Foundation
import CoreLocation

struct BleItemConstant {
    static let bleNameKey = "bleName"
    static let advertisementDataKey = "advertisementData"
    static let peripheralKey = "peripheral"
}

class BleItem: NSObject, NSCoding {
    let bleName: String?
    let advertisementData: String
    let peripheral: String
    
    init(name: String?, advertisementData: String, peripheral: String) {
        self.bleName = name
        self.advertisementData = advertisementData
        self.peripheral = peripheral
    }
    
    // MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        let aBleName = aDecoder.decodeObject(forKey: BleItemConstant.bleNameKey) as? String
        bleName = aBleName ?? ""
        
        let aAdvertisementData = aDecoder.decodeObject(forKey: BleItemConstant.advertisementDataKey) as? String
        advertisementData = aAdvertisementData ?? ""
        
        let aPeripheral = aDecoder.decodeObject(forKey: BleItemConstant.peripheralKey) as? String
        peripheral = aPeripheral ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(bleName, forKey: BleItemConstant.bleNameKey)
        aCoder.encode(advertisementData, forKey: BleItemConstant.advertisementDataKey)
        aCoder.encode(peripheral, forKey: BleItemConstant.peripheralKey)
    }
    
}





