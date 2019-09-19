//

import SwiftUI

struct ContentView: View {
    // If you want to know where this store is created and injected, you need
    // to browse the SceneDelegate and find the reference there.
    @EnvironmentObject var store: AppStore

    var body: some View {
        VStack {
            TextField("Enter X", text: $store.x)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 150)
            TextField("Enter Y", text: $store.y)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 150)
            HStack {
                Text("Result:")
                store.result.map({
                    Text("Succeded \($0)")
                        .foregroundColor(.gray)
                }) ?? Text("Could not convert it.")
                    .foregroundColor(.green)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
