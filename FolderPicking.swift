//
//  FolderPicking.swift
//  vNavigator
//
//  Created by Taylor Parnell on 3/11/23.
//

import Foundation
import SwiftUI

@available(iOS 16.0, *)
struct FolderPicker: UIViewControllerRepresentable {
    
    var folderURL = URL.documentsDirectory
    
    var fileManagerViewModel: FolderListView
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker =
        UIDocumentPickerViewController(forOpeningContentTypes: [.folder], asCopy: false)
        documentPicker.delegate = context.coordinator
        return documentPicker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: FolderPicker
        
        init(_ parent: FolderPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard urls.first!.startAccessingSecurityScopedResource() else {
                           // Handle the failure here.
                           return
                       }
                       
                       // Release the security-scoped resource when finished.
            defer { urls.first!.stopAccessingSecurityScopedResource() }
                       
            guard let pickedURL = urls.first else { return }
            do {
                // Add the picked file to the folder's directory
                let fileURL = parent.folderURL.appendingPathComponent(pickedURL.lastPathComponent)
                try FileManager.default.copyItem(at: pickedURL, to: fileURL)
                // Update the list of files in the view model
                parent.fileManagerViewModel.loadFolders()
            } catch {
                print("Error copying file: \(error.localizedDescription)")
            }
        }
    }
}
