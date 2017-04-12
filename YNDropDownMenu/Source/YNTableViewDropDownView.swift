//
//  YNTableViewDropDownView.swift
//  expertSay
//
//  Created by songway on 2017/4/6.
//  Copyright © 2017年 donguo. All rights reserved.
//

import Foundation
import UIKit

class YNTableViewDropDownView: YNDropDownView {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!
    var data = [String]()
    var didSelectRow: ((IndexPath) -> Void)?
    var selectedIndex = 0
    var menuIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        self.initViews()
    }
    
    func hexToColor(hexString: String, alpha: CGFloat = 1.0) -> UIColor? {
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            return nil
        }
    }
    
    func cellForRowWithSafeTypeCheck<T>(_ type: T.Type, at: IndexPath) -> T? {
        if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows
            , indexPathsForVisibleRows.contains(at)
            , let cell = tableView.cellForRow(at: at) as? T {
            return cell
        }
        return nil
    }
    
    func changeSelectedCellTextColor(_ hexColor: String = "4A90E2") {
        guard selectedIndex >= 0 && selectedIndex < data.count else { return }
        if let cell = cellForRowWithSafeTypeCheck(UITableViewCell.self
            , at: IndexPath(row: selectedIndex
                , section: 0)) {
            cell.textLabel?.textColor = hexToColor(hexString: hexColor)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.register(DropDownMenuTableViewCell.self, forCellReuseIdentifier: "DropDownMenuTableViewCell")
    }
    
    
    // override method to call open & close
    override func dropDownViewOpened() {
        print("dropDownViewOpened")
        
    }
    
    override func dropDownViewClosed() {
        print("dropDownViewClosed")
    }
}

extension YNTableViewDropDownView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()// tableView.dequeueReusableCell(withIdentifier: "DropDownMenuTableViewCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let textColor = indexPath.row == selectedIndex ? hexToColor(hexString: "4A90E2") : UIColor.black
        cell.textLabel?.textColor = textColor
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell.textLabel?.text = data[indexPath.row]
//        cell.textLabel?.textAlignment = NSTextAlignment.center
        
        //let cell separator left inset equal zero
//        cell.separatorInset = UIEdgeInsets.zero
//        cell.preservesSuperviewLayoutMargins = false
//        cell.layoutMargins = UIEdgeInsets.zero
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        changeSelectedCellTextColor("000000")
        selectedIndex = indexPath.row
        changeSelectedCellTextColor()
        didSelectRow?(indexPath)
        hideMenu()
    }

}
