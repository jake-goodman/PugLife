//
//  PLImageCollectionViewCell.swift
//  PugLife
//
//  Created by Jake Goodman on 9/20/18.
//  Copyright © 2018 Jake Goodman. All rights reserved.
//

import UIKit
import Kingfisher

class PLImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
}
