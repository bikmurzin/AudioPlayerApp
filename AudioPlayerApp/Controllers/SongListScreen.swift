////   /*
//
//  Project: AudioPlayerApp
//  File: ViewController.swift
//  Created by: Robert Bikmurzin
//  Date: 15.09.2023
//
//  Status: in progress | Decorated
//
//  */

import UIKit
import MediaPlayer

class SongListScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let model = Model()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {return UITableViewCell()}
        let song = model.songs[indexPath.row]
        cell.title.text = song.trackName
        cell.subtitle.text = song.artistName
        cell.duration.text = model.durationInMinutes(song.duration)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        let vc = PlayerViewController()
        vc.model = model
        vc.delegate = self
        if let player = model.player {
            if model.currentIndex != indexPath.row {
                model.specifySong(index: indexPath.row)
                model.playSong()
            }
        } else {
            model.specifySong(index: indexPath.row)
            model.playSong()
        }
        present(vc, animated: true)
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}

// MARK: Protocol Implementation
extension SongListScreen: SongListScreenForPlayerVC {
    func playerVCWillDisappear() {
        guard let selectedCell = tableView.indexPathForSelectedRow else {return}
        let index = model.currentIndex
        tableView.deselectRow(at: selectedCell, animated: true)
        tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
    }
}

