# RDDetailedActionController

Detailed cell item of action sheets. It has icon, title, and subtitle. Similar to Facebook's action menu.
Similar to Facebook's action menu.

[![Platform](https://img.shields.io/cocoapods/p/RDDetailedActionController.svg)](https://github.com/firanto/RDDetailedActionController)
[![CocoaPods](https://img.shields.io/cocoapods/v/RDDetailedActionController.svg)](http://cocoadocs.org/docsets/RDDetailedActionController)
[![License](http://img.shields.io/cocoapods/l/RDDetailedActionController.svg)](https://raw.githubusercontent.com/firanto/RDDetailedActionController/master/LICENSE)

## Preview

These are the example of action sheet with title only, title with icon, and title with icon and subtitle:

<img src="https://github.com/firanto/RDDetailedActionController/raw/master/ReadmeImages/title-only.png" width="214"/> <img src="https://github.com/firanto/RDDetailedActionController/raw/master/ReadmeImages/icon-title.png" width="214"/> <img src="https://github.com/firanto/RDDetailedActionController/raw/master/ReadmeImages/icon-title-subtitle.png" width="214"/>

## Installation

### With source code

[Download repository](https://github.com/firanto/RDDetailedActionController/archive/master.zip), then add [RDDetailedActionController directory](https://github.com/firanto/RDDetailedActionController/blob/master/RDDetailedActionController/) to your project.

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

You can use one of these two methods for initialization:

##### Objective-C

```objective-c
- (nonnull instancetype)initWithTitle:(NSString * _Nullable)title
                             subtitle:(NSString * _Nullable)subtitle;

- (nonnull instancetype)initWithTitle:(NSString * _Nullable)title
                             subtitle:(NSString * _Nullable)subtitle
                                 font:(UIFont * _Nullable)font
                           titleColor:(UIColor * _Nullable)titleColor;
```

##### Swift

```swift
public init(title: String?, subtitle: String?)

public init(title: String?, subtitle: String?, font: UIFont?, titleColor: UIColor?)
```

The first method is using default values for font and color of the action sheet title. This is the default usage to ensure consistent look and feel.

The second method is providing font and title color of the action sheet title. This method should be used if you want to specify font and color ONLY to this particular action sheet.

Or you could just using the default init and set the four properties one by one.

### Buttons

To add action buttons, you can call either of these methods:

##### Objective-C

```objective-c
- (void)addActionWithTitle:(NSString * _Nonnull)title
                  subtitle:(NSString * _Nullable)subtitle
                      icon:(UIImage * _Nullable)icon
                    action:(returnType (^)(RDDetailedActionView * _Nonnull))action;

- (void)addActionWithTitle:(NSString * _Nonnull)title
                  subtitle:(NSString * _Nullable)subtitle
                      icon:(UIImage * _Nullable)icon
                      titleColor:(UIColor * _Nullable)titleColor
                      subtitleColor:(UIColor * _Nullable)subtitleColor
                    action:(returnType (^)(RDDetailedActionView * _Nonnull))action;

- (void)addActionWithTitle:(RDDetailedActionView * _Nonnull)actionView;
```

##### Swift

```swift
public func addAction(title: String, subtitle: String?, icon: UIImage?, action: ((RDDetailedActionView)->())?)

public func addAction(title: String, subtitle: String?, icon: UIImage?, titleColor: UIColor?, subtitleColor: UIColor?, action: ((RDDetailedActionView)->())?)

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

### Additional Setup

When you use the first initialization method, the action sheets are using default font and color for it's title. We can customize these values so that we can have custom font and color throughout the app.

```objective-c
RDDetailedActionController.defaultTitleFont = [UIFont fontWithName:@"HelveticaNeue" size:14];
RDDetailedActionController.defaultTitleColor = [UIColor blueColor];
```

```swift
RDDetailedActionController.defaultTitleFont = UIFont(name: "HelveticaNeue", size: 14)!
RDDetailedActionController.defaultTitleColor = .blue
```

So does the action button. We can set the default color of the title and subtitle.

```objective-c
RDDetailedActionView.defaultTitleColor = [UIColor darkGrayColor];
RDDetailedActionView.defaultSubtitleColor = [UIColor grayColor];
```

```swift
RDDetailedActionView.defaultTitleColor = .darkGray
RDDetailedActionView.defaultSubtitleColor = .gray
```

### More

For more details try Xcode [DemoSwift project](https://github.com/firanto/RDDetailedActionController/blob/master/DemoSwift) or [DemoObjC project](https://github.com/firanto/RDDetailedActionController/blob/master/DemoObjC) and see [RDDetailedActionController.swift](https://github.com/firanto/RDDetailedActionController/blob/master/RDDetailedActionController/RDDetailedActionController.swift)

## License

RDDetailedActionController is released under the MIT license. See [LICENSE](https://raw.githubusercontent.com/firanto/RDDetailedActionController/master/LICENSE) for details.
