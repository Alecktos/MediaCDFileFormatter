import ArgumentParser
import Foundation


struct Path: ParsableCommand {
    
    @Argument(help: "Path to traverse")
    private var path: String
    
    mutating func run() throws {
        let fm = FileManager.default
        let traverser = Traverser()
        try traverser.traverse(WithFm: fm, atPath: path)
    }
}

Path.main()
