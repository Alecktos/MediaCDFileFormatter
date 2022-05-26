//
//  File.swift
//  
//
//  Created by Alexander Berlind on 2022-04-16.
//

import Foundation

public struct Renamer {

    public func convertFileName(forPath filePath: String) -> String? {
        
        guard let lastDotPosition = filePath.lastIndex(of: ".") else {
            print("Could not find last dot in filePath: " + filePath)
            return nil
        }
        
        let startCdPosition = filePath.index(lastDotPosition, offsetBy: -3)
        let potentialCdContent = filePath[startCdPosition..<lastDotPosition]
        if(potentialCdContent == "cd1" || potentialCdContent == "cd2") {
            print("File is already in correct format: " + filePath)
            return nil
        }
        
        guard let encodedFilePath = filePath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            print("Could not encode url: \(filePath)")
            return nil
        }
        
        guard let theURL = URL(string: encodedFilePath) else {
            print("File not valid. Could not create URL: " + filePath)
            return nil
        }
        
        let fileNameLessExt = theURL.deletingPathExtension().lastPathComponent
        let pathExtension = theURL.pathExtension
        
        let fileExtensions:[String] = ["avi", "mkv", "mpg", "mp4"]
        let correctFileExtension = fileExtensions.contains(where: pathExtension.lowercased().contains)
        if(!correctFileExtension) {
            return nil
        }
        
        func renameFile(toPrefix prefix: String) -> String {
            let urlPaths = theURL.pathComponents
            let dirPath = urlPaths.prefix(upTo: urlPaths.count-1).joined(separator: "/")
            
            return dirPath + "/" + fileNameLessExt + " - " + prefix + "." + pathExtension
        }
        
        let allowedCd1Prefixs = ["cd01", "cd1", "cd.1", "vcddvd1", "cd 1"]
        let lowerCasedfileNameLessExt = fileNameLessExt.lowercased()
        if(allowedCd1Prefixs.contains(where: lowerCasedfileNameLessExt.contains)) {
            return renameFile(toPrefix: "cd1")
        }
        
        let allowedCd2Prefixs = ["cd02", "cd2", "cd.2", "vcddvd2", "cd 2"]
        if(allowedCd2Prefixs.contains(where: lowerCasedfileNameLessExt.contains)) {
            return renameFile(toPrefix: "cd2")
        }
        
        return nil

    }
    
}
