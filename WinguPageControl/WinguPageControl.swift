//
//  WinguPageControl.swift
//  winguSDK
//
//  Created by Jakub Mazur on 31/03/2017.
//  Copyright © 2017 wingu AG. All rights reserved.
//

import UIKit

@IBDesignable
public class WinguPageControl: NibLoadingView {
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    public var delegate : PageControlProtocol?
    
    public var numberOfElements : NSInteger = 1 {
        didSet {
            guard numberOfElements > 1  else {
                self.isHidden = true
                return
            }
            self.isHidden = false
            let elementWidth = self.frame.size.height/2
            self.widthConstraint.constant = (elementWidth*CGFloat(numberOfElements))+(self.stackView.spacing*(CGFloat(numberOfElements)-1))
            for _ in 0...(numberOfElements-1) {
                let dot : WinguSingleDotPageControl = WinguSingleDotPageControl()
                dot.singleColor = color ?? UIColor.white
                self.stackView.addArrangedSubview(dot)
            }
            (self.stackView.arrangedSubviews[0] as! WinguSingleDotPageControl).preloadedSelection = true
            self.delegate?.fullyDisplayPageAtIndex(0)
            self.layoutSubviews()
        }
    }
    
    public var color : UIColor?
    
    public var offset : CGFloat = 0 {
        didSet {
            guard stackView.arrangedSubviews.count > 0 else { return }
            let lowerPine : NSInteger = NSInteger(floor(offset))
            let higherPine : NSInteger = NSInteger(ceil(offset))
            guard lowerPine != higherPine else {
                self.emphasizeSame(lowerPine)
                return
            }
            if lowerPine == higherPine {
                return
            }
            guard lowerPine >= 0 else {
                self.emphasizeFirst(higherPine)
                return
            }
            guard higherPine < numberOfElements else {
                self.emphasizeLast(lowerPine)
                return
            }
            self.animateChange(lowerPine,higherPine)
        }
    }
    
    private func emphasizeSame(_ index : NSInteger) {
        let exactDot : WinguSingleDotPageControl = self.stackView.arrangedSubviews[index] as! WinguSingleDotPageControl
        exactDot.update(1)
        self.delegate?.fullyDisplayPageAtIndex(index)
    }
    
    private func emphasizeLast(_ index : NSInteger) {
        let exactDot : WinguSingleDotPageControl = self.stackView.arrangedSubviews[index] as! WinguSingleDotPageControl
        let value = 1+(offset-CGFloat(numberOfElements-1))
        exactDot.update(value)
    }
    
    private func emphasizeFirst(_ index : NSInteger) {
        let exactDot : WinguSingleDotPageControl = self.stackView.arrangedSubviews[index] as! WinguSingleDotPageControl
        exactDot.update(1+abs(offset))
    }
    
    private func animateChange(_ lower : NSInteger, _ higher : NSInteger) {
        let lowDot : WinguSingleDotPageControl = self.stackView.arrangedSubviews[lower] as! WinguSingleDotPageControl
        let highDot : WinguSingleDotPageControl = self.stackView.arrangedSubviews[higher] as! WinguSingleDotPageControl
        let tiltingLower : CGFloat = CGFloat(higher)-offset
        let tiltingHigher : CGFloat = offset-CGFloat(lower)
        lowDot.update(tiltingLower)
        highDot.update(tiltingHigher)
        self.delegate?.partialDisplay(lower, higher, tiltingLower, tiltingHigher)
    }
    
    public func updateState(_ offset : CGFloat, pageWidth : CGFloat, force : Bool) {
        if force == true { self.forceUpdate() }
        let value = offset/pageWidth
        self.offset = value
    }
    
    private func forceUpdate() {
        for view in self.stackView.arrangedSubviews {
            (view as? WinguSingleDotPageControl)?.update(0)
        }
    }
}

public protocol PageControlProtocol {
    func fullyDisplayPageAtIndex(_ index : NSInteger)
    func partialDisplay(_ lowerPine : NSInteger, _ higherPine : NSInteger, _ tiltLow : CGFloat, _ tiltHeight : CGFloat)
}
