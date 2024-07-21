import SwiftUI

struct Homepage: View {
    
    @State var screenWidth = UIScreen.main.bounds.width
    @State var screenHeight = UIScreen.main.bounds.height
    
    @AppStorage("currentTab") var currentTab = "Basic List"
    
    @State var retrieveBigDic: [String: [String: [String]]] = UserDefaults.standard.dictionary(forKey: "DicKey") as? [String: [String: [String]]] ?? ["Basic List": ["subjects": [String()], "names": [String()], "description": [String()], "date": [String()]]]
    @State var bigDic: [String: [String: [String]]] = ["Basic List": ["subjects": [String()], "names": [String()], "description": [String()], "date": [String()]]]
    
    @State var retrieveDueDic: [String: [Date]] = UserDefaults.standard.dictionary(forKey: "DueDicKey") as? [String: [Date]] ?? ["Basic List": [Date()]]
    @State var dueDic: [String: [Date]] = ["Basic List": [Date()]]
    
    @State var retrieveSubjectsArray: [String] = UserDefaults.standard.array(forKey: "subjects") as? [String] ?? []
    @State var subjects: [String] = []
    
    @State var names: [String] = []
    
    @State var retrieveInfoArray: [String] = UserDefaults.standard.array(forKey: "description") as? [String] ?? []
    @State var infoArray: [String] = []
    
    @State var retrieveDateArray: [String] = UserDefaults.standard.array(forKey: "date") as? [String] ?? []
    @State var dates: [String] = []
    
    @State var retrieveDueArray: [Date] = UserDefaults.standard.array(forKey: "due") as? [Date] ?? []
    @State var dueDates: [Date] = []
    
    @State var daterio: [Date] = [Date()]
    
    @State var description = ""
    @State var name = ""
    @State var subject = ""
    @State var date = ""
    @AppStorage("thoughts") var thoughtText = ""
    @State var lastValue = ""
    
    @State var showAlert = false
    @State var showDelete = false
    @State var loadedData = false
    @State var caughtUp = false
    @State var deleted = false
    @State var error = false
    @State var boxesFilled = false
    @State var settings = false
    @State var selectDelete: [Bool] = []
    @State var assignmentAnimation = false
    @State var notificationer = false
    @State var foregroundStyle = Color.green
    @State var thoughtsOpened = false
    @AppStorage("selectedTab") var selectedTab = 1
    
    
    
    
    // time stuff
    @AppStorage("pomotimer") var pomoTime = 1500
    @AppStorage("breakTime") var breakTime = 300
    @AppStorage("breaks") var breaks = 4
    @AppStorage("pomoOpened") var pomoOpened = false
    @AppStorage("opened") var opened = false
    @AppStorage("breakText") var breakText = false
    
    // draw stuff
    @State var lines: [Line] = []
    @State var currentLine: Line = Line(points: [])
    @AppStorage("chosenWidth") var chosenWidth = 10.0
    @State var drawOpened = false
    
    
    var hours: String {
        let time = (progressTime % 3600) / 3600
        return time < 10 ? "0\(time)" : "\(time)"
    }
    
    var minutes: String {
        
        let time = (progressTime % 3600) / 60
        return time < 10 ? "0\(time)" : "\(time)"
    }
    
    var seconds: String {
        
        let time = progressTime % 60
        return time < 10 ? "0\(time)" : "\(time)"
    }
    
    @AppStorage("progressTime") var progressTime = 0
    
    var minutesPomo: String {
        
        let time = (progressTimePomo % 3600) / 60
        return time < 10 ? "0\(time)" : "\(time)"
    }
    
    var secondsPomo: String {
        
        let time = progressTimePomo % 60
        return time < 10 ? "0\(time)" : "\(time)"
    }
    
    @AppStorage("progressPomo") var progressTimePomo = 0
    
    @AppStorage("subjectcolor") var subjectColor: String = "#91E2FD"
    @AppStorage("titlecolor") var titleColor: String = "#E2FFC2"
    @AppStorage("descolor") var descriptionColor: String = "#FFFFFF"
    @State var currentColor: Color = .pink
    @AppStorage("cornerRadius") var cornerRadius = 300
    
