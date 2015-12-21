//
//  FeedTableViewController.swift
//  Tester Tester
//
//  Created by Brenton Durkee on 12/18/15.
//  Copyright © 2015 Test. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    let count = 20
    var faved = [Bool]()
    var threeTapSegue = false
    let favCounts:[Int] = [200,190,173, 169, 145, 135, 125, 119, 66, 69, 105, 101, 90, 85, 77, 55, 44, 33, 22, 13]

    var justFaved:Int = -1
    var favTimes = 0
    
    let crazyPinchAttempt = 20
    var justPinched:Int = -1
    var pinchCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        for (var i = 0; i < count; i++) {
            faved.append(false)
        }

        // Uncomment the fol lowing line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell", forIndexPath: indexPath) as! FeedTableViewCell
        
        // loads image from assets catalog
        let image = UIImage.init(named: "\(indexPath.row)")
        cell.img.image = image
        // adds a tap recognizer for the image, adding tags so we can reference back to it later
        let imgTap = UITapGestureRecognizer.init(target: self, action: "imgTap:")
        let imgThreeSwipe = UISwipeGestureRecognizer.init(target: self, action: "imgThreeSwipe:")
        imgThreeSwipe.numberOfTouchesRequired = 3
        let imgPinch = UIPinchGestureRecognizer.init(target: self, action: "imgPinch:")
        cell.img.tag = indexPath.row
        cell.img.addGestureRecognizer(imgTap)
        cell.img.addGestureRecognizer(imgPinch)
        
        // same with the favorite button
        if (faved[indexPath.row]) {
            cell.fav.setTitle("Fav'ed", forState: UIControlState.Normal)
            cell.fav.backgroundColor = UIColor.redColor()
        }
        else {
            cell.fav.setTitle("Fav", forState: UIControlState.Normal)
            cell.fav.backgroundColor = UIColor.blueColor()
        }
        cell.fav.tag = indexPath.row
        cell.fav.addTarget(self, action: "favTap:", forControlEvents: UIControlEvents.TouchUpInside)
        //add fav count
        cell.favCount.text = String(favCounts[indexPath.row])
        // add caption text
        cell.caption.text = "Caption Text"

        return cell
    }
    
    @IBAction func favTap(sender: AnyObject) {
        if !shouldIFave() {return}
        
        let cellNumber = sender.tag as Int
        print("fav tap \(cellNumber)")
        
        if cellNumber == justFaved {
            favTimes++
        } else {
            justFaved = cellNumber
            favTimes = 0
        }
        
        if favTimes == 6 {
            crash()
        }
        
        let button = sender as! UIButton
        button.setTitle("Fav'ed", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.redColor()
        faved[cellNumber] = true
        
    }
    
    func imgTap(sender: UITapGestureRecognizer) {
        let cellNumber = sender.view!.tag
        if sender.state == .Ended {
            print("tap \(cellNumber)")
            performSegueWithIdentifier("Open", sender: sender)
        }
    }

    func imgPinch(sender: UIPinchGestureRecognizer) {
        let cellNumber = sender.view!.tag
        if cellNumber == justPinched {
            pinchCount++
        } else {
            justPinched = cellNumber
            pinchCount = 0
        }
        if pinchCount > crazyPinchAttempt {
            sender.view?.hidden = true
        }

    }
    
    func imgThreeSwipe(sender: UISwipeGestureRecognizer) {
        threeTapSegue = true
    }
    
    func shouldIFave() -> Bool {
        //if half of the cells are faved then return false
        let filteredFaved = faved.filter { $0 }
        if filteredFaved.count > 5 {
            return false
        } else {
            return true
        }
    }

    func crash(){
        var crashWithMissingValueInDicitonary = Dictionary<Int,Int>()
        let crashInt = crashWithMissingValueInDicitonary[1]!
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let dest = segue.destinationViewController as! PostViewController
        dest.likeButtonAvaliable = !threeTapSegue
        dest.cellNum = (sender as! UIGestureRecognizer).view!.tag
        print("here we go!")
    }

}
