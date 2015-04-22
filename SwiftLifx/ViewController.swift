//
//  ViewController.swift
//  SwiftLifx
//
//  Created by Tin Nguyen on 10/2/14.
//  Copyright (c) 2014 Tin Nguyen. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, LFXNetworkContextObserver, LFXLightCollectionObserver, LFXLightObserver {

    var lights: NSArray = []
    
    var lifxNetworkContext: LFXNetworkContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         
        #if arch(x86_64)
        DCIntrospect.sharedIntrospector().start()
        #endif
        
        self.lifxNetworkContext = LFXClient.sharedClient().localNetworkContext
        self.lifxNetworkContext.addNetworkContextObserver(self)
        self.lifxNetworkContext.allLightsCollection.addLightCollectionObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if let light = self.lights[indexPath.row] as? LFXLight {
            if light.powerState() == LFXPowerState.Off {
                light.setPowerState(LFXPowerState.On)
            }
            else {
                light.setPowerState(LFXPowerState.Off)
            }
        }

        tableView.setEditing(false, animated: false)
        
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "Power"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        if let light = lights[indexPath.row] as? LFXLight {
            cell.textLabel?.text = "\(light.label())"
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lights.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//    
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        let light = lights[indexPath.row] as LFXLight
//        
//        let detail:DetailViewController = DetailViewController();
//        
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     
        if segue.identifier == "PushDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow()
            
            if let v = segue.destinationViewController as? DetailViewController {
                v.light = self.lights[indexPath!.row] as! LFXLight
            }
        }
    }
    
//MARK: -
//MARK: LFX

    func networkContextDidConnect(networkContext: LFXNetworkContext!) {
    
    }
    
    func networkContextDidDisconnect(networkContext: LFXNetworkContext!) {
        
    }
    
    func networkContext(networkContext: LFXNetworkContext!, didAddTaggedLightCollection collection: LFXTaggedLightCollection!) {
        //collection.addLightCollectionObserver(self)
    }

    func networkContext(networkContext: LFXNetworkContext!, didRemoveTaggedLightCollection collection: LFXTaggedLightCollection!) {
        
    }
    
    func lightCollection(lightCollection: LFXLightCollection!, didAddLight light: LFXLight!) {
        light.addLightObserver(self)
        self.lights = self.lifxNetworkContext.allLightsCollection.lights
        self.tableView.reloadData()
    }
    
    func lightCollection(lightCollection: LFXLightCollection!, didRemoveLight light: LFXLight!) {
        
    }
    
    
}

