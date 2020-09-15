//
//  RDDetailedActionController.swift
//  RDDetailedActionController
//
//  Created by Firstiar Noorwinanto on 7/23/18.
//  Copyright © 2018 Radical Dreamers. All rights reserved.
//

import UIKit

//class RDDetailedActionController: UIViewController {
//MARK: -
public class RDDetailedActionController: UIViewController, RDDetailedActionDelegate {
    
    //MARK: - Static Properties
    @objc public static var defaultTitleFont: UIFont = UIFont.systemFont(ofSize: 14)
    @objc public static var defaultTitleColor: UIColor = .black
    @objc public static var defaultTitleSeparatorWidth: CGFloat = 0.5

    //MARK: - Properties
    fileprivate var actions: [RDDetailedActionView] = [RDDetailedActionView]()
    fileprivate var window: UIWindow = UIWindow()
    fileprivate var actionContainer: UIView = UIView()
    fileprivate var titleLabel: UILabel = UILabel()
    fileprivate var subtitleLabel: UILabel = UILabel()
    fileprivate var scrollingBar: UIView = UIView()
    fileprivate var titleSeparator: UIView = UIView()
    fileprivate var actionScrollView: UIScrollView = UIScrollView()
    fileprivate var actionContentView: UIView = UIView()
    
    fileprivate var titleHeight: CGFloat = 43
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var containerHeight: CGFloat = 10
    fileprivate var containerVisibleY: CGFloat = 0
    
    fileprivate var deltaY: CGFloat = 0
    
    fileprivate var hasNotch: Bool = false

    @objc public var titleView: UIView? = nil
    @objc public var titleViewSidePadding: NSNumber? = nil

    @objc public var actionTitle: String? = nil
    @objc public var actionSubTitle: String? = nil
    @objc public var titleFont: UIFont? = nil
    @objc public var titleColor: UIColor? = nil
    @objc public var titleSeparatorHeight: CGFloat = defaultTitleSeparatorWidth

    //MARK: - Initilizers
    @objc public init(title: String?, subtitle: String?) {
        super.init(nibName: nil, bundle: nil)
        self.actionTitle = title
        self.actionSubTitle = subtitle
        addSubViews()
    }
    
    @objc public init(title: String?, subtitle: String?, font: UIFont?, titleColor: UIColor?) {
        super.init(nibName: nil, bundle: nil)
        self.actionTitle = title
        self.actionSubTitle = subtitle
        self.titleFont = font
        self.titleColor = titleColor
        addSubViews()
    }
    
    @objc public init(titleView: UIView, sidePadding: NSNumber? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.titleView = titleView
        self.titleViewSidePadding = sidePadding
        addSubViews()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        addSubViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubViews()
    }
    
    fileprivate func addSubViews() {
        self.view.addSubview(actionContainer)
        self.view.addSubview(scrollingBar)
        actionContainer.addSubview(titleLabel)
        actionContainer.addSubview(subtitleLabel)
        actionContainer.addSubview(titleSeparator)
        actionContainer.addSubview(actionScrollView)
        actionScrollView.addSubview(actionContentView)
        
        if titleView != nil {
            actionContainer.addSubview(titleView!)
            titleView!.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            titleHeight = titleView!.frame.height
        }
        else {
            titleHeight = 43
        }
        
    }
    
    //MARK: - Lifecycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // States
        self.hasNotch = isDeviceHasNotch(deviceName: getDeviceModel())
        
        // Window
        window.windowLevel = UIWindowLevelAlert + 1
        window.backgroundColor = .clear
        
