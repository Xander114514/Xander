import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: CheckInStore
    @State private var showingLapseConfirmation = false
    @State private var showingDatePicker = false

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年M月d日"
        return formatter
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    streakCard
                    todayCheckIn
                    dateCard
                    lapseAction
                    historySection
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 36)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("每日打卡")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingDatePicker = true
                    } label: {
                        Image(systemName: "calendar.badge.plus")
                    }
                    .accessibilityLabel("修改起始日期")
                }
            }
            .confirmationDialog("确认今天破戒？", isPresented: $showingLapseConfirmation, titleVisibility: .visible) {
                Button("记录破戒", role: .destructive) {
                    store.recordLapse()
                }
                Button("取消", role: .cancel) {}
            } message: {
                Text("会保留这次日期，并从今天重新开始计算连续天数。")
            }
            .sheet(isPresented: $showingDatePicker) {
                DateEditor(startDate: store.startDate) { date in
                    store.resetStartDate(to: date)
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("今天也算数")
                .font(.system(size: 32, weight: .bold, design: .rounded))
            Text("给自己一个小小的记录，持续就会有改变。")
                .foregroundStyle(.secondary)
        }
    }

    private var streakCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 34))
                .foregroundStyle(.white.opacity(0.92))
            Text("已坚持")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white.opacity(0.82))
            Text("\(store.elapsedDays)")
                .font(.system(size: 74, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text(store.elapsedDays == 1 ? "天" : "天")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 26)
        .background(
            LinearGradient(colors: [Color(red: 0.10, green: 0.42, blue: 0.34), Color(red: 0.16, green: 0.60, blue: 0.42)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.green.opacity(0.18), radius: 14, y: 7)
    }

    private var dateCard: some View {
        HStack(spacing: 14) {
            LabelIcon(systemName: "flag.fill", color: .orange)
            VStack(alignment: .leading, spacing: 3) {
                Text("本轮起始日期")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(dateFormatter.string(from: store.startDate))
                    .font(.headline)
            }
            Spacer()
            Text("第 \(store.elapsedDays + 1) 天")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.green)
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var todayCheckIn: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                store.toggleTodayCheckIn()
            }
        } label: {
            HStack(spacing: 14) {
                LabelIcon(systemName: store.isCheckedInToday ? "checkmark.circle.fill" : "circle", color: store.isCheckedInToday ? .green : .blue)
                VStack(alignment: .leading, spacing: 3) {
                    Text(store.isCheckedInToday ? "今日已打卡" : "完成今日打卡")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(store.isCheckedInToday ? "做得很好，明天继续" : "点一下记录今天的进度")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: store.isCheckedInToday ? "checkmark" : "chevron.right")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(store.isCheckedInToday ? .green : .secondary)
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(store.isCheckedInToday ? "今日已打卡" : "完成今日打卡")
    }

    private var lapseAction: some View {
        Button {
            showingLapseConfirmation = true
        } label: {
            Label("今天破戒了", systemImage: "arrow.counterclockwise")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
        }
        .buttonStyle(.borderedProminent)
        .tint(.red)
        .accessibilityHint("记录今天的破戒并重新开始计时")
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("破戒记录")
                    .font(.title3.bold())
                Spacer()
                Text("共 \(store.lapses.count) 次")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if store.lapses.isEmpty {
                Text("还没有记录，继续保持。")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 18)
            } else {
                ForEach(store.lapses) { lapse in
                    HStack(spacing: 12) {
                        LabelIcon(systemName: "calendar", color: .red)
                        Text(dateFormatter.string(from: lapse.date))
                            .font(.body)
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

private struct LabelIcon: View {
    let systemName: String
    let color: Color

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(color)
            .frame(width: 34, height: 34)
            .background(color.opacity(0.12))
            .clipShape(Circle())
    }
}

private struct DateEditor: View {
    @Environment(\.dismiss) private var dismiss
    @State private var date: Date
    let onSave: (Date) -> Void

    init(startDate: Date, onSave: @escaping (Date) -> Void) {
        _date = State(initialValue: startDate)
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("起始日期", selection: $date, in: ...Date(), displayedComponents: .date)
            }
            .navigationTitle("调整日期")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        onSave(date)
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    ContentView()
        .environmentObject(CheckInStore())
}
