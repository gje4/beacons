//
//  Constants.swift
//  BeaconFinder
//
//  Created by George FitzGibbons on 3/6/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
  
  @IBOutlet weak var imgIcon: UIImageView!
  @IBOutlet weak var lblName: UILabel!
  @IBOutlet weak var lblLocation: UILabel!
  
  var item: Item? = nil {
    didSet {
      if let item = item {
        lblName.text = item.name
        lblLocation.text = item.locationString()
        
      } else {
        imgIcon.image = nil
        lblName.text = ""
        lblLocation.text = ""
      }
    }
  }
  
  func refreshLocation() {
    lblLocation.text = item?.locationString() ?? ""
  }
}
