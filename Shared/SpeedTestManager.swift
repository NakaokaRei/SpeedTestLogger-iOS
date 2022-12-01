//
//  SpeedTestManager.swift
//  SpeedTestLogger-iOS
//
//  Created by rei.nakaoka on 2022/12/01.
//

import SpeedcheckerSDK
import CoreLocation

class SpeedTestManager: NSObject, CLLocationManagerDelegate {

    private var internetTest: InternetSpeedTest?
    private var locationManager = CLLocationManager()

    private var completion: ((_ download: Double, _ upload: Double) -> Void)?

    override init() {
        super.init()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingHeading()
        }
    }

    func startTest(completion: @escaping (_ download: Double, _ upload: Double) -> Void) {
        internetTest = InternetSpeedTest(delegate: self)
        internetTest?.startTest() { error in
            if error != .ok {
                print(error)
            }
        }
        self.completion = completion
    }
}

extension SpeedTestManager: InternetSpeedTestDelegate {
    func internetTestError(error: SpeedTestError) {
        print(error)
    }

    func internetTestFinish(result: SpeedTestResult) {
        print(result.downloadSpeed.mbps)
        print(result.uploadSpeed.mbps)
        print(result.latencyInMs)
        if let completion {
            completion(result.downloadSpeed.mbps, result.uploadSpeed.mbps)
        }
    }

    func internetTestReceived(servers: [SpeedTestServer]) {
        //
    }

    func internetTestSelected(server: SpeedTestServer, latency: Int, jitter: Int) {
        print("Latency: \(latency)")
        print("Jitter: \(jitter)")
    }

    func internetTestDownloadStart() {
        //
    }

    func internetTestDownloadFinish() {
        //
    }

    func internetTestDownload(progress: Double, speed: SpeedTestSpeed) {
        print("Download: \(speed.descriptionInMbps)")
    }

    func internetTestUploadStart() {
        //
    }

    func internetTestUploadFinish() {
        //
    }

    func internetTestUpload(progress: Double, speed: SpeedTestSpeed) {
        print("Upload: \(speed.descriptionInMbps)")
    }
}
