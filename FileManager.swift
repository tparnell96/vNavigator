import Foundation
import SwiftUI


@available(iOS 16.0, *)
class FileManagerViewModel: ObservableObject {    
    var folderURL: URL
    
    init(folderURL: URL) {
        self.folderURL = folderURL
        // Load the initial list of files in the folder
        loadFiles()
    }
    
    @Published var files: [URL] = []
    
    func loadFiles() {
        do {
            self.files = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: [])
        } catch {
            print("Error loading files: \(error.localizedDescription)")
        }
    }
}



