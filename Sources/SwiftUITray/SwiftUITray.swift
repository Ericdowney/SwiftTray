
import Foundation
import SwiftUI

struct TrayView<Content: View>: View {
    typealias Close = () -> Void
    typealias ContentBuilder = () -> Content
    
    // MARK: - Properties
    
    var body: some View { viewBody() }
    
    var close: () -> Void
    var content: ContentBuilder
    
    // MARK: - Lifecycle
    
    init(close: @escaping Close,
         @ViewBuilder content: @escaping ContentBuilder) {
        self.close = close
        self.content = content
    }
    
    // MARK: - Methods
    
    private func viewBody() -> some View {
        VStack(spacing: 0) {
            Rectangle()
                .foregroundColor(Color(UIColor.systemBackground).opacity(0.01))
                .transition(.opacity)
                .onTapGesture { withAnimation { self.close() } }
            
            content()
        }
    }
}

public struct TrayContainer<Content: View, TrayContent: View>: View {
    public typealias ContentBuilder = () -> Content
    public typealias TrayBuilder = () -> TrayContent
    
    // MARK: - Properties
    
    public var body: some View { viewBody() }
    
    var displayTray: Binding<Bool>
    var transition: AnyTransition = .move(edge: .bottom)
    var blurRadius: CGFloat = 8.0
    var opaque: Bool = false
    
    private var contentBuilder: ContentBuilder
    private var trayBuilder: TrayBuilder
    
    // MARK: - Lifecycle
    
    /// Initializes a TrayContainer to handle the boilerplate code to display a tray overlay view
    /// - Parameters:
    ///   - binding: The binding to display the Tray or not
    ///   - content: The @ViewBuilder for the content of the containing view. This is the view that will be behind the Tray
    ///   - tray: The @ViewBuilder for the content of the Tray. This is the view that is displayed as an overlay inside a Tray
    public init(_ binding: Binding<Bool>,
                @ViewBuilder content: @escaping ContentBuilder, @ViewBuilder tray: @escaping TrayBuilder) {
        self.displayTray = binding
        self.contentBuilder = content
        self.trayBuilder = tray
    }
    
    init(_ blurRadius: CGFloat,
         _ opaque: Bool,
         _ binding: Binding<Bool>,
         transition: AnyTransition,
         @ViewBuilder content: @escaping ContentBuilder, @ViewBuilder tray: @escaping TrayBuilder) {
        self.blurRadius = blurRadius
        self.opaque = opaque
        self.displayTray = binding
        self.transition = transition
        self.contentBuilder = content
        self.trayBuilder = tray
    }
    
    // MARK: - Methods
    
    public func blur(radius: CGFloat, opaque: Bool = false) -> some View {
        Self.init(radius, opaque, displayTray, transition: transition, content: contentBuilder, tray: trayBuilder)
    }
    
    public func transition(_ t: AnyTransition) -> some View {
        Self.init(blurRadius, opaque, displayTray, transition: t, content: contentBuilder, tray: trayBuilder)
    }
    
    private func viewBody() -> some View {
        ZStack {
            contentBuilder()
                .zIndex(0)
                .blur(radius: displayTray.wrappedValue ? blurRadius : 0.0, opaque: opaque)
            
            if displayTray.wrappedValue {
                TrayView(close: { self.displayTray.wrappedValue = false }) { self.trayBuilder() }
                    .transition(transition)
                    .zIndex(1)
            }
        }
    }
}
