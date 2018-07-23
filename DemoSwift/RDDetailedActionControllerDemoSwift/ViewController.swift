//
//  ViewController.swift
//  RDDetailedActionDemo
//
//  Created by Firstiar Noorwinanto on 7/23/18.
//  Copyright © 2018 Radical Dreamers. All rights reserved.
//

import UIKit
import RDDetailedActionController

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Pick one of these examples"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "ItemCell")
        
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "Title Only"
            cell?.detailTextLabel?.text = "Show an actionsheet with title only item"
            break
        case 1:
            cell?.textLabel?.text = "Icon and Title"
            cell?.detailTextLabel?.text = "Show an actionsheet with icon and title"
            break
        case 2:
            cell?.textLabel?.text = "Icon, Title, and Subtitle"
            cell?.detailTextLabel?.text = "Show an actionsheet with icon, title, and subtitle"
            break
        default:
            break
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        RDDetailedActionController.defaultTitleFont = UIFont(name: "HelveticaNeue", size: 14)!
        RDDetailedActionController.defaultTitleColor = .blue
        
        RDDetailedActionView.defaultTitleColor = .darkGray
        RDDetailedActionView.defaultSubtitleColor = .gray
        
        let detailedActionController = RDDetailedActionController(title: "Select Action", subtitle: "for selected item")

        switch indexPath.row {
        case 0:
            detailedActionController.addAction(title: "Item #1", subtitle: nil, icon: nil, action: { (actionView) in
                print("Item #1 clicked")
            })
            detailedActionController.addAction(title: "Item #2", subtitle: nil, icon: nil, action: { (actionView) in
                print("Item #2 clicked")
            })
            detailedActionController.addAction(title: "Item #3", subtitle: nil, icon: nil, action: { (actionView) in
                print("Item #3 clicked")
            })
            detailedActionController.addAction(title: "Item #4", subtitle: nil, icon: nil, titleColor: .red, subtitleColor: nil, action: { (actionView) in
                print("Item #4 clicked")
            })
            break
        case 1:
            detailedActionController.addAction(title: "Item #1", subtitle: nil, icon: UIImage(named: "Image-1"), action: { (actionView) in
                print("Item #1 clicked")
            })
            detailedActionController.addAction(title: "Item #2", subtitle: nil, icon: UIImage(named: "Image-2"), action: { (actionView) in
                print("Item #2 clicked")
            })
            detailedActionController.addAction(title: "Item #3", subtitle: nil, icon: UIImage(named: "Image-3"), action: { (actionView) in
                print("Item #3 clicked")
            })
            detailedActionController.addAction(title: "Item #4", subtitle: nil, icon: UIImage(named: "Image-4"), titleColor: .red, subtitleColor: nil, action: { (actionView) in
                print("Item #4 clicked")
            })
            break
        case 2:
            detailedActionController.addAction(title: "Item #1", subtitle: "A simple action for that item", icon: UIImage(named: "Image-1"), action: { (actionView) in
                print("Item #1 clicked")
            })
            detailedActionController.addAction(title: "Item #2", subtitle: "A more detailed action for that item", icon: UIImage(named: "Image-2"), action: { (actionView) in
                print("Item #2 clicked")
            })
            detailedActionController.addAction(title: "Item #3", subtitle: "A detailed action with extra steps", icon: UIImage(named: "Image-3"), action: { (actionView) in
                print("Item #3 clicked")
            })
            detailedActionController.addAction(title: "Item #4", subtitle: "A destructor button to remove that item", icon: UIImage(named: "Image-4"), titleColor: .red, subtitleColor: UIColor.init(red: 1, green: 0.4, blue: 0.4, alpha: 1), action: { (actionView) in
                print("Item #4 clicked")
            })
            break
        default:
            break
        }

        detailedActionController.show()
    }
}

