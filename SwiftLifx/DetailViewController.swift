//
//  DetailViewController.swift
//  SwiftLifx
//
//  Created by Tin Nguyen on 10/4/14.
//  Copyright (c) 2014 Tin Nguyen. All rights reserved.
//

import UIKit

public class DetailViewController: UIViewController, LFXLightObserver {

    public var light: LFXLight!
    
    @IBOutlet var brightnessSlider: UISlider!
    @IBOutlet var powerButton: UIButton!
    @IBOutlet var colorPicker: HRColorMapView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateBrightnessSlider()
        if light.powerState() == LFXPowerState.Off {
            self.powerButton.setTitle("Power on", forState: .Normal)
        }
        else {
            self.powerButton.setTitle("Power off", forState: .Normal)
        }
        
        self.title = light.label()
        
        colorPicker.addTarget(self, action: "colorChanged:" , forControlEvents: UIControlEvents.ValueChanged)
        colorPicker.brightness = 1.0
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        light.addLightObserver(self)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderValueDidChange(slider: UISlider) {
        
        self.light.setColor(self.light.color().colorWithBrightness(CGFloat(slider.value)))
        
        if light.powerState() == .Off {
            self.light.setPowerState(.On)
            self.powerButton.setTitle("Power off", forState: .Normal)
        }
    }
    
    @IBAction func powerButtonDidPress(button: UIButton) {
        if self.light.powerState() == .Off {
            self.light.setPowerState(.On)
            self.updateBrightnessSlider()
            self.powerButton.setTitle("Power off", forState: .Normal)

        }
        else {
            self.light.setPowerState(.Off)
            self.powerButton.setTitle("Power on", forState: .Normal)
            self.brightnessSlider.setValue(0.0, animated: true)
        }
        
        var color = UIColor.blueColor()
        var hsv = color.getHSV()
        
    }
    
    func updateBrightnessSlider() {
        let color = light.color()
        self.brightnessSlider.setValue(Float(color.brightness), animated: true)
        self.colorPicker.color = UIColor(hue: color.hue / LFXHSBKColorMaxHue, saturation: color.saturation, brightness: color.brightness, alpha: 1.0)
    }
    
    public func light(light: LFXLight!, didChangeReachability reachability: LFXDeviceReachability) {
        switch reachability {
        case LFXDeviceReachability.Unreachable:
            println("disconnected")
        case LFXDeviceReachability.Reachable:
        println("yo")
        default:
            println("no")
            
        }
    }
    
    func colorChanged(mapView: HRColorMapView) {
        var hsv = mapView.color.getHSV()
        
        var hsbk: LFXHSBKColor = light.color()
        
        hsbk.hue = hsv.hue
        hsbk.brightness = hsv.value
        hsbk.saturation = hsv.saturation
        
        self.light.setColor(hsbk)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
