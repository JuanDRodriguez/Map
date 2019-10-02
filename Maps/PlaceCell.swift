//
//  PlaceCell.swift
//  Maps
//
//  Created by Pronto on 10/1/19.
//  Copyright © 2019 Pronto. All rights reserved.
//

import UIKit
import GooglePlaces

class PlaceCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func display(item: GMSPlace){
        title.text =  item.name!
    }
   
    
}
