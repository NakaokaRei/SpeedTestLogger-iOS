//
//  SpeedTestView.swift
//  SpeedTestLogger-iOS
//
//  Created by NakaokaRei on 2022/12/08.
//

import SwiftUI

struct SpeedTestView: View {

    @StateObject private var config = SpeedTestViewConfig()

    var body: some View {
        VStack(spacing: 10) {
            Text("最新計測時: " + config.latestDate.formatted())
            Text("Download: " + String(format: "%.1f", config.downloadMbps) + "Mbps")
            Text("Upload: " + String(format: "%.1f", config.uploadMbps) + "Mbps")
            Button {
                config.startTest()
            } label: {
                Text("Start")
            }
            .disabled(config.isRegularly)
            Toggle(isOn: $config.isRegularly) {
                HStack {
                    Text("定期的に計測する")
                    Text(config.isRegularly ? "ON" : "OFF")
                }
            }
            .toggleStyle(.button)
        }
    }
}

struct SpeedTestView_Previews: PreviewProvider {
    static var previews: some View {
        SpeedTestView()
    }
}
