//
//  ViewController.swift
//  Tester Tester
//
//  Created by Brenton Durkee on 12/18/15.
//  Copyright © 2015 Test. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PostViewController: UIViewController, PlayerDelegate {
    
    var cellNum: Int!
    
    @IBOutlet weak var addComment: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var commentsView: UITextView!
    @IBOutlet weak var playerView: UIView!
    
    var player: Player!
    
    private var firstAppear = true
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstAppear {
            do {
                try playVideo()
                firstAppear = false
            } catch AppError.InvalidResource(let name, let type) {
                debugPrint("Could not find resource \(name).\(type)")
            } catch {
                debugPrint("Generic error")
            }
            
        }
    }
    
    private func playVideo() throws {
        self.player = Player()
        self.player.delegate = self
        self.player.view.frame = playerView.bounds
        self.addChildViewController(self.player)
        self.player.didMoveToParentViewController(self)
        
        let name = "vids/\(cellNum)"
        guard let path = NSBundle.mainBundle().pathForResource(name, ofType:"mp4") else {
            throw AppError.InvalidResource(name, "mp4")
            return
        }
        self.player.setUrl(NSURL(fileURLWithPath: path))
        playerView.addSubview(self.player.view)
        self.player.playFromBeginning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded \(cellNum)")
        commentsView.text = ""
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func like(sender: AnyObject) {
    }

    @IBAction func fav(sender: AnyObject) {
    }
    
    @IBAction func addComment(sender: AnyObject) {
        self.view.endEditing(true)
        commentsView.text = commentsView.text! + "\n\(commentField.text!)"
        commentField.text = ""
    }
    
    // MARK: PlayerDelegate
    
    func playerReady(player: Player) {
    }
    
    func playerPlaybackStateDidChange(player: Player) {
    }
    
    func playerBufferingStateDidChange(player: Player) {
    }
    
    func playerPlaybackWillStartFromBeginning(player: Player) {
    }
    
    func playerPlaybackDidEnd(player: Player) {
        player.playFromBeginning()
    }
}

enum AppError : ErrorType {
    case InvalidResource(String, String)
}

