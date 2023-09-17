////   /*
//
//  Project: AudioPlayerApp
//  File: Protocols.swift
//  Created by: Robert Bikmurzin
//  Date: 17.09.2023
//
//  Status: in progress | Decorated
//
//  */

import Foundation

protocol PlayerViewControllerProtocolForModel: AnyObject {
    func trackHasEnded()
}

protocol SongListScreenForPlayerVC: AnyObject {
    func playerVCWillDisappear()
}
