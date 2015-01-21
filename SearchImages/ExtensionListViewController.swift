//
//  ExtensionListViewController.swift
//  SearchImages
//
//  Created by Sheen on 1/20/15.
//  Copyright (c) 2015 Sheen. All rights reserved.
//

import Foundation
import Cocoa

class  ExtensionListViewController : NSObject,NSTableViewDataSource,NSTableViewDelegate,MDDelegate
{
    
    var queryManager:QueryManager?
    var results:[String]! = nil
    
     override init()
    {
        super.init()
       
    }
    
    var listView:NSTableView?
    {
        
        didSet
        {
            self.listView!.setDataSource(self)
            self.listView!.setDelegate(self)
        }
        
    }
    
    func searchInFolder(location:String,withExtensions extensions:[String]) -> Void
    {
        queryManager = nil
        queryManager = QueryManager()
        queryManager?.searchInFolder(location, extensions: extensions, withDelegate: self)
    }
    
    func searchResults(resultArray: [String])
    {
        results = resultArray
        queryManager = nil
        self.listView?.reloadData()
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        
        var count = 0
        if results != nil
        {
            count = results!.count
        }
        
        return count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        // Get an existing cell with the MyView identifier if it exists
        var cell = tableView.makeViewWithIdentifier("List", owner: self) as NSTableCellView
        cell.textField?.stringValue = results![row]
        // Return the result
        return cell;
    }

    
}