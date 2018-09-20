//
//  PLImageViewController.swift
//  PugLife
//
//  Created by Jake Goodman on 9/20/18.
//  Copyright © 2018 Jake Goodman. All rights reserved.
//

import UIKit
import Kingfisher

class PLImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var resource: Resource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.kf.setImage(with: resource)
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
