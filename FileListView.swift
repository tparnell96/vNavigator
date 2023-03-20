import SwiftUI
import QuickLook
import Foundation
@available(iOS 16.0, *)
struct FileListView: View {
    let folderURL: URL
    @ObservedObject var fileManagerViewModel: FileManagerViewModel
    @State var showFilePicker = false
    @State var isPresentingFileRename = false
    @State var currentURL: URL?
    @State private var fileName = ""
    @State private var newName = ""    
    @State private var showRenameAlert = false
    @State private var showDeleteConfirm = false
    @State private var fileToRename: URL?
    @State private var indexToDelete: Int?
    
    private var filteredFiles: [URL] {
        fileManagerViewModel.files.filter { $0.pathExtension.localizedCaseInsensitiveContains("pdf") }
            .sorted { $0.lastPathComponent < $1.lastPathComponent }
    }
    var body: some View {
        List {
            ForEach(filteredFiles, id: \.self) { file in
                Button(file.deletingPathExtension().lastPathComponent) {
                    currentURL = file
                }
                .contextMenu {
                    Button(action: {
                        fileToRename = file
                        newName = ""
                        showRenameAlert = true
                    }, label: {
                        Label("Rename", systemImage: "pencil")
                    })
                    Button(action: {
                        showDeleteConfirm = true
                        indexToDelete = filteredFiles.firstIndex(of: file)
                    }, label: {
                        Label("Delete", systemImage: "trash")
                    })
                }
                .quickLookPreview($currentURL)
            }
            .onDelete(perform: deleteFile)
        }
        .navigationTitle(folderURL.lastPathComponent)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showFilePicker = true
                } label: {
                    Label("Add Floorplan", systemImage: "plus")
                }
                .sheet(isPresented: $showFilePicker, content: {
                    DocumentPicker(folderURL: folderURL, fileManagerViewModel: fileManagerViewModel)
                })
            }
        }
        .alert("Are you sure you want to delete this file?", isPresented: $showDeleteConfirm, actions: {
            if indexToDelete != nil {
                Button("Delete", role: .destructive, action: {
                    let fileURL = filteredFiles[indexToDelete!]
                    try! FileManager.default.removeItem(at: fileURL)
                    fileManagerViewModel.files.removeAll(where: { $0 == fileURL })
                    indexToDelete = nil
                })
            }
        })
        
        
        .alert("Rename Floor", isPresented: $showRenameAlert, actions: {
            TextField("Rename Building", text: $newName)
            Button("Cancel", action: {
                newName = ""
            })
            Button("Rename Floor", action: {
                guard !newName.isEmpty else { return }
                renameFile()
            })
        })
    }
    func deleteFile(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let fileURL = filteredFiles[index]
        try! FileManager.default.removeItem(at: fileURL)
        fileManagerViewModel.files.removeAll(where: { $0 == fileURL })
    }
    
    func renameFile() {
        guard let fileURL = fileToRename else { return }
        let newURL = fileURL.deletingLastPathComponent().appendingPathComponent(newName).appendingPathExtension(fileURL.pathExtension)
        try! FileManager.default.moveItem(at: fileURL, to: newURL)
        fileManagerViewModel.files.removeAll(where: { $0 == fileURL })
        fileManagerViewModel.files.append(newURL)
        fileToRename = nil
    }
}
