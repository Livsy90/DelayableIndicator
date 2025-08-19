import SwiftUI

public struct DelayableIndicator<Content: View>: View {
    
    private let isIndicating: Bool
    private let delay: TimeInterval
    private let transition: AnyTransition
    private let content: Content
    
    @State private var isPresented = false
    @State private var pendingTask: Task<Void, Never>?
    
    public init(
        _ isIndicating: Bool,
        delay: TimeInterval = 0.5,
        transition: AnyTransition = .scale.combined(with: .opacity),
        @ViewBuilder content: () -> Content
    ) {
        self.isIndicating = isIndicating
        self.delay = delay
        self.transition = transition
        self.content = content()
    }
    
    public var body: some View {
        Group {
            if isPresented {
                content.transition(transition)
            }
        }
        .onChange(of: isIndicating) { newValue in
            pendingTask?.cancel()
            
            if newValue {
                pendingTask = Task {
                    if #available(iOS 16.0, *) {
                        try? await Task.sleep(for: .seconds(delay))
                    } else {
                        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    }
                    guard !Task.isCancelled else { return }
                    withAnimation {
                        isPresented = true
                    }
                }
            } else {
                pendingTask = nil
                withAnimation {
                    isPresented = false
                }
            }
        }
    }
    
}
