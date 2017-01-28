//
//  Meme.swift
//  MemeMe
//
//  Created by Dongyoon Kang on 2017. 1. 24..
//  Copyright © 2017년 Dongyoon Kang. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    // MARK : Properties
    var topText : String
    var bottomText : String
    var image : UIImage
    var memedImage : UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = originalImage
        self.memedImage = memedImage
    }
}
