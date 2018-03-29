import Foundation
import SubprocesSafeLaunchAndWait

/// Run a process with the given command and arguments.
/// - parameters:
///   - command: The command to run. May be a relative or absolute path, or an executable in `path`.
///   - arguments: An optional list of arguments to pass to the command.
///   - path: The search path for `command`. Defaults to `PATH` in the environment.
///   - workingDirectoryPath: Change current working directory to this path when running the command and change back when the command finishes.
///   - encoding: The text encoding to use with the command. Defaults to `.utf8`.
public func run(_ command: String, _ arguments: [String]? = nil, path customPath: [String]? = nil, workingDirectoryPath: String? = nil, encoding customEncoding: String.Encoding? = nil) throws -> SubprocessResult {
    let path = customPath ?? processEnvironmentPath()
    let encoding = customEncoding ?? .utf8

    let process = Process()

    // Configure basic launch path + arguments.
    process.launchPath = findLaunchPath(of: command, in: path)
    process.arguments = arguments

    // Change working directory if needed.
    if let workingDirectoryPath = workingDirectoryPath {
        process.currentDirectoryPath = workingDirectoryPath
    }

    // Capture standard output and standard error.
    let standardOutputPipe = ProcessPipe()
    process.standardOutput = standardOutputPipe.pipe
    let standardErrorPipe = ProcessPipe()
    process.standardError = standardErrorPipe.pipe

    // Run the process. safeLaunchAndWait throws if launchPath can't be found.
    do {
        try process.safeLaunchAndWait()
    } catch {
        throw SubprocessError.commandNotFound(command: command, path: path)
    }

    // Try to decode output as the given encoding.
    let standardOutput = try standardOutputPipe.decodeData(encoding: encoding)
    let standardError = try standardErrorPipe.decodeData(encoding: encoding)

    return SubprocessResult(
        terminationStatus: Int(process.terminationStatus),
        standardOutput: standardOutput,
        standardError: standardError)
}

/// The errors that can be thrown from `Subprocess.run`.
public enum SubprocessError: Error {
    /// thrown if `command` is not found in `path`.
    case commandNotFound(command: String, path: [String])

    /// thrown if `data` cannot be decoded as `encoding`.
    case decodeError(data: Data, encoding: String.Encoding)
}

/// The result of running a process.
public struct SubprocessResult {
    /// Shortcut for `terminationStatus == 0`
    var success: Bool {
        return terminationStatus == 0
    }

    /// The termination status the process exited with.
    let terminationStatus: Int

    /// Standard output.
    let standardOutput: String

    /// Standard error.
    let standardError: String
}

/// Get the list of paths from the PATH environment variable.
func processEnvironmentPath() -> [String] {
    let pathString = ProcessInfo.processInfo.environment["PATH"] ?? ""
    return pathString.split { $0 == ":" }.map { String($0) }
}

/// Compute the (absolute or relative) launchPath for a command.
func findLaunchPath(of command: String, in path: [String]) -> String {
    if command.pathComponents.count > 1 {
        return command
    }

    let fileManager = FileManager.default
    let launchPath = path
        .lazy
        .map { $0.appendingPathComponent(command) }
        .first { fileManager.isExecutableFile(atPath: $0) }
    return launchPath ?? command
}

class ProcessPipe {
    private(set) var data: Data

    let pipe: Pipe

    init() {
        data = Data()

        self.pipe = Pipe()
        self.pipe.fileHandleForReading.readabilityHandler = { [weak self] (handle: FileHandle) -> () in
            self?.data.append(handle.availableData)
        }
    }

    func decodeData(encoding: String.Encoding) throws -> String {
        guard let result = String(data: data, encoding: encoding) else {
            throw SubprocessError.decodeError(data: data, encoding: encoding)
        }
        return result
    }
}

private extension String {
    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }

    func appendingPathComponent(_ path: String) -> String {
        return (self as NSString).appendingPathComponent(path)
    }
}
