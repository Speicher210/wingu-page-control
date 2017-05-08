//
//  WinguSingleDotPageControl.swift
//  winguSDK
//
//  Created by Jakub Mazur on 31/03/2017.
//  Copyright © 2017 wingu AG. All rights reserved.
//

import UIKit

class WinguSingleDotPageControl: NibLoadingView {
    
    @IBOutlet weak var dotHeight: NSLayoutConstraint!
    @IBOutlet weak var fillerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var upperDot: UIView!
    @IBOutlet weak var filler: UIView!
    @IBOutlet weak var lowerDot: UIView!
    
    var singleColor : UIColor? {
        didSet {
            self.upperDot.backgroundColor = singleColor
            self.lowerDot.backgroundColor = singleColor
            self.filler.backgroundColor = singleColor
        }
    }
    
    var preloadedSelection : Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.update(self.preloadedSelection == true ? 1 : 0)
    }
    
    func update(_ value : CGFloat) {
        self.fillerHeight.constant = self.frame.size.height/2*value
        self.dotHeight.constant = (self.frame.size.height/2)  + (self.frame.size.height/2*value)
        self.upperDot.layer.cornerRadius = self.frame.size.width/2
        self.lowerDot.layer.cornerRadius = self.frame.size.width/2
    }
}
