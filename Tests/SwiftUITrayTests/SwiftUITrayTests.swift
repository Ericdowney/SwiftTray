import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftUITray

final class SwiftUITrayTests: XCTestCase {
    
    // MARK: - Tests
    
    func test_trayContainer_whenTrayIsNotDispalyed_shouldInitializeWithCorrectProperties() throws {
        var displayTray = false
        let binding = Binding(get: { displayTray }, set: { displayTray = $0 })
        let subject = TrayContainer(binding, content: { Text("Content") }, tray: { Text("Tray") })
        
        let result = try subject.inspect()
        
        let content = try result.zStack().text(0)
        let contentBlur = try content.blur()
        XCTAssertEqual(try content.zIndex(), 0)
        XCTAssertEqual(contentBlur.radius, 0.0)
        
        XCTAssertThrowsError(try result.zStack().text(1))
    }
    
    func test_trayContainer_whenTrayIsDisplayed_shouldInitializeWithCorrectProperties() throws {
        var displayTray = true
        let binding = Binding(get: { displayTray }, set: { displayTray = $0 })
        let subject = TrayContainer(binding, content: { Text("Content") }, tray: { Text("Tray") })
        
        let result = try subject.inspect()
        
        let content0 = try result.zStack().text(0)
        let content0Blur = try content0.blur()
        XCTAssertEqual(try content0.zIndex(), 0)
        XCTAssertEqual(content0Blur.radius, 8.0)
        
        let content1 = try result.zStack().view(TrayView<Text>.self, 1)
        let content1ZIndex = try content1.zIndex()
        XCTAssertEqual(content1ZIndex, 1)
    }
    
    func test_trayContainer_blur_shouldSetBlurRadius() {
        var displayTray = true
        let binding = Binding(get: { displayTray }, set: { displayTray = $0 })
        let subject = TrayContainer(binding, content: { Text("Content") }, tray: { Text("Tray") })
        
        let result = subject.blur(radius: 12.0, opaque: true) as? TrayContainer<Text, Text>
        
        XCTAssertEqual(result?.blurRadius, 12.0)
        XCTAssertTrue(result?.opaque == true)
    }
    
    // MARK: - Test Registration

    static var allTests = [
        ("test_trayContainer_whenTrayIsNotDispalyed_shouldInitializeWithCorrectProperties", test_trayContainer_whenTrayIsNotDispalyed_shouldInitializeWithCorrectProperties),
        ("test_trayContainer_whenTrayIsDisplayed_shouldInitializeWithCorrectProperties", test_trayContainer_whenTrayIsDisplayed_shouldInitializeWithCorrectProperties),
        ("test_trayContainer_blur_shouldSetBlurRadius", test_trayContainer_blur_shouldSetBlurRadius),
    ]
}

extension TrayContainer: Inspectable {}
extension TrayView: Inspectable {}
