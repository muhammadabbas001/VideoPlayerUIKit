//
//  ViewController.swift
//  VideoPlayerUIKit
//
//  Created by Zeeshan Suleman on 09/03/2023.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController{
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pauseButton: UIButton!
    
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        playVideo()
    }
    
    func setupView(){
        playButton.layer.cornerRadius = 25
        playButton.isHidden = true
    }
    
    func playVideo() {
        let videoURL = URL(string: "https://static.pexels.com/lib/videos/free-videos.mp4")
        player = AVPlayer(url: videoURL!)
        player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer)
        player?.play()
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                DispatchQueue.main.async {[weak self] in
                    if newStatus == .playing || newStatus == .paused {
                        self?.activityIndicator.isHidden = true
                    } else {
                        self?.activityIndicator.isHidden = false
                    }
                }
            }
        }
    }
    
    @IBAction func playButtonAction(_ sender: UIButton) {
        if !(player?.isPlaying ?? true){
            player?.play()
            playButton.isHidden = true
            pauseButton.isHidden = false
        }
    }
    
    
    @IBAction func pauseButtonAction(_ sender: UIButton) {
        if (player?.isPlaying ?? false){
            player?.pause()
            playButton.isHidden = false
            pauseButton.isHidden = true
        }
    }
    
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
