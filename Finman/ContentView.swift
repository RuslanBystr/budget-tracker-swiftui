import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted = false
}

struct ContentView: View {
    @State private var tasks = [
        Task(title: "Learn SwiftUI"),
        Task(title: "Build an MVP"),
        Task(title: "Go to the gym")
    ]

    @State private var isShowingAddTask = false
    @State private var newTask = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach($tasks) { $task in
                    HStack {
                        Button {
                            $task.isCompleted.wrappedValue.toggle()
                        } label: {
                            Image(systemName: task.isCompleted
                                  ? "checkmark.circle.fill"
                                  : "circle")
                        }
                        .buttonStyle(.plain)

                        Text(task.title)
                            .strikethrough(task.isCompleted)
                            .foregroundStyle(
                                task.isCompleted ? .secondary : .primary
                            )
                    }
                }
                .onDelete { indexSet in
                    tasks.remove(atOffsets: indexSet)
                }
            }
            .navigationTitle("My Tasks")
            .toolbar {
                Button {
                    isShowingAddTask = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $isShowingAddTask) {
                AddTaskView(
                    task: $newTask,
                    onAdd: addTask
                )
            }
        }
        .sheet(isPresented: $showWelcome) {
            WelcomeView()
        }
    }

    private func addTask() {
        let title = newTask.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !title.isEmpty else {
            return
        }

        tasks.append(Task(title: title))
        newTask = ""
        isShowingAddTask = false
    }
}

struct AddTaskView: View {
    @Binding var task: String

    let onAdd: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                TextField("Task name", text: $task)
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onAdd()
                    }
                }
            }
        }
    }
}

struct WelcomeView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 70))
                .foregroundStyle(.blue)

            Text("Welcome!")
                .font(.largeTitle)
                .bold()

            Text("Manage your tasks and stay productive.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Button("Get Started") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(32)
    }
}

#Preview {
    ContentView()
}
