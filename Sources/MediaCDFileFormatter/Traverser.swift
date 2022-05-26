//
//  File.swift
//  
//
//  Created by Alexander Berlind on 2022-03-24.
//

import Foundation

struct Traverser {
    
    let renamer: Renamer = Renamer()
    
    func traverse(WithFm fm: FileManager, atPath currPath: String) throws {
        let items = try fm.contentsOfDirectory(atPath: currPath)
        for item in items {
            var isDir: ObjCBool = false
            
            let itemPath: String = currPath + "/" + item
            
            
            fm.fileExists(atPath: itemPath, isDirectory: &isDir)
            if isDir.boolValue == true {
                try traverse(WithFm: fm, atPath: itemPath)
            } else {
                try self.moveMedia(withItemPath: itemPath)
            }
        }
    }
    
    func moveMedia(withItemPath itemPath: String) throws {
        if let newItemPath = renamer.convertFileName(forPath: itemPath) {
            // print("itemPath: " + itemPath)
            print("Will move to new path: " + newItemPath)
            try FileManager.default.moveItem(atPath: itemPath, toPath: newItemPath)
        }
    }
    
}
