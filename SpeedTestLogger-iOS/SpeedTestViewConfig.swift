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
                try await self.post(
                    time: self.formattedDate(date: self.latestDate),
                    uploadSpeed: String(uploadMbps),
                    downloadSpeed: String(downloadMbps)
                )
            }
        }
    }

    private func post(time: String, uploadSpeed: String, downloadSpeed: String) async throws {
        let url = URL(string: "add api url")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(
            PostBody(
                time: time,
                uploadSpeed: uploadSpeed,
                downloadSpeed: downloadSpeed
            )
        )

        let _ = try await URLSession.shared.data(for: request)
    }

    private func formattedDate(date: Date) -> String {
        let fomatter = DateFormatter()
        fomatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return fomatter.string(from: date)
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
