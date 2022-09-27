import SwiftUI
import UIKit
import PDFKit


struct PDFKitView: View {
    var url: URL
    
    var body: some View {
        PDFKitRepresentedView(url)
    }
}
