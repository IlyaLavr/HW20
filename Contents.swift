import UIKit

struct PrintConsole: Decodable {
    var cards: [Card]
}

struct Card: Decodable {
    var name: String
    var manaCost: String?
    var type: String?
    var setName: String?
    var rarity: String?
    var text: String?
    var power: String?
}

var magiclUrl: String {
    "https://api.magicthegathering.io"
}
var versionString: String {
    "/v1"
}
var resourceString: String {
    "/cards"
}
var name: String {
    "?name="
}
var cardNameLotus = "black_lotus"
var cardNameOpt = "Opt"

let urlStringLotus = magiclUrl + versionString + resourceString + name + cardNameLotus
let urlStringOpt = magiclUrl + versionString + resourceString + name + cardNameOpt

func getData(urlRequest: String) {
    let urlRequest = URL(string: urlRequest)
    guard let url = urlRequest else { return }
    URLSession.shared.dataTask(with: url) { data, responce, error in
        if error != nil {
            print(error as Any)
        } else if let responce = responce as? HTTPURLResponse, responce.statusCode == 200 {
            guard let data = data else { return }
            do {
                let cardConsole = try JSONDecoder().decode(PrintConsole.self, from: data)
                print("""
                          Имя карты: \(cardConsole.cards.first?.name ?? "")
                          Тип: \(cardConsole.cards.first?.type ?? "")
                          Мановая стоимость: \(cardConsole.cards.first?.manaCost ?? "")
                          Название сета: \(cardConsole.cards.first?.setName ?? "")
                          Редкость: \(cardConsole.cards.first?.rarity ?? "")
                          Текст оракула: \(cardConsole.cards.first?.text ?? "")
                          Сила карты: \(cardConsole.cards.first?.power ?? "Для этой карты нет значения")
                          """)
            } catch {
                print(error)
            }
        }
    }.resume()
}

getData(urlRequest: urlStringLotus)
getData(urlRequest: urlStringOpt)

