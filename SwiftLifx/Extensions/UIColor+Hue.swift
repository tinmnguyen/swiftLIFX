//
//  UIColor+Hue.swift
//  SwiftLifx
//
//  Created by Tin Nguyen on 10/13/14.
//  Copyright (c) 2014 Tin Nguyen. All rights reserved.
//

import UIKit

extension UIColor {
    
    func getHSV() -> (hue: CGFloat, saturation: CGFloat, value: CGFloat) {
        var h, s, v, a: CGFloat
        
        h = 0.0
        s = 0.0
        v = 0.0
        a = 0.0
        
        self.getHue(&h, saturation: &s, brightness: &v, alpha: &a)
        
        h = h * LFXHSBKColorMaxHue
        
        return (h, s, v)
    }
    
}
