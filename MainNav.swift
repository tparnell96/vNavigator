//
//  MainNav.swift
//  VUMC Mapper
//
//  Created by Kenneth Parnell on 9/27/22.
//

import SwiftUI

struct MainNav: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Maps")
                List(maps) { map in
                    HStack{
                        Text(map.building)
                        NavigationLink(map.floor, destination: MapView(map: map))
                    }
                }
            }

        }
    }
}
