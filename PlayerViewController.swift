//
//  PlayerViewController.swift
//  HGC Internal
//
//  Created by user161027 on 11/28/19.
//  Copyright © 2019 Jay Sastry. All rights reserved.
//

import AVFoundation
import UIKit
import AVKit

class PlayerViewController: UIViewController {

    var song: subwork!
    
    @IBOutlet var titleVar: UILabel!
    @IBOutlet var yearVar: UILabel!
    @IBOutlet var artistAlbumVar: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        titleVar.text = song.stitle
        yearVar.text = String(song.year.prefix(4))
        var album = ""
        var artist = ""
        
        if song.album != nil {
            album = String(song.album)
        }

        if song.artist != nil {
            artist = String(song.artist)
        }

        artistAlbumVar.text = "\(artist)\n\n\(album)"

    }

    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
     
        return true
    }
    

    

    @IBAction func playMusic(_ sender: AnyObject) {
        guard let url = URL(string: "https://wrapapi.com/use/sastryj24/cs50/hgcdownload1/0.0.1?downloadurl=audio%2Fdownload%2F16499%2FAbendlied.mp3&stateToken=\(ViewController.keys)&wrapAPIKey=QoUv0L22KUQYHSKo7LfSOHsVQcmglUJW") else {
        return
        }
        
//        print(ViewController.cookie!)
//        let cookiesArray = ViewController.cookie!
//        let values = HTTPCookie.requestHeaderFields(with: cookiesArray)
//        let cookieArrayOptions = ["AVURLAssetHTTPHeaderFieldsKey": values]
//        let assets = AVURLAsset(url: url as URL, options: cookieArrayOptions)
//        let item = AVPlayerItem(asset: assets)
//        let player = AVPlayer(playerItem: item)
//
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: url)
     
        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player
     
        // Modally present the player and call the player's play() method when complete.
        present(controller, animated: true) {
            player.play()
        }
        }
}
