//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Dongyoon Kang on 2017. 1. 27..
//  Copyright © 2017년 Dongyoon Kang. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var memedImageView: UIImageView!
    @IBOutlet weak var memedLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
