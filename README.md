# Unreachable

Unreachable is a Swift µframework that allows for letting the compiler know when
a code path is unreachable.

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

    pod 'Unreachable', '~> 1.0.0'
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
    unreachable()
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
        unreachable()
    case .none:
        return nil
    }
}
```

## License

All source code for Unreachable is released under the [MIT License][license].

[license]: https://github.com/nvzqz/Unreachable/blob/master/LICENSE.md