        // Overlay view
        self.view.backgroundColor = .clear
        self.view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RDDetailedActionController.tapGestureTapped(sender:)))
        self.view.addGestureRecognizer(tapGesture)
        
        // Action container
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(RDDetailedActionController.panGestureDragged(sender:)))
        actionContainer.addGestureRecognizer(panGesture)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // calculate content container
        contentHeight = CGFloat(60 * actions.count)
        containerHeight = contentHeight + titleHeight + 20
        if (containerHeight > size.height - 80) {
            containerHeight = size.height - 80
        }
        containerVisibleY = size.height - containerHeight

        // calculate bar indicator
        var barRect = self.scrollingBar.frame
        barRect.origin.x = (size.width - barRect.width) / 2
        barRect.origin.y = containerVisibleY - 12

        coordinator.animate(alongsideTransition: { (context) in
            self.actionContainer.frame = CGRect(x: 0, y: self.containerVisibleY, width: size.width, height: self.containerHeight + 12)
            self.actionScrollView.contentSize = CGSize(width: size.width, height: self.contentHeight)
            self.actionContentView.frame = CGRect(x: 0, y: 0, width: size.width, height: self.contentHeight)
            self.scrollingBar.frame = barRect
        }, completion: { (context) in
            var leadingNotch: CGFloat = 0
            var trailingNotch: CGFloat = 0
            
            let uiOrientation = UIApplication.shared.statusBarOrientation
            if self.hasNotch && uiOrientation == .landscapeLeft {
                leadingNotch = 0
                trailingNotch = 30
            }
            else if self.hasNotch && uiOrientation == .landscapeRight {
                leadingNotch = 30
                trailingNotch = 0
            }
            
            // adjust titleView content against notch
            if self.titleView != nil {
                if self.titleViewSidePadding != nil {
                    for view in self.titleView!.subviews {
                        view.frame = CGRect(
                            x: CGFloat(self.titleViewSidePadding!.floatValue) + leadingNotch,
                            y: view.frame.origin.y,
                            width: self.titleView!.bounds.width - CGFloat(self.titleViewSidePadding!.floatValue * 2) - (leadingNotch + trailingNotch),
                            height: view.frame.height
                        )
                    }
                }
            }
            
            // adjust actions against notch
            for action in self.actions {
                action.applyValueChanges()
            }
        })
    }
    
    var isChecked:Bool = false;
    
    //MARK: - RDDetailedActionView Delegates
    func actionViewDidTapped(actionView: RDDetailedActionView) {
        if !(actionView.children != nil) || actionView.children!.count <= 0 {
            if !actionView.disabled {
                hide()
            }
        }
        else {
            isChecked = !isChecked
            UIView.animate(withDuration: 0.3, animations: {
                var idx = self.actions.index(where: { (item) -> Bool in
                    item.title == actionView.title // test if this is the item you're looking for
                })
                for act in actionView.children! {
                    if self.isChecked {
                        idx! += 1
                        (act as! RDDetailedActionView).delegate = self
                        (act as! RDDetailedActionView).hasNotch = self.hasNotch
                        
                        self.actions.insert(act as! RDDetailedActionView, at: idx!)
                    }
                    else {
                        self.actions.remove(at: idx! + 1)
                        (act as! RDDetailedActionView).removeFromSuperview()
                    }
                }
                self.show()
            })
        }
    }
    
    //MARK: - UI Events
    @objc func tapGestureTapped(sender: UITapGestureRecognizer) {
        hide()
    }
    
    @objc func panGestureDragged(sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            
        }
        else if sender.state == .changed {
            let translationPoint = sender.translation(in: self.view)
            deltaY = translationPoint.y
            
            var frame = actionContainer.frame
            var barFrame = scrollingBar.frame
            frame.origin.y = containerVisibleY + deltaY
            if frame.origin.y < containerVisibleY {
                frame.origin.y = containerVisibleY
            }
            barFrame.origin.y = frame.origin.y - 12
            var alphaMultiplier = (containerHeight - deltaY) / containerHeight
            if alphaMultiplier > 1 {
                alphaMultiplier = 1
            }
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5 * alphaMultiplier)
            actionContainer.frame = frame
            self.scrollingBar.frame = barFrame
        }
        else if sender.state == .ended {
            if sender.velocity(in: self.view).y >= 1400 || deltaY > containerHeight * 0.6 {
                // close
                hide()
            }
            else {
                // reset
                let frame = CGRect(x: 0, y: containerVisibleY, width: self.view.frame.size.width, height: containerHeight + 12)
                var barFrame = scrollingBar.frame
                barFrame.origin.y = frame.origin.y - 12
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
                    self.actionContainer.frame = frame
                    self.scrollingBar.frame = barFrame
                })
            }
        }
        else {
            hide()
        }
    }
    
    //MARK: - Actions
    @objc public func addAction(action: RDDetailedActionView) {
        action.delegate = self
        action.hasNotch = self.hasNotch
        actions.append(action)
    }
    
    @objc public func addAction(title: String, subtitle: String?, icon: UIImage?, action: ((RDDetailedActionView)->())?) {
        addAction(action: RDDetailedActionView(title: title, subtitle: subtitle, icon: icon, action: action))
    }
    
    @objc public func addAction(title: String, subtitle: String?, icon: UIImage?, disabled: Bool, action: ((RDDetailedActionView)->())?) {
        addAction(action: RDDetailedActionView(title: title, subtitle: subtitle, icon: icon, disabled: disabled, action: action))
    }
    
    @objc public func addAction(title: String, subtitle: String?, icon: UIImage?, children: NSMutableArray?, action: ((RDDetailedActionView)->())?) {
        addAction(action: RDDetailedActionView(title: title, subtitle: subtitle, icon: icon, children: children, action: action))
    }
    
    @objc public func addAction(title: String, subtitle: String?, icon: UIImage?, titleColor: UIColor?, subtitleColor: UIColor?, action: ((RDDetailedActionView)->())?) {
        addAction(action: RDDetailedActionView(title: title, subtitle: subtitle, icon: icon, titleColor: titleColor, subtitleColor: subtitleColor, action: action))
    }
    
    @objc public func show() {
        buildActionViews()
        
        if window.isHidden {
            window.frame = UIScreen.main.bounds
            window.rootViewController = self
            window.makeKeyAndVisible()
            
            // adjust the width of the titleView only after makeKeyAndVisible to ensure titleView's child views frame integrity.
            if titleView != nil {
                titleView!.frame = CGRect(x: 0, y: 0, width: actionContainer.bounds.width, height: titleView!.frame.height)
                if titleViewSidePadding != nil {
                    for view in titleView!.subviews {
                        view.frame = CGRect(
                            x: CGFloat(titleViewSidePadding!.floatValue),
                            y: view.frame.origin.y,
                            width: titleView!.bounds.width - CGFloat(titleViewSidePadding!.floatValue * 2),
                            height: view.frame.height
                        )
                    }
                }
            }
            
            let contRect = CGRect(x: 0, y: containerVisibleY, width: self.view.frame.size.width, height: containerHeight + 12)
            var barRect = self.scrollingBar.frame
            barRect.origin.y = contRect.origin.y - 12
            UIView.animate(withDuration: 0.3, animations: {
                self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
                self.actionContainer.frame = contRect
                self.scrollingBar.frame = barRect
            })
        }
        else {
            // window already shown
            // do something to the UI, i.e. recalculate the rect, then animate the grow/shrink
            let frame = CGRect(x: 0, y: containerVisibleY, width: self.view.frame.size.width, height: containerHeight + 12)
            var barFrame = scrollingBar.frame
            barFrame.origin.y = frame.origin.y - 12
            UIView.animate(withDuration: 0.3, animations: {
                self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
                self.actionContainer.frame = frame
                self.scrollingBar.frame = barFrame
            })
        }
    }
    
    @objc public func hide() {
        if !window.isHidden {
            let contRect = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: containerHeight + 12)
            var barRect = self.scrollingBar.frame
            barRect.origin.y = contRect.origin.y - 12
            UIView.animate(withDuration: 0.3, animations: {
                self.view.backgroundColor = .clear
                self.actionContainer.frame = contRect
                self.scrollingBar.frame = barRect
            }, completion: { (finished) in
                self.window.isHidden = true
            })
        }
    }
    
    //MARK: - Helper
    fileprivate func buildActionViews() {
        
        // sizes
        contentHeight = CGFloat(60 * actions.count)
        containerHeight = contentHeight + titleHeight + 20
        if (containerHeight > self.view.frame.size.height - 80) {
            containerHeight = self.view.frame.size.height - 80
        }
        containerVisibleY = self.view.frame.size.height - containerHeight
        
        // scrolling bar
        scrollingBar.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        scrollingBar.layer.cornerRadius = 3
        scrollingBar.frame = CGRect(x: (self.view.frame.width - 160) / 2, y: self.view.frame.height - 12, width: 160, height: 6)
        scrollingBar.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        
        // container
        actionContainer.backgroundColor = .white
        actionContainer.clipsToBounds = true
        actionContainer.layer.cornerRadius = 12
        actionContainer.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: containerHeight + 12)
        actionContainer.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        
        // title label
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .clear
        titleLabel.text = actionTitle ?? "Select Action"
        titleLabel.textColor = titleColor ?? RDDetailedActionController.defaultTitleColor
        titleLabel.font = titleFont ?? RDDetailedActionController.defaultTitleFont
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.frame = CGRect(x: 42, y: 5, width: actionContainer.frame.width - 84, height: 17)
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        
        if actionSubTitle == nil {
            titleLabel.frame = CGRect(x: 42, y: 13, width: actionContainer.frame.width - 84, height: 17)
            
            // subtitle label
            subtitleLabel.isHidden = true
        }
        else {
            titleLabel.frame = CGRect(x: 42, y: 5, width: actionContainer.frame.width - 84, height: 17)
            
            // subtitle label
            subtitleLabel.isHidden = false
            subtitleLabel.textAlignment = .center
            subtitleLabel.backgroundColor = .clear
            subtitleLabel.text = actionSubTitle
            subtitleLabel.textColor = titleColor ?? RDDetailedActionController.defaultTitleColor
            subtitleLabel.font = titleFont ?? RDDetailedActionController.defaultTitleFont
            subtitleLabel.lineBreakMode = .byTruncatingTail
            subtitleLabel.frame = CGRect(x: 42, y: 22, width: actionContainer.frame.width - 84, height: 17)
            subtitleLabel.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        }
        
        // title separator
        titleSeparator.backgroundColor = .lightGray
        titleSeparator.frame = CGRect(x: 0, y: titleHeight, width: actionContainer.frame.width, height: titleSeparatorHeight)
        titleSeparator.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        
        // scroll view
        actionScrollView.frame = CGRect(x: 0, y: ceil(titleHeight + titleSeparatorHeight), width: actionContainer.frame.width, height: containerHeight - titleHeight - 7)
        actionScrollView.contentSize = CGSize(width: actionContainer.frame.width, height: contentHeight)
        actionScrollView.backgroundColor = .clear
        actionScrollView.scrollsToTop = false
        actionScrollView.bounces = false
        actionScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // content view
        actionContentView.frame = CGRect(x: 0, y: 0, width: actionScrollView.frame.width, height: contentHeight)
        actionContentView.backgroundColor = .clear
        actionScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // actions
        var posY: CGFloat = 0
        for action in actions {
            if !actionContentView.subviews.contains(action) {
                actionContentView.addSubview(action)
            }
            
            action.frame = CGRect(x: 0, y: posY, width: actionContainer.frame.width, height: 60)
            action.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            action.applyValueChanges()
            posY += 60
        }
    }
    
    //MARK: - Helpers
    @objc func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return mapToDevice(identifier: identifier)
    }
    
    fileprivate func mapToDevice(identifier: String) -> String {
        #if os(iOS)
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        case "iPhone12,8":                              return "iPhone SE (2020)"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad7,5", "iPad7,6":                      return "iPad 6"
        case "iPad7,11", "iPad7,12":                    return "iPad 7"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad11,1", "iPad11,2":                    return "iPad Mini 5"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad11,3", "iPad11,4":                    return "iPad Air (2019)"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch (2016)"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch (2016)"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch (2017)"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch (2017)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro 11 Inch (2018)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro 12.9 Inch (2018)"
        case "iPad8,9", "iPad8,10":                     return "iPad Pro 11 Inch (2020)"
        case "iPad8,11", "iPad8,12":                    return "iPad Pro 12.9 Inch (2020)"
        case "AppleTV2,1":                              return "Apple TV 2"
        case "AppleTV3,1", "AppleTV3,2":                return "Apple TV 3"
        case "AppleTV5,3":                              return "Apple TV HD"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
        default:                                        return identifier
        }
        #elseif os(tvOS)
        switch identifier {
        case "AppleTV5,3": return "Apple TV HD"
        case "AppleTV6,2": return "Apple TV 4K"
        case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
        default: return identifier
        }
        #endif
    }
    
    fileprivate func isDeviceHasNotch(deviceName: String) -> Bool {
        return deviceName.range(of: "iPhone X") != nil ||
            deviceName.range(of: "iPhone 11") != nil
    }
}

