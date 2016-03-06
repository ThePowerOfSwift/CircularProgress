//
//  LabeledCircularProgressView.swift
//  CircularProgress
//
//  Created by  lifirewolf on 16/3/3.
//  Copyright © 2016年  lifirewolf. All rights reserved.
//

import UIKit

class LabeledCircularProgressView: CircularProgressView {
    
    var progressLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeLabel()
    }
    
    func initializeLabel() {
        
        if progressLabel == nil {
            progressLabel = UILabel(frame: bounds)
            progressLabel.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
            progressLabel.textAlignment = NSTextAlignment.Center
            progressLabel.backgroundColor = UIColor.clearColor()
            addSubview(progressLabel)
        }
    }
    
}
