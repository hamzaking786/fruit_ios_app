import Foundation

enum APIError: Error{
    case invalidUrl, requestError, decodingError, statusNotOk
}

let BASE_URL: String = "https://www.fruityvice.com/api"

struct FruitApiService {
    
    func getFruits() async throws -> [Fruit] {
        
        guard let url = URL(string:  "\(BASE_URL)/fruit/all") else{
            throw APIError.invalidUrl
        }
        
        guard let (data, response) = try? await URLSession.shared.data(from: url) else{
            throw APIError.requestError
        }
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw APIError.statusNotOk
        }
        
        guard let result = try? JSONDecoder().decode([Fruit].self, from: data) else {
            throw APIError.decodingError
        }
        
        return result
    }
    
}

@MainActor
class FruitViewModel: ObservableObject {
       
    @Published var fruits: [Fruit] = []
    @Published var errorMessage = ""
    @Published var hasError = false
    @Published var fruitsEaten: [EatFruitModel] = []
    

    func getFruits() async {
        guard let data = try?  await  FruitApiService().getFruits() else {
            self.fruits = []
            self.hasError = true
            self.errorMessage  = "Server Error"
            return
        }
        
        self.fruits = data
    }
    
    func eatFruit(data: EatFruitModel) {
        self.fruitsEaten.append(data)
    }
}

struct Fruit: Identifiable, Codable {
    let name: String
    let id: Int
    let family: String
    let genus: String
    let order: String
    let nutritions: Nutritions
}

struct Nutritions: Codable {
    let carbohydrates: Double
    let protein: Double
    let fat: Double
    let calories: Double
    let sugar: Double
}
