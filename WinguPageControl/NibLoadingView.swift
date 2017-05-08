//
//  NibLoadingView.swift
//  winguSDK
//
//  Created by Jakub Mazur on 16/02/2017.
//  Copyright © 2017 wingu AG. All rights reserved.
//

import UIKit

// Usage: Subclass your UIView from NibLoadView to automatically load a xib with the same name as your class

@IBDesignable
public class NibLoadingView: UIView {
    
    @IBOutlet weak var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        view = BaseNibLoading.nibSetup(self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        view = BaseNibLoading.nibSetup(self)
    }
}

class BaseNibLoading : NSObject {
    class func loadViewFromNib(_ obj : UIView) -> UIView {
        let bundle = Bundle(for: type(of: obj))
        let nib = UINib(nibName: String(describing: type(of: obj)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: obj, options: nil).first as! UIView
        
        return nibView
    }
    
    class func nibSetup(_ obj : UIView) -> UIView {
        obj.backgroundColor = .clear
        var view : UIView = UIView()
        view = BaseNibLoading.loadViewFromNib(obj)
        view.frame = obj.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        obj.addSubview(view)
        return view
    }
    
}
