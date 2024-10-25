import SwiftUI
import MessageUI

struct FeatureReportButton: View {
    @State private var isShowingMailView = false
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    // Configuration
    let recipientEmail = "sharulshah@icloud.com"
    let subject = "Feature Report"
    
    var body: some View {
        Button(action: {
            if MFMailComposeViewController.canSendMail() {
                isShowingMailView = true
            } else {
                alertMessage = "Email is not configured on this device"
                showAlert = true
            }
        }) {
            HStack {
                Image(systemName: "envelope.fill")
                    .font(.system(size: 20))
                Text("Submit Feature Report")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(
                isShowing: $isShowingMailView,
                result: { result in
                    switch result {
                    case .success:
                        alertMessage = "Thank you for your feature report!"
                    case .failure:
                        alertMessage = "Failed to send email"
                    }
                    showAlert = true
                },
                content: MailContent(
                    subject: subject,
                    recipients: [recipientEmail],
                    message: createEmailTemplate()
                )
            )
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Feature Report"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func createEmailTemplate() -> String {
        """
        Device Information:
        • Model: \(UIDevice.current.model)
        • iOS Version: \(UIDevice.current.systemVersion)
        • Device Name: \(UIDevice.current.name)
        
        Feature Request Details:
        Please describe the feature you'd like to suggest:
        
        Why is this feature important to you?
        
        How would you envision this feature working?
        
        Additional comments:
        
        """
    }
}

// Mail View Representative
struct MailView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    let result: (Result<MFMailComposeResult, Error>) -> Void
    let content: MailContent
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = context.coordinator
        mailComposer.setSubject(content.subject)
        mailComposer.setToRecipients(content.recipients)
        mailComposer.setMessageBody(content.message, isHTML: false)
        return mailComposer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if let error = error {
                parent.result(.failure(error))
            } else {
                parent.result(.success(result))
            }
            parent.isShowing = false
        }
    }
}

struct MailContent {
    let subject: String
    let recipients: [String]
    let message: String
}

struct GitHubButton: View {
    @Environment(\.openURL) var openURL
    @State private var isPressed = false
    
    let githubURL = URL(string: "https://github.com/Immortal215")!
    
    var body: some View {
        Button(action: {
            openURL(githubURL)
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                HStack {
                    Text("Github")
                        .foregroundStyle(.white)
                        .bold()
                    Image(systemName: "link.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(hex: "24292E"),
                                            Color(hex: "1B1F23")
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
                }
                .padding(.horizontal)
                .padding(.vertical, 3)
            }
            .fixedSize()
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isPressed = true
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
        .buttonStyle(PlainButtonStyle())
    }
}


