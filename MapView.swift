import SwiftUI
struct MapView: View {
    var map : Map
    let documentURL = Bundle.main.url(forResource: "CTB" , withExtension: "PDF")!
    var body: some View {
        VStack(alignment: .leading) {
            Text(map.building)
                .font(.largeTitle)
            HStack(alignment: .top) {
                Text(map.floor)
                    .font(.title)
            }
            PDFKitView(url: documentURL)
        }
    }
}

