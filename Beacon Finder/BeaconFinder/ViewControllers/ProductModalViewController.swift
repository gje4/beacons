//
//  ProductModalViewController.swift
//  BeaconFinder
//
//  Created by George FitzGibbons on 3/21/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import Foundation
import Moltin

public class ProductModalViewController: UIViewController {
    
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet var productModal: UIView!
    
    var sProducts = [AnyObject]()
    
    // MARK: lifecycle methods
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    func setUpView() {
        //just grab the first product
        let product = sProducts[0]
        
        self.productLabel.text = product.value(forKey: "title") as? String
        let price = product.value(forKeyPath: "price.data.formatted.with_tax") as? String
        self.productPriceLabel?.text = convertToUSD(originalValue: price!)

        //set the image for the product
        var imageUrl = ""
        if let images = product.object(forKey: "images") as? NSArray {
            if (images.firstObject != nil) {
                imageUrl = (images.firstObject as! NSDictionary).value(forKeyPath: "url.https") as! String
            }
            
            if let url = URL(string: imageUrl) {
                if let data = NSData(contentsOf: url) {
                     self.productImage.image = UIImage(data: data as Data)
                }
            }
        }
        
        // round corners of interstitial
        self.productModal.layer.cornerRadius = 8.0
        self.productModal.clipsToBounds = true
    }
    
    
    // MARK: button clicks
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buyNowClicked(_ sender: Any) {
    }
    
    // MARK: Helpers
    func convertToUSD (originalValue: String) -> String {
        let index = originalValue.index(originalValue.startIndex, offsetBy: 1)
        return "$\(originalValue.substring(from: index))"
    }
    
}