    var body: some View {
        ZStack {
            
            
            VStack {
                Text("Home")
                    .font(.system(size:75))
                    .fontWeight(.bold)
                
                Divider()
                HStack {
                    VStack {
                        Text("Most Urgent!")
                            .font(Font.custom("SF Compact Rounded", fixedSize: (screenWidth/25)))
                            .frame(width: screenWidth/2, height: 100, alignment: .center)
                        
                        Picker("",selection: $currentTab) {
                            ForEach(Array(bigDic.keys), id: \.self) { i in
                                if i.lowercased().hasSuffix(" list") {
                                    Text(i).tag(i)
                                }
                            }
                        }
                        .pickerStyle(.segmented)
                        .fixedSize()
                        
                        Divider()
                            .frame(width: 400)
                        
                        Button {
                            selectedTab = 1
                        } label : {
                            HStack {
                                Text(caughtUp ? "Add Objectives!" : "")
                                    .font(.title)
                                    .fixedSize()
                                
                                Image(systemName: "arrow.up.forward.app")
                                    .resizable()
                                    .frame(width: caughtUp ? 20 : 0, height: caughtUp ? 20 : 0)
                            }
                            
                            
                        }
                        .padding(caughtUp ? 30 : 0)
                        
                        // assignments
                        if loadedData && bigDic[currentTab]?["description"]?.isEmpty != true && caughtUp == false {
                            
                            ScrollView {
                                
                                ForEach(0..<min(infoArray.count, 3), id: \.self) { index in
                                    Spacer()
                                    
                                    ZStack {
                                        
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(.black)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(.gray, lineWidth: 2)
                                                    .frame(width: screenWidth/2.1)
                                                
                                            )
                                            .shadow(radius: 5)
                                            .frame(width: screenWidth/2.1)
                                        
                                        VStack {
                                            HStack {
                                                
                                                Text("")
                                                    .overlay(
                                                        Image(systemName: selectDelete[index] ? "checkmark.circle.fill" : "checkmark")
                                                            .resizable()
                                                            .frame(width: deleted ? 0 : 75, height: deleted ? 0 : 75, alignment: .center)
                                                            .scaleEffect(selectDelete[index] ? 1.0 : 0.5)
                                                            .foregroundStyle(selectDelete[index] ? .red : .blue)
                                                        
                                                    )
                                                    .frame(width:0, height:0)
                                                    .animation(.snappy(extraBounce: 0.4))
                                                
                                                // only works on mac
                                                    .onHover { hovering in
                                                        if hovering {
                                                            selectDelete[index] = true
                                                        } else {
                                                            selectDelete = Array(repeating: false, count: infoArray.count)
                                                            
                                                        }
                                                    }
                                                    .offset(x: -50)
                                                    .onTapGesture {
                                                        selectDelete[index].toggle()
                                                        
                                                        if selectDelete[index] == false {
                                                            selectDelete.remove(at: index)
                                                            infoArray.remove(at: index)
                                                            names.remove(at: index)
                                                            subjects.remove(at: index)
                                                            dates.remove(at: index)
                                                            dueDates.remove(at: index)
                                                            
                                                            bigDic[currentTab]!["names"]! = names
                                                            bigDic[currentTab]!["subjects"]! = subjects
                                                            bigDic[currentTab]!["description"]! = infoArray
                                                            bigDic[currentTab]!["date"]! = dates
                                                            dueDic[currentTab]! = dueDates
                                                            
                                                            UserDefaults.standard.set(bigDic, forKey: "DicKey")
                                                            UserDefaults.standard.set(dueDic, forKey: "DueDicKey")
                                                            
                                                            
                                                            if infoArray.isEmpty {
                                                                selectDelete = []
                                                                caughtUp = true
                                                            }
                                                        }
                                                    }
                                                
                                                
                                                
                                                //  Divider()
                                                
                                                VStack {
                                                    let gradientTitle = LinearGradient(stops: [
                                                        .init(color: Color(hex: subjectColor), location: 0.0),
                                                        .init(color: Color(hex: titleColor), location: 0.5),
                                                        .init(color: Color(hex: descriptionColor), location: 1.0),
                                                        // .init(color: .clear, location: 1.0),
                                                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                                    let gradientSubject = LinearGradient(stops: [
                                                        .init(color: Color(hex: titleColor), location: 0.0),
                                                        .init(color: Color(hex: subjectColor), location: 0.5),
                                                        .init(color: Color(hex: descriptionColor), location: 1.0),
                                                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                                    let gradientDescription = LinearGradient(stops: [
                                                        .init(color: Color(hex: subjectColor), location: 0.0),
                                                        .init(color: Color(hex: descriptionColor), location: 0.5),
                                                        .init(color: Color(hex: titleColor), location: 1.0),
                                                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                                    
                                                    Spacer()
                                                    HStack {
                                                        // Spacer(minLength: 0)
                                                        Text(names[index].trimmingCharacters(in: .whitespacesAndNewlines))
                                                            .foregroundStyle(Color(hex: titleColor))
                                                            .padding()
                                                            .background {
                                                                Capsule()
                                                                    .stroke(gradientTitle, lineWidth: 2)
                                                                    .saturation(1.8)
                                                            }
                                                            .font(.title2)
                                                        //   .frame(maxWidth: screenWidth/4)
                                                        
                                                        if subjects[index] != " " {
                                                            //  Spacer(minLength: 0)
                                                            
                                                            Divider()
                                                            
                                                            Text(subjects[index].trimmingCharacters(in: .whitespacesAndNewlines))
                                                                .foregroundStyle(Color(hex: subjectColor))
                                                                .padding()
                                                                .background {
                                                                    Capsule()
                                                                        .stroke(gradientSubject, lineWidth: 2)
                                                                    // .saturation()
                                                                }
                                                                .font(.title2)
                                                            // .frame(maxWidth: screenWidth/4)
                                                            
                                                            
                                                        }
                                                        
                                                    }
                                                    if infoArray[index] != " " {
                                                        Divider()
                                                            .frame(maxWidth: screenWidth/5)
                                                    }
                                                    VStack {
                                                        if infoArray[index] != " " {
                                                            Text(infoArray[index].trimmingCharacters(in: .whitespacesAndNewlines))
                                                                .foregroundStyle(Color(hex: descriptionColor))
                                                                .font(.title2)
                                                                .padding()
                                                                .background {
                                                                    Capsule()
                                                                        .stroke(gradientDescription, lineWidth: 2)
                                                                        .saturation(1.8)
                                                                }
                                                                .frame(maxWidth: screenWidth/3, maxHeight: 100)
                                                            
                                                            
                                                            
                                                        }
                                                        Divider()
                                                            .frame(maxWidth: screenWidth/3)
                                                        
                                                        
                                                        Text("Due : \(dueDates[index].formatted()) ")
                                                            .fixedSize()
                                                        Spacer()
                                                    }
                                                }
                                            }
                                            
                                        }
                                        .foregroundStyle(foregroundStyler(dueDate: dueDates[index], assignment: names[index]))
                                        // try without
                                        //                                        .onAppear {
                                        //                                            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                                        //                                                if dueDates.count < index {
                                        //                                                    foregroundStyle = foregroundStyler(dueDate: dueDates[index], assignment: names[index] )
                                        //                                                }
                                        //                                            }
                                        //                                           styleNotification(dueDate: dueDates[index], assignment: names[index])
                                        //                                        }
                                        .onChange(of: dueDates[index]) {
                                            
                                            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                                                if dueDates.count < index {
                                                    foregroundStyle = foregroundStyler(dueDate: dueDates[index], assignment: names[index] )
                                                }
                                            }
                                            styleNotification(dueDate: dueDates[index], assignment: names[index])
                                        }
                                        .offset(x: 25)
                                        .frame(width: screenWidth/2)
                                        .padding(10)
                                        
                                    }
                                    .padding(7.5)
                                    
                                }
                                
                                
                            }
                            // .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 1.0))
                            
                        }
                    }
                    
                    VStack {
                        Text("Timers!")
                            .font(Font.custom("SF Compact Rounded", fixedSize: (screenWidth/25)))
                            .frame(width: screenWidth/2, height: 100, alignment: .center)
                        Divider()
                            .frame(width: 400)
                        
                        Button {
                            selectedTab = 2
                        } label : {
                            HStack {
                                Text(progressTimePomo == pomoTime && progressTime == 0 ? "No Timers Set!" : "")
                                    .font(.title)
                                    .fixedSize()
                                
                                Image(systemName: "arrow.up.forward.app")
                                    .resizable()
                                    .frame(width: progressTimePomo == pomoTime && progressTime == 0 ? 20 : 0, height: progressTimePomo == pomoTime && progressTime == 0 ? 20 : 0)
                            }
                            
                            
                        }
                        
                        .animation(.snappy(duration: 0.3, extraBounce: 0.3))
                        
                        VStack {
                            ScrollView {
                                if progressTime != 0 {
                                    HStack {
                                        Text("Stop Watch")
                                        
                                        Divider()
                                        
                                        Text("\(hours):\(minutes):\(seconds)")
                                        
                                    }
                                    .font(.system(size: 25))
                                    .fixedSize()
                                }
                                if progressTimePomo != pomoTime {
                                    HStack {
                                        Text("\(breakText ? "Break" : "Pomodoro") Timer")
                                            .fixedSize()
                                            .padding()
                                        
                                        
                                        ZStack {
                                            
                                            RoundedRectangle(cornerRadius: CGFloat(cornerRadius/6))
                                                .stroke(lineWidth: 10)
                                                .opacity(0.3)
                                                .foregroundColor(.gray)
                                                .animation(.linear(duration: 1))
                                                .frame(width:100, height:100)
                                            
                                            RoundedRectangle(cornerRadius: CGFloat(cornerRadius/6))
                                                .trim(from: 0.0, to: CGFloat(breakText ? Double(progressTimePomo)/Double(breakTime) : Double(progressTimePomo)/Double(pomoTime)))
                                                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                                                .rotationEffect(Angle(degrees: -90.0))
                                                .animation(.linear(duration: 1))
                                                .foregroundStyle(currentColor)
                                                .opacity(0.3)
                                                .onChange(of: breakText) {
                                                    currentColor = $0 ? .green : .pink
                                                }
                                                .frame(width:100, height:100)
                                            
                                            Text("\(minutesPomo):\(secondsPomo)")
                                                .frame(width:100, height:50)
                                                .padding()
                                            
                                            
                                        }
                                        .padding()
                                        
                                    }
                                    .font(.system(size:25))
                                }
                                
                                // thought text
                                VStack {
                                    HStack {
                                        
                                        Button {
                                            let originalThoughtText = thoughtText
                                            thoughtText = thoughtText.trimmingCharacters(in: .whitespacesAndNewlines)
                                            
                                            if thoughtText == originalThoughtText {
                                                thoughtText = ""
                                                thoughtsOpened = false
                                            }
                                        } label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                    .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                                                    .frame(width: 30, height: 38)
                                                    .background(.clear, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                                                
                                                
                                                Image(systemName: "archivebox")
                                                    .foregroundColor(.white)
                                                    .shadow(color: .gray, radius: 5, x: 0, y: 0)
                                            }
                                        }
                                        .padding()
                                        .scaleEffect( thoughtsOpened ? 1.0 : 0 )
                                        .frame(maxWidth: thoughtsOpened ? .infinity : 0)
                                        .fixedSize()
                                        
                                        ZStack {
                                            if thoughtText.isEmpty {
                                                Text("Add Thoughts While Working!")
                                                    .foregroundColor(.gray)
                                                    .font(.title3)
                                            }
                                            
                                            TextEditor(text: $thoughtText)
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                                                    
                                                }
                                                .multilineTextAlignment(.center)
                                                .foregroundStyle(.white)
                                                .frame(maxWidth: screenWidth/3, maxHeight: screenHeight/7)
                                                .scrollContentBackground(.hidden)
                                                .font(.title3)
                                                .padding()
                                                .onChange(of: thoughtText) {
                                                    if thoughtText != "" {
                                                        thoughtsOpened = true
                                                    } else {
                                                        thoughtsOpened = false
                                                    }
                                                    
                                                    if thoughtText.last == "\n" && lastValue != "-" {
                                                        thoughtText += "- "
                                                    }
                                                    
                                                    // needed to prevent a nil which crash
                                                    if let lastChar = thoughtText.last {
                                                        lastValue = String(lastChar)
                                                    } else {
                                                        lastValue = ""
                                                    }
                                                }
                                                .onTapGesture {
                                                    if thoughtText == "" {
                                                        thoughtText = "- "
                                                    }
                                                }
                                        }
                                    }
                                }
                                
                                // draw
                                VStack {
                                    HStack {
                                        Button {
                                            lines = []
                                            drawOpened = false
                                        } label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                    .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                                                    .frame(width: 30, height: 38)
                                                    .background(.clear, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                                                
                                                
                                                Image(systemName: "archivebox")
                                                    .foregroundColor(.white)
                                                    .shadow(color: .gray, radius: 5, x: 0, y: 0)
                                            }
                                        }
                                        .padding()
                                        .scaleEffect( drawOpened ? 1.0 : 0 )
                                        .frame(maxWidth: drawOpened ? .infinity : 0)
                                        .fixedSize()
                                        
                                        ZStack {
                                            
                                            if lines.isEmpty {
                                                Text("Draw Ideas While Working!")
                                                    .foregroundColor(.gray)
                                                    .font(.title3)
                                            }
                                            
                                            Canvas { context, size in
                                                for line in lines {
                                                    var path = Path()
                                                    path.addLines(line.points)
                                                    context.stroke(path, with: .color(line.color), lineWidth: chosenWidth)
                                                }
                                                
                                                // Draw the current line
                                                var currentPath = Path()
                                                currentPath.addLines(currentLine.points)
                                                context.stroke(currentPath, with: .color(currentLine.color), lineWidth: chosenWidth)
                                            }
                                            
                                            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                                .onChanged { value in
                                                    let newPoint = value.location
                                                    currentLine.points.append(newPoint)
                                                    drawOpened = true
                                                }
                                                .onEnded { value in
                                                    lines.append(currentLine)
                                                    currentLine = Line(points: [])
                                                }
                                            )
                                            .padding()
                                            .frame(width: screenWidth/3, height: screenHeight/3)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                    .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                    VStack {
                                        Text("Line Width: \(chosenWidth, specifier: "%.1f")")
                                            .font(.headline)
                                        
                                        HStack {
                                            Text("0")
                                            Slider(value: $chosenWidth, in: 5...25, step: 5)
                                            Text("25")
                                        }
                                        .frame(width: screenWidth/3)
                                    }
                                    .padding()
                                }
                            }
                            
                        }
                        
                        
                    }
                }
                
                
            }
            .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.3))
            
        }
        .onAppear {
            if thoughtText != "" {
                thoughtsOpened = true
            }
            
            if currentTab == "+erder" {
                currentTab = "Basic List"
            }
            
            retrieveBigDic = UserDefaults.standard.dictionary(forKey: "DicKey") as? [String: [String: [String]]] ?? [:]
            retrieveDueDic = UserDefaults.standard.dictionary(forKey: "DueDicKey") as? [String : [Date]] ?? [:]
            
            bigDic = (retrieveBigDic[currentTab]?["subjects"] != nil ? retrieveBigDic : bigDic )
            dueDic = (retrieveDueDic[currentTab] != nil ? retrieveDueDic : dueDic)
            
            
            names = bigDic[currentTab]!["names"]!
            subjects = bigDic[currentTab]!["subjects"]!
            infoArray = bigDic[currentTab]!["description"]!
            dates = bigDic[currentTab]!["date"]!
            dueDates = dueDic[currentTab]!
            
            selectDelete = []
            selectDelete = Array(repeating: false, count: infoArray.count)
            DateFormatter().dateFormat = "M/d/yyyy, h:mm a"
            
            
            if bigDic[currentTab]?["description"] != [] && bigDic[currentTab]?["description"] != [String()] {
                caughtUp = false
                
                var sortedIndices = dueDates.indices.sorted(by: { dueDates[$0] < dueDates[$1] })
                
                // rearrange all arrays based on sorted indices
                subjects = sortedIndices.map { bigDic[currentTab]!["subjects"]![$0] }
                names = sortedIndices.map { bigDic[currentTab]!["names"]![$0] }
                infoArray = sortedIndices.map { bigDic[currentTab]!["description"]![$0] }
                dates = sortedIndices.map { bigDic[currentTab]!["date"]![$0] }
                dueDates = sortedIndices.map { dueDic[currentTab]![$0] }
                selectDelete = sortedIndices.map { selectDelete[$0]}
                
                
            } else {
                caughtUp = true
                
            }
            
            error = false
            loadedData = true
            
            
            if pomoOpened == false {
                progressTimePomo = pomoTime
                pomoOpened = true
            }
            
            progressTimePomo = progressTimePomo
            
            if opened == false {
                progressTime = 0
                opened = true
            }
            progressTime = progressTime
            
            
            currentColor = breakText ? .green : .pink
            
        }
        
        .onChange(of: currentTab) {
            if currentTab != "+erder" {
                retrieveBigDic = UserDefaults.standard.dictionary(forKey: "DicKey") as? [String: [String: [String]]] ?? [:]
                retrieveDueDic = UserDefaults.standard.dictionary(forKey: "DueDicKey") as? [String : [Date]] ?? [:]
                
                bigDic = (retrieveBigDic[currentTab]?["subjects"] != nil ? retrieveBigDic : bigDic )
                dueDic = (retrieveDueDic[currentTab] != nil ? retrieveDueDic : dueDic)
                
                
                names = bigDic[currentTab]!["names"]!
                subjects = bigDic[currentTab]!["subjects"]!
                infoArray = bigDic[currentTab]!["description"]!
                dates = bigDic[currentTab]!["date"]!
                dueDates = dueDic[currentTab]!
                
                
                selectDelete = Array(repeating: false, count: infoArray.count)
                DateFormatter().dateFormat = "M/d/yyyy, h:mm a"
                
                
                if bigDic[currentTab]?["description"] != [] && bigDic[currentTab]?["description"] != [String()] {
                    caughtUp = false
                    
                    var sortedIndices = dueDates.indices.sorted(by: { dueDates[$0] < dueDates[$1] })
                    
                    subjects = sortedIndices.map { bigDic[currentTab]!["subjects"]![$0] }
                    names = sortedIndices.map { bigDic[currentTab]!["names"]![$0] }
                    infoArray = sortedIndices.map { bigDic[currentTab]!["description"]![$0] }
                    dates = sortedIndices.map { bigDic[currentTab]!["date"]![$0] }
                    dueDates = sortedIndices.map { dueDic[currentTab]![$0] }
                    selectDelete = sortedIndices.map { selectDelete[$0]}
                    
                } else {
                    caughtUp = true
                    
                }
            }
        }
        .onChange(of: breakText) {
            scheduleTimeBasedNotification(title: "\(breakText ? "Break" : "Pomo") Time!", body: "\(breakText ? "Pomo" : "Break") Completed!", sound: UNNotificationSound(named: UNNotificationSoundName(rawValue: "myalarm.mp3")))
        }
        
    }
}

