//
//  PassiveScanManager.swift
//  BeaconFinder
//
//  Created by George FitzGibbons on 3/21/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import Foundation

class PassiveScanManager : NSObject
{
    
    // MARK: - properties
    private var isFeatureEnabled = true
    private var referrer : String?
    
    // MARK: - instance
    private static let instanceVar = PassiveScanManager()
    
    private override init()
    {
        super.init();
    }
    
    static func instance() -> PassiveScanManager
    {
        return instanceVar
    }
    
    func featureIsAvailable() -> Bool
    {
        return isFeatureEnabled
    }
    
    // MARK: - Referrer methods
    
    func setReferrer(referrer: String?)
    {
        // only set the referrer if it hasn't already been set
        if (self.referrer == nil)
        {
            self.referrer = referrer
        }
    }
    
    func getReferrer() -> String
    {
        return self.referrer ?? "unknown"
    }
    
    // MARK: - state methods
    
//    func userHasJoinedPaceAcademy() -> Bool
//    {
//        // this ensures we had a round-trip to and from the server
//        // because we pull the join date from our sync response
//        return userHasJoinedPaceAcademy(sinceDate: Date(timeIntervalSinceReferenceDate: 0))
//    }
}
