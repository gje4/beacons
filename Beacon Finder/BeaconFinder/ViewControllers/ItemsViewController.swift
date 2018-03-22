//
//  Constants.swift
//  BeaconFinder
//
//  Created by George FitzGibbons on 3/6/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

let storedItemsKey = "storedItems"


class ItemsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scanButton: UIButton!

    var items = [Item]()
    var itemsBLE = [Item]()

    let locationManager = CLLocationManager()
    var bluetoothPowerOn = false
    var isViewScanning = false
    var products = [AnyObject]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        self.scanButton.setTitle("Start Scanning", for: .normal)
        
        //Fetch products in case want to show
        let products = MoltinManager.instance().getProducts()
        
        self.startScan()
        loadItems()
    }
    
    func startScan() {
        if(bluetoothPowerOn)
        {
            self.isViewScanning = true
            print("Now Scanning...")
            self.scanButton.setTitle("Stop Scanning", for: .normal)
            BeaconScannerManager.instance().beaconScan()
        }
        else
        {
            let detailMessage = "Your phone bluetooth is turned off.  To scan you need bluetooth"
            let detailAlert = UIAlertController(title: "Need Bluetooth", message: detailMessage, preferredStyle: .alert)
            detailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(detailAlert, animated: true, completion: nil)
        }
    }
    
    func loadItems() {
        guard let storedItems = UserDefaults.standard.array(forKey: storedItemsKey) as? [Data] else { return }
        for itemData in storedItems {
            guard let item = NSKeyedUnarchiver.unarchiveObject(with: itemData) as? Item else { continue }
            items.append(item)
            startMonitoringItem(item)
        }
    }
    
    func persistItems() {
        var itemsData = [Data]()
        for item in items {
            let itemData = NSKeyedArchiver.archivedData(withRootObject: item)
            itemsData.append(itemData)
        }
        UserDefaults.standard.set(itemsData, forKey: storedItemsKey)
        UserDefaults.standard.synchronize()
    }
    
    func startMonitoringItem(_ item: Item) {
        let beaconRegion = item.asBeaconRegion()
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func stopMonitoringItem(_ item: Item) {
        let beaconRegion = item.asBeaconRegion()
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(in: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        // Find the same beacons in the table.
        var indexPaths = [IndexPath]()
        for beacon in beacons {
            for row in 0..<items.count {
                if items[row] == beacon {
                    items[row].beacon = beacon
                    indexPaths += [IndexPath(row: row, section: 0)]
                }
                
            }
        }
        
        // Update beacon locations of visible rows.
        if let visibleRows = tableView.indexPathsForVisibleRows {
            let rowsToUpdate = visibleRows.filter { indexPaths.contains($0) }
            for row in rowsToUpdate {
                let cell = tableView.cellForRow(at: row) as! ItemCell
                cell.refreshLocation()
            }
        }
        
    }
    
    //handle navigation to modal
    func showProduct(){
        let productViewController = ProductModalViewController(nibName: "ProductModal", bundle: nil)
        productViewController.sProducts = products
        self.present(productViewController, animated: false, completion: nil)
    }
    
    // Called when it succeeded
    func centralManager(central: CBCentralManager,
                        didConnectPeripheral peripheral: CBPeripheral)
    {
        print("connected!")
    }
    // Called when it failed
    private func centralManager(central: CBCentralManager,
                        didFailToConnectPeripheral peripheral: CBPeripheral,
                        error: Error?)
    {
        print("failed…")
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
        if (central.state.rawValue == 5) {
            bluetoothPowerOn = true
            BeaconScannerManager.instance().beaconScan()
        }
        else
        {
                bluetoothPowerOn = false
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,advertisementData: [String : Any], rssi RSSI: NSNumber) {

            print("We found a new pheripheral devices with services")
            print("Peripheral name: \(String(describing: peripheral.name))")
            print("**********************************")
            print ("Advertisement Data : \(advertisementData)")
        
        //add to list and check the list to display to make sure its uniqe
        if(peripheral.name != nil)
        {
            //add to a list, make sure no duplicates
            let detailMessage = "Peripheral name: \(String(describing: peripheral.name))"
            let detailAlert = UIAlertController(title: "Details", message: detailMessage, preferredStyle: .alert)
            detailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(detailAlert, animated: true, completion: nil)
        }
    }
    
    //Button
    @IBAction func startScanningPressed(_ sender: Any) {
        //for testing just add the modal
        self.showProduct()
        
        if(!isViewScanning)
        {
            self.startScan()
        }
        else{
            isViewScanning = false
            BeaconScannerManager.instance().stopScan()
            self.scanButton.setTitle("Start Scanning", for: .normal)
        }
        
    }
    
    
}



// MARK: UITableViewDataSource
extension ItemsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemCell
        cell.item = items[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            stopMonitoringItem(items[indexPath.row])
            
            tableView.beginUpdates()
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            persistItems()
        }
    }
}

// MARK: UITableViewDelegate
extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[indexPath.row]
        let detailMessage = "UUID: \(item.uuid.uuidString)\nMajor: \(item.majorValue)\nMinor: \(item.minorValue)"
        let detailAlert = UIAlertController(title: "Details", message: detailMessage, preferredStyle: .alert)
        detailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(detailAlert, animated: true, completion: nil)
    }
}

// MARK: CLLocationManagerDelegate
extension ItemsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
}



