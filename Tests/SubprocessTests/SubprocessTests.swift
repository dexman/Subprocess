import XCTest
@testable import Subprocess

class SubprocessTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Subprocess().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
