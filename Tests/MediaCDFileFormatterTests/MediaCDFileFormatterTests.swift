import XCTest
import class Foundation.Bundle

@testable import MediaCDFileFormatter

final class MediaCDFileFormatterTests: XCTestCase {
    
    let myRanemer = Renamer()
    static let tempFilesDirPath = "./tempFiles"
    
    override func setUpWithError() throws  {
        try FileManager.default.createDirectory(atPath: Self.tempFilesDirPath, withIntermediateDirectories: false)
    }
    
    override func tearDownWithError() throws {
        try FileManager.default.removeItem(atPath: Self.tempFilesDirPath)
    }
    
    func testRenamer() {
        let testPathCd01 = "\(Self.tempFilesDirPath)/Call.In.Situation.Now.7897.DVDRip.XviD-Fall.CD01.avi"
        FileManager.default.createFile(atPath: testPathCd01, contents: nil)
        
        let convertedFileNameCd01 = myRanemer.convertFileName(forPath: testPathCd01)
        XCTAssertEqual(convertedFileNameCd01, "\(Self.tempFilesDirPath)/Call.In.Situation.Now.7897.DVDRip.XviD-Fall.CD01 - cd1.avi")
        
        let testPathCd02 = "\(Self.tempFilesDirPath)/Call.In.Situation.Now.7897.DVDRip.XviD-Fall.CD02.avi"
        FileManager.default.createFile(atPath: testPathCd02, contents: nil)
        
        let convertedFileNameCd02 = myRanemer.convertFileName(forPath: testPathCd02)
        XCTAssertEqual(convertedFileNameCd02, "\(Self.tempFilesDirPath)/Call.In.Situation.Now.7897.DVDRip.XviD-Fall.CD02 - cd2.avi")
    }
    
    func testDontRenameAlreadyCorrectPaths() {
        let testPath = "\(Self.tempFilesDirPath)/Call.In.Situation.Now.7897.DVDRip.XviD-Fall.CD02 - cd2.avi"
        FileManager.default.createFile(atPath: testPath, contents: nil)
        
        let convertedFileNameCd02 = myRanemer.convertFileName(forPath: testPath)
        XCTAssertEqual(convertedFileNameCd02, nil)
    }
    
    func testMovingFile() {
        let pathBefore = "\(Self.tempFilesDirPath)/Call.In.Situation.Now.7897.DVDRip.XviD-Fall.CD01.avi"
        FileManager.default.createFile(atPath: pathBefore, contents: nil)
        
        let traverser = Traverser()
        do {
            try traverser.moveMedia(withItemPath: pathBefore)
        } catch {
            // Do nothing
            XCTFail("Failed to run moveMedia: \(error)")
        }
        let pathAfter = "\(Self.tempFilesDirPath)/Call.In.Situation.Now.7897.DVDRip.XviD-Fall.CD01 - cd1.avi"
        XCTAssertTrue(FileManager.default.fileExists(atPath: pathAfter))
    }
}
