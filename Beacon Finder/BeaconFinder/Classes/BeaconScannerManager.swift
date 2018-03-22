//
//  BeaconScannerManager.swift
//  BeaconFinder
//
//  Created by George FitzGibbons on 2/27/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import Foundation
import CoreBluetooth


class BeaconScannerManager:NSObject, CBCentralManagerDelegate {
    
    var centralManager: CBCentralManager?

    // MARK: - instance
    private static let instanceVar = BeaconScannerManager()
    
    private override init()
    {
        super.init();
    }
    
    static func instance() -> BeaconScannerManager
    {
        return instanceVar
    }
    

    func beaconScan() {
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScan() {
        centralManager?.stopScan()
    }
    
    func tryToConnect(peripheral: CBPeripheral) {
        centralManager?.connect(peripheral, options: nil)
    }
    
    // Called when it succeeded
    func centralManager(central: CBCentralManager,
                        didConnectPeripheral peripheral: CBPeripheral)
    {
        print("connected")
    }
    // Called when it failed
    private func centralManager(central: CBCentralManager,
                        didFailToConnectPeripheral peripheral: CBPeripheral,
                        error: Error?)
    {
        print("failed")
    }
    
    func centralManager(central: CBCentralManager,
                        didDiscoverPeripheral peripheral: CBPeripheral,
                        advertisementData: [String : AnyObject],
                        RSSI: NSNumber!)
    {
        print("peripheral: \(peripheral)")
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("state: \(central.state)")
    }

}