extension UserDefaults {
    static func resetDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}

func resetDefaults() {
    let defaults = UserDefaults.standard
    let dictionary = defaults.dictionaryRepresentation()
    dictionary.keys.forEach { key in
        defaults.removeObject(forKey: key)
    }
}

func foregroundStyler(dueDate: Date, assignment: String) -> Color {
    
    if dueDate < Date().addingTimeInterval(86400) {
        if dueDate < Date().addingTimeInterval(3600) {
            return Color.red
        } else {
            return Color.orange
        }
    } else {
        return Color.green
        
    }
}

func styleNotification(dueDate: Date, assignment: String) {
    var number = 0
    
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
        if dueDate < Date().addingTimeInterval(86400) {
            if dueDate < Date().addingTimeInterval(3600) && number == 1 {
                
                scheduleTimeBasedNotification(title: "\(assignment) is due in less than one hour!", body: "", sound: UNNotificationSound(named: UNNotificationSoundName(rawValue: "myalarm.mp3")))
                number += 1
                if dueDate == Date() && number == 2{
                    scheduleTimeBasedNotification(title: "\(assignment) is due now!", body: "", sound: UNNotificationSound(named: UNNotificationSoundName(rawValue: "myalarm.mp3")))
                    number += 1
                }
                
            } else if number == 0 {
                scheduleTimeBasedNotification(title: "\(assignment) is due in less than one day!", body: "", sound: UNNotificationSound.defaultCritical)
                number += 1
            }
        }
    }
}

struct Line {
    var points: [CGPoint]
    var color: Color = .white
}
