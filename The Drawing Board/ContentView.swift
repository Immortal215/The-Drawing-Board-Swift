import SwiftUI

struct ContentView: View {
    @AppStorage("selectedTab") var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Homepage()
                .tabItem {
                    Label("", systemImage: "house.fill")
                }
                .tag(0)
            
            Notebook()
                .tabItem {
                    Label("Planner", systemImage: "text.book.closed.fill")
                }
                .tag(1)
            
            Pomo()
                .tabItem {
                    Label("Timer / Pomo", systemImage: "timer")
                }
                .tag(2)
            
            Settinger()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(3)
        }
        .tabViewStyle(PageTabViewStyle())
    }
}
