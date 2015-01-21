//
//  QueryManager.swift
//  SearchImages
//
//  Created by Sheen on 1/19/15.
//  Copyright (c) 2015 Sheen. All rights reserved.
//

import Foundation
import Cocoa

protocol MDDelegate
{
    
    func searchResults(results:[String]) -> Void
}


class QueryManager
{
    
    var query:NSMetadataQuery = NSMetadataQuery()
    var delegate:MDDelegate? = nil
    
    deinit {
        // perform the deinitialization
        query.disableUpdates()
        query.stopQuery()
        var notificationCenter:NSNotificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
    }
    
    func searchInFolder(location:String,extensions extNames:[String],withDelegate _delegate:MDDelegate) -> Void
    {
        query.enableUpdates()
        query.searchScopes = NSArray(object: location)
        delegate = _delegate
        
        var subPredicates:NSMutableArray = NSMutableArray()
        for extensionName in extNames
        {
            let formattedStr:String = NSString(format:"kMDItemDisplayName == '*.%@'" , extensionName) as String
            let predicate = NSPredicate(fromMetadataQueryString:formattedStr )
            subPredicates.addObject(predicate!)
        }
    
        var finalPredicate:NSPredicate!
        
        if subPredicates.count > 1
        {
            finalPredicate = NSCompoundPredicate.orPredicateWithSubpredicates(subPredicates)
        }
        else if subPredicates.count == 1
        {
          finalPredicate = subPredicates.objectAtIndex(0) as NSPredicate
        }
        
        query.predicate = finalPredicate
        
        //notification timer
        var notificationCenter:NSNotificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "queryResults:", name: NSMetadataQueryDidFinishGatheringNotification, object: self.query)
        
        query.startQuery()
    }
    
     @objc private func queryResults(note:NSNotification)
    {
        
        if note.name == NSMetadataQueryDidStartGatheringNotification
        {
            
            
        }
        else if (note.name == NSMetadataQueryDidFinishGatheringNotification)
        {
            self.searchFinished()
        }
        else if (note.name == NSMetadataQueryGatheringProgressNotification)
        {
    
    
        }
        else if (note.name == NSMetadataQueryDidUpdateNotification)
        {
       
        }

    }
    
    func searchFinished() -> Void
    {
        query.disableUpdates()
        query.stopQuery()
        var answerArray:[String] = []
        
        for (var i = 0;i < query.resultCount;i++)
        {
            var result = query.resultAtIndex(i) as NSMetadataItem
            var filePath:String = result.valueForKeyPath("kMDItemPath") as String
            answerArray.append(filePath)
            
        }
        
        delegate?.searchResults(answerArray)
    }
    
    
}