import XCTest
@testable import Subprocess

class SubprocessTests: XCTestCase {
    func testExample() throws {
        do {
            let result = try Subprocess.run("ls", ["-l"])
            print("ls=\n\(result.standardOutput)")
            XCTAssertEqual(result.terminationStatus, 0)
        } catch {
            XCTFail("\(error)")
        }
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
