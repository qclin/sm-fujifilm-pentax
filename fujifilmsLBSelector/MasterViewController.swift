//
//  MasterViewController.swift
//  pro1-imageSelector
//
//  Created by Qiao Lin on 4/6/16.
//  Copyright © 2016 Qiao Lin. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var images = [String]()
    var objects = [[String: String]]()
    var itemDisplay:String = "images"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fm = NSFileManager.defaultManager()
        let path = NSBundle.mainBundle().resourcePath!
        let items = try! fm.contentsOfDirectoryAtPath(path)
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            for item in items {
                if item.hasPrefix("FH0"){
                    images.append(item)
                }
            }
        } else if navigationController?.tabBarItem.tag == 1{
            for item in items {
                if (!item.hasPrefix("FH0") && item.hasSuffix(".JPG")){
                    images.append(item)
                }
            }
        }else{
            itemDisplay = "text"
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            if let url = NSURL(string: urlString) {
                if let data = try? NSData(contentsOfURL: url, options: []) {
                    let json = JSON(data: data)
                    
                    if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                        parseJSON(json)
                    } else {
                        showError()
                    }
                } else {
                    showError()
                }
            } else {
                showError()
            }
        }
        
    }
    
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func parseJSON(json: JSON) {
        for result in json["results"].arrayValue {
            let title = result["title"].stringValue
            let body = result["body"].stringValue
            let sigs = result["signatureCount"].stringValue
            let obj = ["title": title, "body": body, "sigs": sigs]
            objects.append(obj)
        }
        
        tableView.reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let navigationController = segue.destinationViewController as! UINavigationController
                let controller = navigationController.topViewController as! DetailViewController
                controller.detailItem = images[indexPath.row]
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }

    }
    

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemDisplay == "text"{
            return objects.count
        }else {
            return images.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if itemDisplay == "text"{
            let object = objects[indexPath.row]
            cell.textLabel!.text = object["title"]
            cell.detailTextLabel!.text = object["body"]
        }else {
            let object = images[indexPath.row]
            cell.textLabel!.text = object
        }
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            images.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

