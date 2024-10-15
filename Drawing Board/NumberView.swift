import SwiftUI

struct NumberView: View {
    @AppStorage("completed") var completed = 0
    @State var scale: CGFloat = 1.2
    @State var backgroundColor = Color.white
    
    var body: some View {
        ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)
            
            VStack() {
                Text("\(completed)")
                    .font(.headline)
                    .foregroundColor(.black)
                    .scaleEffect(scale)
                    .animation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5), value: scale)
                    .onChange(of: completed) { newValue in
                        // trigger scale effect on number change
                        withAnimation {
                            scale = 1.8
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                scale = 1.2
                            }
                        }
                        // change background color on count update
                        withAnimation(.easeInOut(duration: 0.4)) {
                            backgroundColor = Color(hue: Double(newValue % 360) / 360.0, saturation: 0.5, brightness: 0.9)
                        }
                    }
                
                
            }
        }
    }
}
