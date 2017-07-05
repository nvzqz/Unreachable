[![Unreachable](https://github.com/nvzqz/Unreachable/raw/assets/banner.png)](https://github.com/nvzqz/Unreachable)

<p align="center">
<img src="https://img.shields.io/badge/platform-ios%20%7C%20macos%20%7C%20watchos%20%7C%20tvos%20%7C%20linux-lightgrey.svg" alt="Platform">
<img src="https://img.shields.io/badge/language-swift-orange.svg" alt="Language: Swift">
<a href="https://cocoapods.org/pods/Unreachable"><img src="https://img.shields.io/cocoapods/v/Unreachable.svg" alt="CocoaPods - Unreachable"></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage"></a>
<a href="https://codebeat.co/projects/github-com-nvzqz-unreachable-master"><img src="https://codebeat.co/badges/3e01a261-54d1-400e-8820-6aadb177c01a" alt="codebeat badge"></a>
<img src="https://img.shields.io/badge/license-MIT-000000.svg" alt="License">
</p>

Unreachable is a Swift µframework that allows for letting the compiler know when
a code path is unreachable.

- [Build Status](#build-status)
- [Installation](#installation)
    - [Compatibility](#compatibility)
    - [Swift Package Manager](#install-using-swift-package-manager)
    - [CocoaPods](#install-using-cocoapods)
    - [Carthage](#install-using-carthage)
- [Usage](#usage)
    - [Dynamic Loop Exit](#dynamic-loop-exit)
    - [Switch Conditions](#switch-conditions)
    - [Safety](#safety)
    - [Unreachable vs fatalError](#unreachable-vs-fatalerror)
        - [Unreachable Example](#with-unreachable)
        - [fatalError Example](#with-fatalerror)
- [License](#license)

## Build Status

| Branch   | Status |
| :------: | :----: |
| `master` | [![Build Status](https://travis-ci.org/nvzqz/Unreachable.svg?branch=master)](https://travis-ci.org/nvzqz/Unreachable)

## Installation

### Compatibility

- Platforms:
    - macOS 10.9+
    - iOS 8.0+
    - watchOS 2.0+
    - tvOS 9.0+
    - Linux
- Xcode 8.0+
- Swift 3.0+ & 4.0

### Install Using Swift Package Manager
The [Swift Package Manager](https://swift.org/package-manager/) is a
decentralized dependency manager for Swift.

1. Add the project to your `Package.swift`.

    ```swift
    import PackageDescription

    let package = Package(
        name: "MyAwesomeProject",
        dependencies: [
            .Package(url: "https://github.com/nvzqz/Unreachable.git",
                     majorVersion: 1)
        ]
    )
    ```

2. Import the Unreachable module.

    ```swift
    import Unreachable
    ```

### Install Using CocoaPods
[CocoaPods](https://cocoapods.org/) is a centralized dependency manager for
Objective-C and Swift. Go [here](https://guides.cocoapods.org/using/index.html)
to learn more.

1. Add the project to your [Podfile](https://guides.cocoapods.org/using/the-podfile.html).

    ```ruby
    use_frameworks!

    pod 'Unreachable', '~> 1.2.0'
    ```

    If you want to be on the bleeding edge, replace the last line with:

    ```ruby
    pod 'Unreachable', :git => 'https://github.com/nvzqz/Unreachable.git'
    ```

2. Run `pod install` and open the `.xcworkspace` file to launch Xcode.

3. Import the Unreachable framework.

    ```swift
    import Unreachable
    ```

### Install Using Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency
manager for Objective-C and Swift.

1. Add the project to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile).

    ```
    github "nvzqz/Unreachable"
    ```

2. Run `carthage update` and follow [the additional steps](https://github.com/Carthage/Carthage#getting-started)
   in order to add Unreachable to your project.

3. Import the Unreachable framework.

    ```swift
    import Unreachable
    ```

### Install Manually

Simply add `Unreachable.swift` into your project.

## Usage

Try it out for yourself! Download the repo and open 'Unreachable.playground'.

### Dynamic Loop Exit

In some cases, the only way a function returns a value is from within a loop,
but the compiler may not have enough information to know that.

```swift
func getValue() -> Int {
    for i in 0... {
        if i == 20 {
            return i
        }
    }
    assertUnreachable()
}
```

### Switch Conditions

A `switch` statement may have conditions applied to its branches that make it
exhaustive, but that may not obvious to the compiler.

```swift
func sign(of value: Double?) -> FloatingPointSign? {
    switch value {
    case let x? where x >= 0:
        return .plus
    case let x? where x < 0:
        return .minus
    case .some:
        assertUnreachable()
    case .none:
        return nil
    }
}
```

### Safety

It is [undefined behavior][ub] for `unreachable()` to be called. To protect
against this, it is recommended to use `assertUnreachable()` instead.

With `assertUnreachable()`, debug builds will exit via a fatal error if the
function is called. In optimized builds, it's no different than calling
`unreachable()`.

### Unreachable vs `fatalError()`

The `assertUnreachable()` function can be used as somewhat of a drop-in
replacement for `fatalError()`. In debug mode, they emit similar instructions.
However, when compiling with optimizations, `assertUnreachable()` allows its
parent to emit very few instructions.

Here we're checking whether a `UnicodeScalar` has a value in the lower or upper
range. Because we know that these are the only valid ranges, we can let the
compiler know that the third branch is unreachable. If at some point `x` has a
value that's not within either range, it will emit an assertion failure in
unoptimized builds.

#### With Unreachable

```swift
func isLowerRange(_ x: UnicodeScalar) -> Bool {
    switch x.value {
    case 0...0xD7FF:
        return true
    case 0xE000...0x10FFFF:
        return false
    default:
        assertUnreachable()
    }
}
```

Assembly output:

```assembly
        .globl  __T011Unreachable12isLowerRangeSbs7UnicodeO6ScalarVF
        .p2align        4, 0x90
__T011Unreachable12isLowerRangeSbs7UnicodeO6ScalarVF:
        pushq   %rbp
        movq    %rsp, %rbp
        cmpl    $55296, %edi
        setb    %al
        popq    %rbp
        retq
```

#### With `fatalError()`

```swift
func isLowerRange(_ x: UnicodeScalar) -> Bool {
    switch x.value {
    case 0...0xD7FF:
        return true
    case 0xE000...0x10FFFF:
        return false
    default:
        fatalError("Unreachable")
    }
}
```

Assembly output:

```assembly
        .globl  __T011Unreachable12isLowerRangeSbs7UnicodeO6ScalarVF
        .p2align        4, 0x90
__T011Unreachable12isLowerRangeSbs7UnicodeO6ScalarVF:
        .cfi_startproc
        movb    $1, %al
        cmpl    $55296, %edi
        jb      LBB4_3
        addl    $-57344, %edi
        cmpl    $1056768, %edi
        jae     LBB4_4
        xorl    %eax, %eax
LBB4_3:
        retq
LBB4_4:
        pushq   %rbp
Lcfi0:
        .cfi_def_cfa_offset 16
Lcfi1:
        .cfi_offset %rbp, -16
        movq    %rsp, %rbp
Lcfi2:
        .cfi_def_cfa_register %rbp
        subq    $48, %rsp
        leaq    L___unnamed_2(%rip), %rax
        movq    %rax, (%rsp)
        movl    $0, 32(%rsp)
        movq    $56, 24(%rsp)
        movl    $2, 16(%rsp)
        movq    $69, 8(%rsp)
        leaq    L___unnamed_3(%rip), %rdi
        leaq    L___unnamed_4(%rip), %rcx
        movl    $11, %esi
        movl    $2, %edx
        movl    $11, %r8d
        xorl    %r9d, %r9d
        callq   __T0s17_assertionFailures5NeverOs12StaticStringV_SSAE4fileSu4lines6UInt32V5flagstFTfq4nxnnn_n
        subq    $40, %rsp
        .cfi_endproc
```

## License

All source code for Unreachable is released under the [MIT License][license].

Assets for Unreachable are released under the [CC BY-SA 4.0 License][assets-license]
and can be found in the [`assets` branch](https://github.com/nvzqz/Unreachable/tree/assets).

[ub]: https://en.wikipedia.org/wiki/Undefined_behavior
[license]: https://github.com/nvzqz/Unreachable/blob/master/LICENSE.md
[assets-license]: https://github.com/nvzqz/Unreachable/blob/assets/LICENSE.txt
