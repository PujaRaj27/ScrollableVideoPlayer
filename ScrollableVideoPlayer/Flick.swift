//
//  Flick.swift
//  ScrollableVideoPlayer
//
//  Created by PujaRaj on 16/09/24.
//

import Foundation

struct ScrollableVideo: Codable {
    let flicks: [Flick]
}

// MARK: - Flick
struct Flick: Codable {
    let arr: [Arr]
}

// MARK: - Arr
struct Arr: Codable {
    let id: String
    let video: String
    let thumbnail: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case video, thumbnail
    }
}


