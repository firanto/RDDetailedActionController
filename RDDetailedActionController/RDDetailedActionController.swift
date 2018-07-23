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
    
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var containerHeight: CGFloat = 10
    fileprivate var containerVisibleY: CGFloat = 0
    
    fileprivate var deltaY: CGFloat = 0
    
    @objc public var actionTitle: String? = nil
    @objc public var actionSubTitle: String? = nil
    @objc public var titleFont: UIFont? = nil
    @objc public var titleColor: UIColor? = nil
    
    //MARK: - Initilizers
    @objc public init(title: String?, subtitle: String?) {
        super.init(nibName: nil, bundle: nil)
        self.actionTitle = title
        self.actionSubTitle = subtitle
    }
    
    @objc public init(title: String?, subtitle: String?, font: UIFont?, titleColor: UIColor?) {
        super.init(nibName: nil, bundle: nil)
        self.actionTitle = title
        self.actionSubTitle = subtitle
        self.titleFont = font
        self.titleColor = titleColor
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Lifecycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Window
        window.windowLevel = UIWindowLevelAlert + 1
        window.backgroundColor = .clear
        
        // Overlay view
        self.view.backgroundColor = .clear
        self.view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RDDetailedActionController.tapGestureTapped(sender:)))
        self.view.addGestureRecognizer(tapGesture)
        
        // Action container
        self.view.addSubview(actionContainer)
        actionContainer.addSubview(titleLabel)
        actionContainer.addSubview(subtitleLabel)
        actionContainer.addSubview(scrollingBar)
        actionContainer.addSubview(titleSeparator)
        actionContainer.addSubview(actionScrollView)
        actionScrollView.addSubview(actionContentView)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(RDDetailedActionController.panGestureDragged(sender:)))
        actionContainer.addGestureRecognizer(panGesture)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        contentHeight = CGFloat(60 * actions.count)
        containerHeight = contentHeight + 64
        if (containerHeight > size.height - 80) {
            containerHeight = size.height - 80
        }
        containerVisibleY = size.height - containerHeight
        
        coordinator.animate(alongsideTransition: { (context) in
            self.actionContainer.frame = CGRect(x: 0, y: self.containerVisibleY, width: size.width, height: self.containerHeight + 12)
            self.actionScrollView.contentSize = CGSize(width: size.width, height: self.contentHeight)
            self.actionContentView.frame = CGRect(x: 0, y: 0, width: size.width, height: self.contentHeight)
        }, completion: { (context) in
            for action in self.actions {
                action.applyValueChanges()
            }
        })
    }
    
    //MARK: - RDDetailedActionView Delegates
    func actionViewDidTapped(actionView: RDDetailedActionView) {
        hide()
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
            frame.origin.y = containerVisibleY + deltaY
            if frame.origin.y < containerVisibleY {
                frame.origin.y = containerVisibleY
            }
            var alphaMultiplier = (containerHeight - deltaY) / containerHeight
            if alphaMultiplier > 1 {
                alphaMultiplier = 1
            }
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5 * alphaMultiplier)
            actionContainer.frame = frame
        }
        else if sender.state == .ended {
            if sender.velocity(in: self.view).y >= 1400 || deltaY > containerHeight * 0.6 {
                // close
                hide()
            }
            else {
                // reset
                let rect = CGRect(x: 0, y: containerVisibleY, width: self.view.frame.size.width, height: containerHeight + 12)
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
                    self.actionContainer.frame = rect
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
        actions.append(action)
    }
    
    @objc public func addAction(title: String, subtitle: String?, icon: UIImage?, action: ((RDDetailedActionView)->())?) {
        addAction(action: RDDetailedActionView(title: title, subtitle: subtitle, icon: icon, action: action))
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
            
            let rect = CGRect(x: 0, y: containerVisibleY, width: self.view.frame.size.width, height: containerHeight + 12)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
                self.actionContainer.frame = rect
            })
        }
    }
    
    @objc public func hide() {
        if !window.isHidden {
            let rect = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: containerHeight + 12)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.backgroundColor = .clear
                self.actionContainer.frame = rect
            }, completion: { (finished) in
                self.window.isHidden = true
            })
        }
    }
    
    //MARK: - Helper
    fileprivate func buildActionViews() {
        
        // sizes
        contentHeight = CGFloat(60 * actions.count)
        containerHeight = contentHeight + 64
        if (containerHeight > self.view.frame.size.height - 80) {
            containerHeight = self.view.frame.size.height - 80
        }
        containerVisibleY = self.view.frame.size.height - containerHeight
        
        // container
        actionContainer.backgroundColor = .white
        actionContainer.layer.cornerRadius = 12
        actionContainer.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: containerHeight + 12)
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
        
        // scrolling bar
        scrollingBar.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        scrollingBar.layer.cornerRadius = 3
        scrollingBar.frame = CGRect(x: (actionContainer.frame.width - 100) / 2, y: -12, width: 100, height: 6)
        scrollingBar.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth, .flexibleBottomMargin]
        
        // title separator
        titleSeparator.backgroundColor = .lightGray
        titleSeparator.frame = CGRect(x: 0, y: 43, width: actionContainer.frame.width, height: 0.5)
        titleSeparator.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        
        // scroll view
        actionScrollView.frame = CGRect(x: 0, y: 44, width: actionContainer.frame.width, height: containerHeight - 50)
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
    
    @objc public var title: String = ""
    @objc public var subtitle: String? = nil
    @objc public var icon: UIImage? = nil
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
    
    fileprivate func initializeSubViews() {
        // self
        self.isUserInteractionEnabled = true
        self.frame = CGRect(x: 0, y: 0, width: 320, height: 60)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RDDetailedActionView.tapGestureTapped(sender:)))
        self.addGestureRecognizer(tapGesture)
        
        // icon
        self.addSubview(iconView)
        iconView.frame = CGRect(x: 12, y: 13, width: 34, height: 34)
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
        
        let deviceModel = getDeviceModel()
        var isHaveNotch: Bool = false
        switch deviceModel {
        case "iPhone X", "Simulator iPhone X":
            isHaveNotch = true
        default:
            isHaveNotch = false
            break
        }
        
        let uiOrientation = UIApplication.shared.statusBarOrientation
        if isHaveNotch && uiOrientation == .landscapeLeft {
            leadingNotch = 0
            trailingNotch = 30
        }
        else if isHaveNotch && uiOrientation == .landscapeRight {
            leadingNotch = 30
            trailingNotch = 0
        }
        
        if iconView.image == nil {
            iconView.isHidden = true
            titleLabel.frame = CGRect(x: 12 + leadingNotch, y: 13, width: self.frame.width - 24 - (leadingNotch + trailingNotch), height: 17)
            subtitleLabel.frame = CGRect(x: 12 + leadingNotch, y: 30, width: self.frame.width - 24 - (leadingNotch + trailingNotch), height: 17)
        }
        else {
            iconView.isHidden = false
            iconView.frame = CGRect(x: 12 + leadingNotch, y: 13, width: 34, height: 34)
            titleLabel.frame = CGRect(x: 56 + leadingNotch, y: 13, width: self.frame.width - 68 - (leadingNotch + trailingNotch), height: 17)
            subtitleLabel.frame = CGRect(x: 56 + leadingNotch, y: 30, width: self.frame.width - 68 - (leadingNotch + trailingNotch), height: 17)
        }
        
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
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
        #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
        #endif
    }
}
