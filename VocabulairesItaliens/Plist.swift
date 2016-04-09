//
//  Plist.swift
//  VocabulairesItaliens
//
//  Created by Normand Martin on 16-03-17.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import Foundation
struct Plist {
    //1
    enum PlistError: ErrorType {
        case FileNotWritten
        case FileDoesNotExist
    }
    //2
    let name:String
    //3
    var sourcePath:String? {
        guard let path = NSBundle.mainBundle().pathForResource(name, ofType: "plist") else { return .None }
        return path
        
    }
    //4
    var destPath:String? {
        guard sourcePath != .None else { return .None }        
        let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        //print(dir)
        return (dir as NSString).stringByAppendingPathComponent("\(name).plist")
        
        
        
    }
    init?(name:String) {
        //1
        self.name = name
        //2
        let fileManager = NSFileManager.defaultManager()
        //3
        guard let source = sourcePath else { return nil }
        guard let destination = destPath else { return nil }
        guard fileManager.fileExistsAtPath(source) else { return nil }
        //4
        if !fileManager.fileExistsAtPath(destination) {
            //5
            do {
                try fileManager.copyItemAtPath(source, toPath: destination)
            } catch let error as NSError {
                print("Unable to copy file. ERROR: \(error.localizedDescription)")
                return nil
            }
        }
    }
    //1
    func getValuesInPlistFile() -> NSArray?{
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destPath!) {
            guard let arr = NSArray(contentsOfFile: destPath!) else { return .None }
            return arr
        } else {
            return .None
        }
    }
    //2
    func getMutablePlistFile() -> NSMutableArray?{
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destPath!) {
            guard let arr = NSMutableArray(contentsOfFile: destPath!) else { return .None }
            return arr
        } else {
            return .None
        }
    }
    //3
    func addValuesToPlistFile(array:NSArray) throws {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destPath!) {
            if !array.writeToFile(destPath!, atomically: false) {
                print("File not written successfully")
                throw PlistError.FileNotWritten
            }
        } else {
            throw PlistError.FileDoesNotExist
        }
    }
}
