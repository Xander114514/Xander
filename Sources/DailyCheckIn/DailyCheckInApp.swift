import SwiftUI

@main
struct DailyCheckInApp: App {
    @StateObject private var store = CheckInStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .preferredColorScheme(.light)
        }
    }
}
