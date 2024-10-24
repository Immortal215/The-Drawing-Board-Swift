# 📱 Made using SwiftUI
### An app built to add structure into our lives, keeping focus at the forefront.

> [!WARNING]
> ⚠️ *Built and optimized primarily for iPad Gen 10 but does work on Mac's well enough*

> [!NOTE]
> This is the third github as the first with over 250 commits and second with 200 were corrupted twice.
> Most of the app was made on IPad Swift Playgrounds.

## 🚀 Installation 

> [!IMPORTANT]
> 🛠️ *Use Playgrounds or Xcode to run on your home device, will soon be available on the app store*

  Download the following dependencies through XCode or Playgrounds package installer :

* https://github.com/EmergeTools/Pow.git
* https://github.com/omaralbeik/Drops.git

## ✨ Features 
> [!NOTE]
> 💾 *All Data saves on the device*

### [🏠 Home Screen](The%20Drawing%20Board/Homepage.swift)
<hr>

* **Shows the most urgent assignments in the list chosen!**
* **Shows your current stopwatch and Pomo for easy viewing**
* **An ideas box is given to make sure your mind does not wander while working**
* **A board to draw any ideas that come to mind while working**
> [!NOTE]
> Will send notifications and alarms for timers and when assignments near their due dates!

### [⏲️ Pomo Timer](The%20Drawing%20Board/PomoTimer.swift)
<hr>

* **Stopwatch to measure how long you are working and studying**
* **Pomodoro timer used to effectively study and take 5 (or other) minute breaks every 25 (or other) minutes**

> [!NOTE]
> 🔔 *Will send notifications/alarms to you, alerting you when a pomo or break is completed*

### [📒 Planner](The%20Drawing%20Board/Notebook.swift)
<hr>

* **Add assignment titles, descriptions, subjects, and change the due date if necessary. (Editable afterward as well)**
* **Check assignments individually or delete them all at once**
* **MULTIPLE LISTS! You can create and edit separate planners for organization**

### [⚙️ Settings](The%20Drawing%20Board/Settings.swift)
<hr>

* **Change organization, timing, count, color, dating, data, and more throughout the app**

## 🎥 App Video 
> [!WARNING]
> Really Outdated (Does not have many new features)
https://www.canva.com/design/DAGUIYnazmQ/B6qd-sWMUcbexiiaCnhmcQ/watch?utm_content=DAGUIYnazmQ&utm_campaign=designshare&utm_medium=link&utm_source=editor

## 📄 Basic Example Code For Use
Here's an example snippet of how you might configure a basic timer in SwiftUI:

```swift
struct TimerView: View {
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            progressTime += 1
        }
    }
    
    var minutes: String {
        let time = (progressTime % 3600) / 60
        return time < 10 ? "0\(time)" : "\(time)"
    }
    
    var seconds: String {
        let time = progressTime % 60
        return time < 10 ? "0\(time)" : "\(time)"
    }
    
    @State var progressTime = 0
    @State var myTimer: Timer?

    var body: some View {
        Text("\(minutes):\(seconds)")
            .font(.system(size: 100))
        
        Button("Start") {
            myTimer = timer



        } 
    }
}
```
https://github.com/user-attachments/assets/876f7a0b-70ec-46e9-b4b1-4d8ec1de45b8

Here's an example snippet of how you might configure a simple note-adding effect in SwiftUI:

```swift
struct NoteView: View {
    @State var notes: [String] = []
    @State var newNote: String = ""

    var body: some View {
        VStack {
            TextField("Enter new note", text: $newNote)

            Button("Add Note") {
                if newNote != "" {
                    notes.append(newNote)
                    newNote = ""
                }
            }

            List(notes, id: \.self) { note in
                Text(note)
            }
        }
    }
}
```
https://github.com/user-attachments/assets/17f6f7c2-2154-4ba0-9974-7ba4438fe573

And finally, here's an example snippet of how you might make a timer wheel, unlike on mac's with progressViews, you need to use two circle to make this :

```swift
struct TimerWheel: View {
    @State private var progress: CGFloat = 0.0
    @State private var isRunning: Bool = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.3)
                .foregroundColor(.gray)

            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(.blue)
                .rotationEffect(Angle(degrees: -90))
                .animation(.linear)

            VStack {
                Text("\(Int(progress * 100))%")
                    .font(.largeTitle)
                    .bold()

                Button(action: {
                    isRunning.toggle()
                    if isRunning {
                        startTimer()
                    }
                }) {
                    Text(isRunning ? "Stop" : "Start")
                        .foregroundColor(.white)
                        .padding()
                        .background(isRunning ? Color.red : Color.green)
                        .cornerRadius(10)
                }
            }
        }
        .frame(width: 200, height: 200)
    }

    func startTimer() {
        progress = 0.0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if progress >= 1.0 {
                timer.invalidate()
                isRunning = false
            } else {
                progress += 0.01
            }

        }
    }
}
```

https://github.com/user-attachments/assets/b9ee4cb7-1877-47da-9fc0-9fe12bb13bdd



