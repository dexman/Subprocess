import XCTest
@testable import Subprocess

class SubprocessPathTests: XCTestCase {
    let fileManager = FileManager.default

    let testCommand = "true"
    let testCommandPath = "/usr/bin"
    var testCommandAbsolute: String {
        return "\(testCommandPath)/\(testCommand)"
    }
    var testCommandRelative: String {
        return "./\(testCommand)"
    }

    let badTestCommand = UUID().uuidString
    let badTestCommandPath = "/usr/bin"
    var badTestCommandAbsolute: String {
        return "\(badTestCommandPath)/\(badTestCommand)"
    }
    var badTestCommandRelative: String {
        return "./\(badTestCommand)"
    }

    func testSetup() {
        XCTAssert(fileManager.isExecutableFile(atPath: testCommandAbsolute))
        XCTAssert(!fileManager.isExecutableFile(atPath: badTestCommandAbsolute))
    }

    func testAbsolutePathExists() {
        XCTAssert(try Subprocess.run(testCommandAbsolute, path: [testCommandPath]).success)
        XCTAssert(try Subprocess.run(testCommandAbsolute, path: []).success)
    }

    func testAbsolutePathNotExists() {
        XCTAssertThrowsError(try Subprocess.run(badTestCommandAbsolute, path: [badTestCommandPath]).success)
        XCTAssertThrowsError(try Subprocess.run(badTestCommandAbsolute, path: []).success)
    }

    func testRelativePathExists() {
        let oldCurrentDirectoryPath = fileManager.currentDirectoryPath
        fileManager.changeCurrentDirectoryPath(testCommandPath)
        defer { fileManager.changeCurrentDirectoryPath(oldCurrentDirectoryPath) }

        XCTAssert(try Subprocess.run(testCommandRelative, path: [testCommandPath]).success)
        XCTAssert(try Subprocess.run(testCommandRelative, path: []).success)
    }

    func testRelativePathNotExists() {
        let oldCurrentDirectoryPath = fileManager.currentDirectoryPath
        fileManager.changeCurrentDirectoryPath(testCommandPath)
        defer { fileManager.changeCurrentDirectoryPath(oldCurrentDirectoryPath) }

        XCTAssertThrowsError(try Subprocess.run(badTestCommandRelative, path: [badTestCommandPath]).success)
        XCTAssertThrowsError(try Subprocess.run(badTestCommandRelative, path: []).success)
    }

    func testNameOnlyExists() {
        XCTAssert(try Subprocess.run(testCommand, path: [testCommandPath]).success)
        XCTAssertThrowsError(try Subprocess.run(testCommand, path: []).success)
    }

    func testNameOnlyNotExists() {
        XCTAssertThrowsError(try Subprocess.run(badTestCommand, path: [badTestCommandPath]).success)
        XCTAssertThrowsError(try Subprocess.run(badTestCommand, path: []).success)
    }

    func testNameOnlyExistsInCurrentDirectory() {
        let oldCurrentDirectoryPath = fileManager.currentDirectoryPath
        fileManager.changeCurrentDirectoryPath(testCommandPath)
        defer { fileManager.changeCurrentDirectoryPath(oldCurrentDirectoryPath) }

        XCTAssertThrowsError(try Subprocess.run(testCommand, path: []).success)
    }

    static var allTests = [
        ("testSetup", testSetup),
        ("testAbsolutePathExists", testAbsolutePathExists),
        ("testAbsolutePathNotExists", testAbsolutePathNotExists),
        ("testRelativePathExists", testRelativePathExists),
        ("testRelativePathNotExists", testRelativePathNotExists),
        ("testNameOnlyExists", testNameOnlyExists),
        ("testNameOnlyNotExists", testNameOnlyNotExists),
        ("testNameOnlyExistsInCurrentDirectory", testNameOnlyExistsInCurrentDirectory),
    ]
}
