//
//  SpeedTestLogger_Widget.swift
//  SpeedTestLogger-Widget
//
//  Created by rei.nakaoka on 2022/12/01.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {

    let manager = SpeedTestManager()

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), download: 0, upload: 0, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), download: 0, upload: 0, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let refresh = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()

        manager.startTest() { download, upload in
            let entry = SimpleEntry(date: Date(), download: download, upload: upload, configuration: configuration)
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .after(refresh))
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let download: Double
    let upload: Double
    let configuration: ConfigurationIntent
}

struct SpeedTestLogger_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Down:" + String(format: "%.1f", entry.download) + "mbps")
            Text("Up:" + String(format: "%.1f", entry.upload) + "mbps")
        }
    }
}

@main
struct SpeedTestLogger_Widget: Widget {
    let kind: String = "SpeedTestLogger_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            SpeedTestLogger_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([
            .accessoryInline,
            .accessoryCircular,
            .accessoryRectangular,
            .systemMedium,
            .systemSmall
        ])
    }
}

struct SpeedTestLogger_Widget_Previews: PreviewProvider {
    static var previews: some View {
        SpeedTestLogger_WidgetEntryView(entry: SimpleEntry(date: Date(), download: 10.0, upload: 20.0, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
