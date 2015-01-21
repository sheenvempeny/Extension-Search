//
//  ViewController.swift
//  SearchImages
//
//  Created by Sheen on 1/19/15.
//  Copyright (c) 2015 Sheen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController , NSTableViewDataSource , NSTableViewDelegate
{

    @IBOutlet weak var SLResultView: NSTableView!
    @IBOutlet weak var FLListView: NSTableView!
    @IBOutlet weak var txtFilter: NSTextField!
    @IBOutlet weak var txtSearchFolder: NSTextField!
    var filters:[String] = []
    var exListViewController:ExtensionListViewController? = nil
    
    
    @IBAction func AddFilter(sender: AnyObject)
    {
        var newFilter = txtFilter.stringValue
        if newFilter.isEmpty == false
        {
            filters.append(newFilter)
            txtFilter.stringValue = ""
            FLListView.reloadData()
        }
        
    }
    
    @IBAction func RemoveFilter(sender: AnyObject)
    {
        var selectedIndex = FLListView.selectedRow
        
        if selectedIndex >= 0
        {
            filters.removeAtIndex(selectedIndex)
            FLListView.reloadData()
        }
        
    }
    
    @IBAction func ChooseLocation(sender: AnyObject)
    {
    
        if filters.count == 0
        {
            let alert:NSAlert =  NSAlert()
            alert.messageText = "Please add some extensions"
            alert.runModal();
            return;
        }
        
        
        var openPanel:NSOpenPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        if openPanel.runModal() == NSFileHandlingPanelOKButton
        {
            var url:NSURL?  = openPanel.URL
            txtSearchFolder.stringValue = url!.absoluteString!.stringByReplacingOccurrencesOfString("file://", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
        
        exListViewController!.searchInFolder(txtSearchFolder.stringValue, withExtensions: filters)
    }
    
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return filters.count
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        // Get an existing cell with the MyView identifier if it exists
        var cell = tableView.makeViewWithIdentifier("List", owner: self) as NSTableCellView
        cell.textField?.stringValue = filters[row]
        // Return the result
        return cell;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        exListViewController = ExtensionListViewController()
        exListViewController!.listView = SLResultView
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

