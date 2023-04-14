import SwiftUI

struct GridView: View {
    var fruits: [Fruit]
    var vm: FruitViewModel
    

    private let colmuns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Family")
                LazyVGrid(columns: colmuns) {
                    ForEach(Array(Set(fruits.map { $0.family })), id:\.self) { family in
                        NavigationLink(destination: {
                            ContentView(fruits: fruits.filter { $0.family == family}, vm: vm)
                        }) {
                            Text(family)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 50)
                                .foregroundColor(.white)
                                .background(.orange,
                                in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                            
                        }
                    }
                    
                }
                Text("Genus")
                LazyVGrid(columns: colmuns) {
                    ForEach(Array(Set(fruits.map { $0.genus })), id:\.self) { genus in
                        NavigationLink(destination: {
                            ContentView(fruits: fruits.filter { $0.genus == genus}, vm: vm)
                        }) {
                            Text(genus)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 50)
                                .foregroundColor(.white)
                                .background(.green,
                                in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }
                    }

                }
                Text("Order")
                LazyVGrid(columns: colmuns) {
                    ForEach(Array(Set(fruits.map { $0.order })), id:\.self) { order in
                        NavigationLink(destination: {
                            ContentView(fruits: fruits.filter { $0.order == order}, vm: vm)
                        }) {
                            Text(order)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 50)
                                .foregroundColor(.white)
                                .background(.blue,
                                in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }
                    }

                }
            }
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView(fruits: [], vm: FruitViewModel())
    }
}

