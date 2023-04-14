import SwiftUI

struct FruitLogView: View {
    var vm: FruitViewModel
    var fruitsEaten: [EatFruitModel]
    
    var body: some View {
        VStack {
            ForEach(fruitsEaten){item in
                Text("Date: \(item.date!.formatted())")
                Text("Fruit: \(item.fruit!.name)")
            }
        }
    }
}

struct FruitLogView_Previews: PreviewProvider {
    static var previews: some View {
        FruitLogView(vm: FruitViewModel(), fruitsEaten:  [])
    }
}

