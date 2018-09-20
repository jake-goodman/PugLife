//
//  ViewController.swift
//  PugLife
//
//  Created by Jake Goodman on 9/20/18.
//  Copyright © 2018 Jake Goodman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var pugs: [Pug] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMorePugs() {
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadMorePugs(completion: @escaping ()->Void) {
        PugService().getPugs() { [weak self] (pugs, error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: "Could not load more pugs. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
            else {
                self?.pugs.append(contentsOf: pugs)
            }
        }
    }

}

