import UIKit
import Foundation

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

let cardOptAndLotus = "opt|black_lotus"
let urlStringName = magiclUrl + versionString + resourceString + name

func getData(urlRequest: URL?) {
    guard let url = urlRequest else { return }
    URLSession.shared.dataTask(with: url) { data, responce, error in
        if error != nil {
            print(error as Any)
        } else if let responce = responce as? HTTPURLResponse, responce.statusCode == 200 {
            guard let data = data else { return }
            do {
                var cardConsole = try JSONDecoder().decode(PrintConsole.self, from: data)
                cardConsole.cards.removeAll { card in
                    card.name != "Opt" && card.name != "Black Lotus"
                }
                cardConsole.cards.forEach { card in
                    print("""
                    Имя карты: \(card.name)
                    Тип: \(card.type ?? "")
                    Мановая стоимость: \(card.manaCost ?? "")
                    Название сета: \(card.setName ?? "")
                    Редкость: \(card.rarity ?? "")
                    Текст оракула: \(card.text ?? "")
                    Сила карты: \(card.power ?? "")
                    \n
                    """)
                }
            } catch {
                print(error)
            }
        }
    }.resume()
}

extension URL { func appending(_ queryItems: [URLQueryItem]) -> URL? {
    guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
        return nil
    }
    urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
    return urlComponents.url
    }
}

let url = URL(string: urlStringName)
let queryItems = [URLQueryItem(name: "name", value: cardOptAndLotus)]
let newUrlTwoCard = url?.appending(queryItems)

getData(urlRequest: newUrlTwoCard)
