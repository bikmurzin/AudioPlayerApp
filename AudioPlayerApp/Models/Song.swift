////   /*
//
//  Project: AudioPlayerApp
//  File: Song.swift
//  Created by: Robert Bikmurzin
//  Date: 15.09.2023
//
//  Status: in progress | Decorated
//
//  */

import Foundation

struct Song: Decodable{
    let fileName: String
    let artistName: String
    let trackName: String
    var duration: Double?
}

extension Song {
    static func songs() -> [Song] {
        guard
            let url = Bundle.main.url(forResource: "songs", withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else {
            return []
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Song].self, from: data)
        } catch {
            return []
        }
    }
}
