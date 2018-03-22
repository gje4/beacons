//
//  BleItem.swift
//  BeaconFinder
//
//  Created by George FitzGibbons on 2/27/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation
import Moltin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Request permission to send notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in }
        
        locationManager.delegate = self
        
        //Moltin Ecom SDK
        Moltin().setPublicId(Constants.moltinKey())
        #if RELEASE
            Moltin().setLoggingEnabled(false)
        #else
            Moltin().setLoggingEnabled(true)
            #endif
        return true
    }
    
}

// MARK: - CLLocationManagerDelegate
extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard region is CLBeaconRegion else { return }
        let content = UNMutableNotificationContent()
        content.title = "Push an alert"
        content.body = "Body of the Message"
        content.sound = .default()
        
        let request = UNNotificationRequest(identifier: "LeaveBeacon", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
