# RDDetailedActionController

Detailed cell item of action sheets. It has icon, title, and subtitle. Similar to Facebook's action menu.
Similar to Facebook's action menu.

[![Platform](https://img.shields.io/cocoapods/p/LGAlertView.svg)](https://github.com/kurotsukikaitou/RDDetailedActionController)
[![CocoaPods](https://img.shields.io/cocoapods/v/LGAlertView.svg)](http://cocoadocs.org/docsets/RDDetailedActionController)
[![License](http://img.shields.io/cocoapods/l/LGAlertView.svg)](https://raw.githubusercontent.com/kurotsukikaitou/RDDetailedActionController/master/LICENSE)

## Preview

### Default Action Sheet


### Action Sheet with Icon


### Action Sheet with Icon and Subtitle

## Installation

### With source code

[Download repository](https://github.com/kurotsukikaitou/RDDetailedActionController/archive/master.zip), then add [LGAlertView directory](https://github.com/kurotsukikaitou/RDDetailedActionController/blob/master/LGAlertView/) to your project.

Then import header files where you need to use the library

##### Objective-C

For objective-c, since the pod is built using Swift, we need to import the switch-to-objective-c bridge header.

```objective-c
#import "RDDetailedActionController-Swift.h"
```

And that's it. You're good to go.

##### Swift

For swift, you just do nothing. The controller should be available right away.

### With CocoaPods

CocoaPods is a dependency manager for Objective-C and Swift, which automates and simplifies the process of using 3rd-party libraries in your projects. To install with cocoaPods, follow the "Get Started" section on [CocoaPods](https://cocoapods.org/).

#### Podfile

```ruby
platform :ios, '8.0'
use_frameworks!
pod 'RDDetailedActionController'
```

Then import framework where you need to use the library (since this lib is in Swift, import the swift-to-objc bridging header)

##### Objective-C

```objective-c
#import <RDDetailedActionController/RDDetailedActionController-Swift.h>
// OR
@import RDDetailedActionController;
```

And don't forget to set the Pod project's Swift Compiler to Swift 4 if you have not done it before.

##### Swift

```swift
import RDDetailedActionController
```

## Usage

### Initialization

You have one method for initialization:

##### Objective-C

```objective-c
- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                             subtitle:(nullable NSString *)subtitle
                                 font:(nullable UIFont *)font
                           titleColor:(nullable UIColor *)titleColor;
```

##### Swift

```swift
public init(title: String?,
         subtitle: String?,
             font: UIFont?,
       titleColor: UIColor?)
```

Or you could just using the default init and set the four properties one by one.

### Setup

You can change properties only before you show action sheet, after this to change something is impossible.

### Buttons

To add action buttons, you can call either of these methods:

##### Objective-C

```objective-c
- (void)addActionWithTitle:(NSString * _Nonnull)title
                  subtitle:(NSString * _Nullable)subtitle
                      icon:(UIImage* _Nullable)icon
                    action:(returnType (^)(RDDetailedActionView * _Nonnull))action;

- (void)addActionWithTitle:(RDDetailedActionView * _Nonnull)actionView;
```

##### Swift

```swift
public func addAction(title: String, subtitle: String?, icon: UIImage?, action: ((RDDetailedActionView)->())?)

public func addAction(action: RDDetailedActionView)
```

#### Show / Dismiss

You can show and dismiss action sheet by calling these methods:

##### Objective-C

```objective-c
[detailedActionController show];
[detailedActionController hide];
```

##### Swift

```swift
detailedActionController.show()
detailedActionController.hide()
```

### More

For more details try Xcode [Demo project](https://github.com/kurotsukikaitou/RDDetailedActionController/blob/master/Demo) and see [LGAlertView.h](https://github.com/kurotsukikaitou/RDDetailedActionController/blob/master/LGAlertView/LGAlertView.h)

## License

LGAlertView is released under the MIT license. See [LICENSE](https://raw.githubusercontent.com/kurotsukikaitou/RDDetailedActionController/master/LICENSE) for details.