//MARK: -
protocol RDDetailedActionDelegate {
    func actionViewDidTapped(actionView: RDDetailedActionView)
}

//MARK: -
public class RDDetailedActionView: UIView {
    
    //MARK: - Static Properties
    @objc static var defaultTitleFont: UIFont = UIFont.systemFont(ofSize: 14)
    @objc static var defaultSubtitleFont: UIFont = UIFont.systemFont(ofSize: 12)
    @objc static var defaultSingleTitleFont: UIFont = UIFont.systemFont(ofSize: 16)

    @objc public static var defaultTitleColor: UIColor = .black
    @objc public static var defaultSubtitleColor: UIColor = .darkGray

    //MARK: - Properties
    fileprivate var iconView: UIImageView = UIImageView()
    fileprivate var titleLabel: UILabel = UILabel()
    fileprivate var subtitleLabel: UILabel = UILabel()
    fileprivate var separator: UIView = UIView()
    
    var delegate: RDDetailedActionDelegate? = nil
    
    var hasNotch: Bool = false
    @objc public var title: String = ""
    @objc public var subtitle: String? = nil
    @objc public var icon: UIImage? = nil
    @objc public var children: NSMutableArray? = nil
    @objc public var disabled: Bool = false
    @objc public var action: ((RDDetailedActionView)->())? = nil

