//
//  SpeedTestViewConfig.swift
//  SpeedTestLogger-iOS
//
//  Created by NakaokaRei on 2022/12/08.
//

import Foundation


@MainActor
class SpeedTestViewConfig: ObservableObject {

    @Published var downloadMbps: Double = 0
    @Published var uploadMbps: Double = 0
    @Published var latestDate: Date = Date()

    let speedTestManager = SpeedTestManager()
    var timer: Timer?

    init() {
        self.timer = Timer.scheduledTimer(
            timeInterval: 60 * 5,
            target: self,
            selector: #selector(self.startTest),
            userInfo: nil,
            repeats: true
        )
        speedTestManager.delegate = self
    }

    @objc func startTest() {
        downloadMbps = 0
        uploadMbps = 0
        speedTestManager.startTest { downloadMbps, uploadMbps in
            Task.detached { @MainActor in
                self.latestDate = Date()
                self.downloadMbps = downloadMbps
                self.uploadMbps = uploadMbps
            }
        }
    }
}

extension SpeedTestViewConfig: SpeedTestDelegate {
    func progressDonwload(downloadMbps: Double) {
        self.downloadMbps = downloadMbps
    }

    func progressUpload(uploadMbps: Double) {
        self.uploadMbps = uploadMbps
    }
}
