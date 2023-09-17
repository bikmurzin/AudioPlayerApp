////   /*
//
//  Project: AudioPlayerApp
//  File: Model.swift
//  Created by: Robert Bikmurzin
//  Date: 15.09.2023
//
//  Status: in progress | Decorated
//
//  */

import Foundation
import AVFoundation

class Model: NSObject, AVAudioPlayerDelegate {
    var songs: [Song] = []
    var player: AVAudioPlayer?
    var currentIndex = 0
    weak var delegate: PlayerViewControllerProtocolForModel?
    
    override init() {
        songs = Song.songs()
        for i in 0..<songs.count {
            let urlString = Bundle.main.path(forResource: songs[i].fileName, ofType: "mp3")
            do {
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                guard let urlString = urlString else {
                    print("urlstring is nil")
                    return
                }
                player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
                guard let player = player else {
                    print("player is nil")
                    return
                }
                songs[i].duration = player.duration
                self.player = nil
                
            }
            catch {
                print("error occurred")
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard let delegate = delegate else {return}
        
        nextSong()
        playSong()
        
        delegate.trackHasEnded()
    }
    
    func playSong() {
        guard let player = player else {
            print("player is nil")
            return
        }
        player.play()
    }
    
    func specifySong(index: Int) {
        currentIndex = index
        let song = songs[currentIndex]
        let urlString = Bundle.main.path(forResource: song.fileName, ofType: "mp3")
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            guard let urlString = urlString else {
                print("urlstring is nil")
                return
            }
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            player?.delegate = self
//            playSong()
        }
        catch {
            print("error occurred")
        }
    }
    
    func nextSong() {
        let nextIndex: Int = {
            if currentIndex + 1 == self.songs.count {
                return 0
            } else {
                return currentIndex + 1
            }
        }()
        if let player = player {
            if player.isPlaying {
                specifySong(index: nextIndex)
                playSong()
            } else {
                specifySong(index: nextIndex)
            }
        }
    }
    
    func previousSong() {
        let previousIndex: Int = {
            if currentIndex - 1 == -1 {
                return songs.count - 1
            } else {
                return currentIndex - 1
            }
        }()
        if let player = player {
            if player.isPlaying {
                specifySong(index: previousIndex)
                playSong()
            } else {
                specifySong(index: previousIndex)
            }
        }
    }
    
    func durationInMinutes(_ duration: Double?) -> String {
        if let duration = duration {
            let stringDuration = Duration(
                secondsComponent: Int64(duration),
                attosecondsComponent: 0
            ).formatted(.time(pattern: .minuteSecond(padMinuteToLength: 2)))
            return stringDuration
        } else {
            return "00:00"
        }
    }
}