    @objc public var titleColor: UIColor? = nil
    @objc public var subtitleColor: UIColor? = nil

    //MARK: - Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubViews()
    }
    
    @objc public init (title: String, subtitle: String?, icon: UIImage?, action: ((RDDetailedActionView)->())?) {
        super.init(frame: .zero)
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.action = action
        
        initializeSubViews()
    }
    
    @objc public init (title: String, subtitle: String?, icon: UIImage?, disabled: Bool, action: ((RDDetailedActionView)->())?) {
        super.init(frame: .zero)
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.action = action
        self.disabled = disabled
        
        initializeSubViews()
    }
    
    @objc public init (title: String, subtitle: String?, icon: UIImage?, children: NSMutableArray?, action: ((RDDetailedActionView)->())?) {
        super.init(frame: .zero)
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.action = action
        self.children = children
        
        initializeSubViews()
    }
    
    @objc public init (title: String, subtitle: String?, icon: UIImage?, titleColor: UIColor?, subtitleColor: UIColor?, action: ((RDDetailedActionView)->())?) {
        super.init(frame: .zero)
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
        self.action = action
        
        initializeSubViews()
    }
    
    @objc public init (title: String, subtitle: String?, icon: UIImage?, titleColor: UIColor?, subtitleColor: UIColor?, children: NSMutableArray?, disabled: Bool, action: ((RDDetailedActionView)->())?) {
        super.init(frame: .zero)
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
        self.action = action
        self.children = children
        self.disabled = disabled
        
        initializeSubViews()
    }
    
    fileprivate func initializeSubViews() {
        // self
        self.isUserInteractionEnabled = true
        self.frame = CGRect(x: 0, y: 0, width: 320, height: 60)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RDDetailedActionView.tapGestureTapped(sender:)))
        self.addGestureRecognizer(tapGesture)
        
        // icon
        self.addSubview(iconView)
        iconView.frame = CGRect(x: 21, y: 22, width: 16, height: 16)
        iconView.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin]
        iconView.backgroundColor = .clear
        
        // subtitle
        self.addSubview(subtitleLabel)
        subtitleLabel.frame = CGRect(x: 56, y: 30, width: self.frame.width - 68, height: 17)
        subtitleLabel.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        subtitleLabel.font = RDDetailedActionView.defaultSubtitleFont
        subtitleLabel.textColor = subtitleColor ?? RDDetailedActionView.defaultSubtitleColor
        subtitleLabel.lineBreakMode = .byTruncatingTail
        
        // title
        self.addSubview(titleLabel)
        titleLabel.frame = CGRect(x: 56, y: 13, width: self.frame.width - 68, height: 17)
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        titleLabel.font = RDDetailedActionView.defaultTitleFont
        titleLabel.textColor = titleColor ?? RDDetailedActionView.defaultTitleColor
        titleLabel.lineBreakMode = .byTruncatingTail
        
        // separator
        self.addSubview(separator)
        separator.backgroundColor = .lightGray
        separator.frame = CGRect(x: 0, y: 59, width: self.frame.width, height: 0.5)
        separator.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    }
    
    //MARK: - UI Events
    @objc func tapGestureTapped(sender: UITapGestureRecognizer) {
        action?(self)
        action = nil
        delegate?.actionViewDidTapped(actionView: self)
    }
    
    //MARK: - Actions
    func applyValueChanges() {
        iconView.image = icon
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        titleLabel.textColor = titleColor ?? RDDetailedActionView.defaultTitleColor
        subtitleLabel.textColor = subtitleColor ?? RDDetailedActionView.defaultSubtitleColor
        
        var leadingNotch: CGFloat = 0
        var trailingNotch: CGFloat = 0
        
        let uiOrientation = UIApplication.shared.statusBarOrientation
        if hasNotch && uiOrientation == .landscapeLeft {
            leadingNotch = 0
            trailingNotch = 30
        }
        else if hasNotch && uiOrientation == .landscapeRight {
            leadingNotch = 30
            trailingNotch = 0
        }
        
        // title and subtitle
        if subtitleLabel.text == nil {
            var frame = titleLabel.frame
            frame.origin.y = 21
            frame.size.height = 18
            titleLabel.frame = frame
            
            titleLabel.font = RDDetailedActionView.defaultSingleTitleFont
            titleLabel.textColor = titleColor ?? RDDetailedActionView.defaultTitleColor
            subtitleLabel.isHidden = true
        }
        else {
            var frame = titleLabel.frame
            frame.origin.y = 13
            frame.size.height = 17
            titleLabel.frame = frame
            
            titleLabel.font = RDDetailedActionView.defaultTitleFont
            titleLabel.textColor = titleColor ?? RDDetailedActionView.defaultTitleColor
            subtitleLabel.isHidden = false
        }
        
        // actions
        if iconView.image == nil {
            iconView.isHidden = true
            titleLabel.frame = CGRect(x: 12 + leadingNotch, y: 13, width: self.frame.width - 24 - (leadingNotch + trailingNotch), height: 17)
            subtitleLabel.frame = CGRect(x: 12 + leadingNotch, y: 30, width: self.frame.width - 24 - (leadingNotch + trailingNotch), height: 17)
        }
        else {
            iconView.isHidden = false
            iconView.frame = CGRect(x: 21 + leadingNotch, y: 22, width: 16, height: 16)
            titleLabel.frame = CGRect(x: 56 + leadingNotch, y: 13, width: self.frame.width - 68 - (leadingNotch + trailingNotch), height: 17)
            subtitleLabel.frame = CGRect(x: 56 + leadingNotch, y: 30, width: self.frame.width - 68 - (leadingNotch + trailingNotch), height: 17)
        }
        
    }
}
