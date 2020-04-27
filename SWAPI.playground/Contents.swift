import Foundation

struct Person: Decodable {
    let name: String
    let films: [URL]
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

class SwapiService {
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    static private let personEndpoint = "people"
    static private let filmEndpoint = "films"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // 1 - Prepare URL
        guard let baseURL = baseURL else { return completion(nil) }
        
        let personURL = baseURL.appendingPathComponent(personEndpoint)
        let finalURL = personURL.appendingPathComponent(String(id))
        
        // 2 - Contact server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            
            // 3 - Handle errors
            if let error = error {
                print(error.localizedDescription)
                return completion(nil)
            }
            
            // 4 - Check for data
            guard let returnedData = data else { return completion(nil) }
            
            // 5 - Decode Person from JSON
            do {
                let decoder = try JSONDecoder().decode(Person.self, from: returnedData)
                completion(decoder)
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        } .resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        // 1 - Contact server
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            // 2 - Handle errors
            if let error = error {
                print(error.localizedDescription)
                return completion(nil)
            }
            
            // 3 - Check for data
            guard let returnedData = data else { return completion(nil) }
            
            // 4 - Decode Film from JSON
            do {
                let decoder = try JSONDecoder().decode(Film.self, from: returnedData)
                completion(decoder)
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        } .resume()
    }
}

SwapiService.fetchPerson(id: 4) { person in
    if let person = person {
        print(person)
        
        for film in person.films {
            fetchFilm(url: film)
        }
    }
}

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { film in
        if let film = film {
            print(film)
        }
    }
}



