import SwiftUI

@available(iOS 15.0, *)
extension View {
    func delayablePresentation(
        isPresented: Bool,
        delay: TimeInterval = 4,
        transition: AnyTransition = .opacity,
        skipFirstPresentation: Bool = true
    ) -> some View {
        modifier(
            DelayableContent(
                isPresented: isPresented,
                delay: delay,
                transition: transition,
                skipFirstPresentation: skipFirstPresentation
            )
        )
    }
}

@available(iOS 15.0, *)
private struct DelayableContent: ViewModifier {
    let isPresented: Bool
    let delay: TimeInterval
    let transition: AnyTransition
    @State var skipFirstPresentation: Bool
    @State private var isPresentedInternal = false
    
    func body(content: Content) -> some View {
        ZStack {
            if isPresentedInternal {
                content.transition(transition)
            }
        }
        .task(id: isPresented) {
            guard !skipFirstPresentation else {
                skipFirstPresentation.toggle()
                withAnimation { isPresentedInternal = true }
                return
            }
            
            if isPresented {
                if #available(iOS 16.0, *) {
                    try? await Task.sleep(for: .seconds(delay))
                } else {
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                }
                guard !Task.isCancelled else { return }
                withAnimation {
                    isPresentedInternal = true
                }
            } else {
                withAnimation {
                    isPresentedInternal = false
                }
            }
        }
    }
}
