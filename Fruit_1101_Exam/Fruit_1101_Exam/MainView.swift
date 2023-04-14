import SwiftUI

struct MainView: View {
    @StateObject var vm = FruitViewModel()
    
    private var fruits: [Fruit] {
        return vm.fruits
    }
    
    var body: some View {
        TabView {
            ContentView(fruits: fruits, vm: vm)
                .tabItem(){
                    Label("FruitList", systemImage: "square.fill")
                }
            
            GridView(fruits: fruits, vm: vm)
                .tabItem(){
                    Label("Group Family Fruit", systemImage: "heart.fill")
                }
            
            FruitLogView(vm: vm, fruitsEaten: vm.fruitsEaten)
                    .tabItem(){
                        Label("Fruit Log", systemImage: "star.fill")
                    }
        }.task {
            await vm.getFruits()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(FruitViewModel())
    }
}
