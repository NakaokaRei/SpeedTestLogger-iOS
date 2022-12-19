//
//  PostBody.swift
//  SpeedTestLogger-iOS
//
//  Created by rei.nakaoka on 2022/12/19.
//

import Foundation

struct PostBody: Encodable {
    let time: String
    let uploadSpeed: String
    let downloadSpeed: String
}
