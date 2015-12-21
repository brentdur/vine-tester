//
//  FeedTableViewCell.swift
//  Tester Tester
//
//  Created by Brenton Durkee on 12/18/15.
//  Copyright © 2015 Test. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
  
    @IBOutlet weak var fav: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var favCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
