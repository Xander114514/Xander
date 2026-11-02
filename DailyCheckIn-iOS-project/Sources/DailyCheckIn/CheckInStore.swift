import Foundation
import Combine

struct Lapse: Codable, Identifiable, Equatable {
    let id: UUID
    let date: Date

    init(id: UUID = UUID(), date: Date) {
        self.id = id
        self.date = date
    }
}

final class CheckInStore: ObservableObject {
    @Published private(set) var startDate: Date
    @Published private(set) var lapses: [Lapse]
    @Published private(set) var checkInDates: [Date]

    private let defaults = UserDefaults.standard
    private let startDateKey = "checkin.startDate"
    private let lapsesKey = "checkin.lapses"
    private let checkInDatesKey = "checkin.checkInDates"
    private let calendar = Calendar.current

    init() {
        let savedStart = defaults.object(forKey: startDateKey) as? Date
        startDate = savedStart.map { calendar.startOfDay(for: $0) } ?? calendar.startOfDay(for: Date())

        if let data = defaults.data(forKey: lapsesKey),
           let savedLapses = try? JSONDecoder().decode([Lapse].self, from: data) {
            lapses = savedLapses.sorted { $0.date > $1.date }
        } else {
            lapses = []
        }
        if let savedDates = defaults.array(forKey: checkInDatesKey) as? [Date] {
            checkInDates = savedDates.map { calendar.startOfDay(for: $0) }
        } else {
            checkInDates = []
        }
        persist()
    }

    var elapsedDays: Int {
        max(0, calendar.dateComponents([.day], from: startDate, to: calendar.startOfDay(for: Date())).day ?? 0)
    }

    var isCheckedInToday: Bool {
        checkInDates.contains(calendar.startOfDay(for: Date()))
    }

    func toggleTodayCheckIn() {
        let today = calendar.startOfDay(for: Date())
        if let index = checkInDates.firstIndex(of: today) {
            checkInDates.remove(at: index)
        } else {
            checkInDates.append(today)
            checkInDates.sort(by: >)
        }
        persist()
    }

    func recordLapse(on date: Date = Date()) {
        let day = calendar.startOfDay(for: date)
        lapses.insert(Lapse(date: day), at: 0)
        startDate = day
        persist()
    }

    func resetStartDate(to date: Date) {
        startDate = calendar.startOfDay(for: date)
        persist()
    }

    private func persist() {
        defaults.set(startDate, forKey: startDateKey)
        if let data = try? JSONEncoder().encode(lapses) {
            defaults.set(data, forKey: lapsesKey)
        }
        defaults.set(checkInDates, forKey: checkInDatesKey)
    }
}
