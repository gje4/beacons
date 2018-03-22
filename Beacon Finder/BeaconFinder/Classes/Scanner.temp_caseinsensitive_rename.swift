//
//  scanner.swift
//  BeaconFinder
//
//  Created by George FitzGibbons on 1/18/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import CoreBluetooth


class beaconScanner: SomeSuperclass, CBCentralManagerDelegate {
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral
