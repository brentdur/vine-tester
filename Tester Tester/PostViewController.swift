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
    
    var plays = 0
    var ticks = 0
    var likeButtonAvaliable: Bool = true
    var timer = NSTimer()
    
    private var firstAppear = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded \(cellNum)")
        commentsView.text = ""
        if (!likeButtonAvaliable) {
            likeButton.hidden = true
        }
        let baseColor = UIColor.blueColor()
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        baseColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let newColor = UIColor.init(red: red, green: green, blue: blue - 50, alpha: alpha)
        favButton.backgroundColor = newColor
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerTick", userInfo: nil, repeats: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //random of 4 seems to never hit so made it random 3
        let somerandom = Int(arc4random_uniform(3) + 1)
        print("random is \(somerandom)")
        if somerandom == 3 { return }
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
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: nil, object: nil)
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
        if cellNum != 19 {
            self.player.playFromBeginning()
            playBug()            
        }

    }
    
    func willEnterForeground(notification: NSNotification!) {
        // do whatever you want when the app is brought back to the foreground
        print("foreground")
        self.player.playFromBeginning()
        //wait for a while and then crash
        sleep(4)
        crash()
    }
    
    func crash(){
        var crashWithMissingValueInDicitonary = Dictionary<Int,Int>()
        let crashInt = crashWithMissingValueInDicitonary[1]!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func like(sender: AnyObject) {
        likeButton.backgroundColor = UIColor.blueColor()
        likeButton.setTitle("Liked", forState: UIControlState.Normal)
    }

    @IBAction func fav(sender: AnyObject) {
    }
    
    @IBAction func addComment(sender: AnyObject) {
        self.view.endEditing(true)
        var text = NSString.init(string: commentField.text!)
        text = NSString.stringByRemovingEmoji(text)()
        commentsView.text = commentsView.text! + "\n\(text)"
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
        if plays <= 4 {
            player.playFromBeginning()
        }
        playBug()
    }
    
    @IBAction func tapPlayer(sender: AnyObject) {
        if player.playbackState == PlaybackState.Paused {
            player.playFromCurrentTime()
        } else if player.playbackState == PlaybackState.Playing {
            player.pause()
            plays++
        }
        if plays > 4 {
            player.stop()
        }
    }
    
    func playBug() {
        
        if plays > 4 {
            player.stop()
        }
    }
    
    func timerTick(){
        ticks++
        if ticks > 5*60 {
            crash()
        }
    }
}

enum AppError : ErrorType {
    case InvalidResource(String, String)
}

