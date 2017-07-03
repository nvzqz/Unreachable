//
//  Unreachable.swift
//  Unreachable
//
//  The MIT License (MIT)
//
//  Copyright (c) 2017 Nikolai Vazquez
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

/// An unreachable code path.
///
/// This can be used for whenever the compiler can't determine that a
/// path is unreachable, such as dynamically terminating an iterator.
@inline(__always)
public func unreachable() -> Never {
    return unsafeBitCast((), to: Never.self)
}

/// Asserts that the code path is unreachable.
///
/// Calls `assertionFailure(_:file:line:)` in unoptimized builds and `unreachable()` otherwise.
///
/// - parameter message: The message to print.
/// - parameter file: The file name to print with the message.
/// - parameter line: The line number to print with the message.
@inline(__always)
public func assertUnreachable(_ message: @autoclosure () -> String = "Encountered unreachable path",
                              file: StaticString = #file,
                              line: UInt = #line) -> Never {
    assertionFailure(message, file: file, line: line)
    unreachable()
}
