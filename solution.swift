import SwiftUI
import WidgetKit

struct DueEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let tasks: [String] // Your data model for tasks
}

struct DueWidgetEntryView : View {
    var entry: DueEntry

    var body: some View {
        VStack {
            Text("Due Tasks")
                .font(.headline)
            ForEach(entry.tasks, id: \.self) { task in
                Text(task)
                    .font(.subheadline)
            }
        }
        .padding()
    }
}

struct DueWidget: Widget {
    let kind: String = "DueWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, provider: DueTimelineProvider()) { entry in
            DueWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Due App Tasks")
        .description("Keep track of your tasks.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct DueTimelineProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> DueEntry {
        DueEntry(date: Date(), configuration: ConfigurationIntent(), tasks: ["Sample Task 1", "Sample Task 2"])
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (DueEntry) -> ()) {
        let entry = DueEntry(date: Date(), configuration: configuration, tasks: ["Task 1", "Task 2"])
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<DueEntry>) -> ()) {
        var entries: [DueEntry] = []

        // Fetch your tasks from the Due app (replace with your data fetching logic)
        let tasks = fetchDueTasks()

        // Create an entry for the current date
        let currentDate = Date()
        let entry = DueEntry(date: currentDate, configuration: configuration, tasks: tasks)
        entries.append(entry)

        // Update the timeline (for example, every 15 minutes)
        let timeline = Timeline(entries: entries, policy: .after(currentDate.addingTimeInterval(15 * 60)))
        completion(timeline)
    }
}

func fetchDueTasks() -> [String] {
    // Replace this with your logic to fetch tasks from the Due app
    return ["Task 1", "Task 2", "Task 3"]
}
