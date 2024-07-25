//
//  StatuBarViewModel.swift
//  AdhanTime
//
//  Created by Raif Agovic on 22. 7. 2024..
//

import SwiftUI
import Combine

class StatusBarViewModel: ObservableObject {
    @Published var statusBarTitle: String = "AdhanTime"
    @Published var remainingTime: TimeInterval?
    @Published var nextPrayerName: String?
    private var timer: Timer?
    private var locationId: Int = 77

    init() {
        fetchPrayerTimes()
    }
        
    func updateStatusBar() {
        guard let nextPrayerTimeInterval = remainingTime, let nextPrayerName = nextPrayerName else {
            statusBarTitle = "Fetch the data!"
            return
        }
        
        statusBarTitle = TimeUtils.formatTimeInterval(nextPrayerTimeInterval, prayerName: nextPrayerName)
        startTimer(for: nextPrayerTimeInterval)
    }

    func startTimer(for interval: TimeInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            guard let currentRemainingTime = self.remainingTime else {
                return
            }

            if currentRemainingTime > 0 {
                self.remainingTime = currentRemainingTime - 1
                self.statusBarTitle = TimeUtils.formatTimeInterval(currentRemainingTime - 1, prayerName: self.nextPrayerName ?? "")
            } else {
                self.timer?.invalidate()
                self.fetchPrayerTimes()
            }
        }
    }
}
