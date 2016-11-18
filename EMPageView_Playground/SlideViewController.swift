//
//  SlideViewController.swift
//  EMPageView_Playground
//
//  Created by Laura Evans on 11/18/16.
//  Copyright © 2016 Laura Evans. All rights reserved.
//

import UIKit

class SlideViewController: UIViewController {
    
    
    @IBOutlet weak var slideLabel: UILabel!
    var slideText: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        slideLabel.text = slideText
    }

}
