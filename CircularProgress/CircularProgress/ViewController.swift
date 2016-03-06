//
//  ViewController.swift
//  CircularProgress
//
//  Created by  lifirewolf on 16/3/3.
//  Copyright © 2016年  lifirewolf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progressView: CircularProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.roundedCorners = true
        progressView.trackTintColor = UIColor.whiteColor()
        progressView.progressTintColor = UIColor.blueColor()
        progressView.thicknessRatio = 0.1
        progressView.progress = 0.5
        
    }
}

