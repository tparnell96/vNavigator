//
//  Landing.swift
//  VUMC Mapper
//
//  Created by Kenneth Parnell on 9/27/22.
//

import SwiftUI

struct Landing: View {
    var body: some View {
        TabView {
            MainNav()
                .tabItem {
                    Label("Maps", systemImage: "map")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct Landing_Previews: PreviewProvider {
    static var previews: some View {
        Landing()
    }
}
