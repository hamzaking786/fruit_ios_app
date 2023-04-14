
import SwiftUI

struct ContentView: View {
    var fruits: [Fruit]
    var vm: FruitViewModel
    
    // @StateObject var vm = FruitViewModel()
    @State private var searchText: String = ""
    
    private var searchResults: [Fruit] {
        let results = fruits
        if searchText.isEmpty { return results }
        return results.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    private var suggestedResults: [Fruit] {
        if searchText.isEmpty { return [] }
        return searchResults
    }
    
    var body: some View {
        NavigationView {
            List(searchResults) { fruit in
                NavigationLink(destination: {
                    FruitDetailsView(fruit: fruit, vm: vm)
                }) {
                    HStack {
                        Rectangle()
                            .fill(colorGenerator(seed: fruit.family))
                            .frame(width: 20, height: 20)
                        Text("\(fruit.name)")
                            .padding(6)
                    }
                }
            }
            .navigationTitle("Søk på frukt")
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Søk etter frukt"
            ) {
                ForEach(suggestedResults) { fruitDetails in
                    Text("Ser etter \(fruitDetails.name)?")
                        .searchCompletion(fruitDetails.name)
                }
            }
        }
    }
    
    func colorGenerator(seed: String) -> Color {
        let hash = abs(seed.hashValue)
        let colorNum = hash % (256*256*256)
        
        let red = colorNum >> 16
        let green = (colorNum & 0x00FF00) >> 8
        let blue = (colorNum & 0x0000FF)
        let userColor = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
        return Color(userColor)
    }
}

struct FruitDetailsView: View {
    @Environment(\.presentationMode) var presentation
    
    let fruit: Fruit
    let vm: FruitViewModel
    @State private var opacity:Double = 0.2
    @State private var showModal = false
    @State var fruitToEat = EatFruitModel(fruit: nil, date: nil)
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    if fruit.nutritions.sugar > 10 {
                        Text("HIGH IN SUGAR")
                            .bold()
                            .underline(true, color: .red)
                    }
                    Text("\(fruit.name)")
                        .font(.largeTitle)
                        .bold()
                    HStack {
                        Text("Family")
                        Spacer()
                        Text("\(fruit.family)")
                    }
                    HStack {
                        Text("Order")
                        Spacer()
                        Text("\(fruit.order)")
                    }
                    HStack {
                        Text("Genus")
                        Spacer()
                        Text("\(fruit.genus)")
                    }
                    HStack {
                        Text("Carbohydrates")
                        Spacer()
                        Text("\(fruit.nutritions.carbohydrates)")
                    }
                    HStack {
                        Text("Protein")
                        Spacer()
                        Text("\(fruit.nutritions.protein)")
                    }
                    HStack {
                        Text("Fat")
                        Spacer()
                        Text("\(fruit.nutritions.fat)")
                    }
                    HStack {
                        Text("Calories")
                        Spacer()
                        Text("\(fruit.nutritions.calories)")
                    }
                    HStack {
                        Text("Sugar")
                        Spacer()
                        Text("\(fruit.nutritions.sugar)")
                    }
                }
                Spacer()
            }
            .padding([.leading, .trailing], 24)
            .background(fruit.nutritions.sugar > 10 ? .red : .white)
            .opacity(opacity)
            .onAppear() {
                let baseAnimation =
                Animation.linear(duration: 1)
                withAnimation (fruit.nutritions.sugar > 10 ?
                               baseAnimation.repeatForever(
                                autoreverses: true) :
                                Animation.default) {
                    self.opacity = 0.8
                }
            }
            Button("Spis denne frukten") {
                self.showModal = true
            }
        }.sheet(isPresented: $showModal, onDismiss: {
            self.fruitToEat.fruit = fruit
            vm.eatFruit(data: fruitToEat)
            self.presentation.wrappedValue.dismiss()
        }) {
            ModalView(fruitToEat: $fruitToEat)
        }
    }
}

struct EatFruitModel: Identifiable {
    var id = UUID()
    var fruit: Fruit?
    var date: Date?
    }
    

struct ModalView: View {
    @Environment(\.presentationMode) var presentation
    @State private var selectedDate = Date()
    @Binding var fruitToEat: EatFruitModel

    var body: some View {
        VStack {
            DatePicker(selection: $selectedDate, in: ...Date(), displayedComponents: .date) {
                Text("Når spiste du den")
            }
            Text("Valgt dato: \(selectedDate.formatted(date: .long, time: .omitted))")
            HStack {
                Button("Avbryt") {
                    self.presentation.wrappedValue.dismiss()
                }.foregroundColor(.red)
                Button("Loggfør") {
                    fruitToEat.date = selectedDate
                    self.presentation.wrappedValue.dismiss()
                }
            }
        }
    }
}
