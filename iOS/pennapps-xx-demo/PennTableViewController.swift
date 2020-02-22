//
//  PennTableViewController.swift
//  pennapps-xx-demo
//
//  Created by Dominic Holmes on 9/6/19.
//  Copyright © 2019 Dominic Holmes. All rights reserved.
//

import UIKit

struct LaundryRequest: Codable {
    let halls: [LaundryRoom]
}

struct LaundryRoom: Codable {
    let id: Int
    let location: String?
    let hallName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case location = "location"
        case hallName = "hall_name"
    }
}

enum RoomType: Int {
    case harnwell, harrison, rodin, other
}

class PennTableViewController: UITableViewController {
    
    // MARK: - Variables
    var halls = [RoomType : [LaundryRoom]]()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeAPIRequest()
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return halls.keys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let roomType = RoomType(rawValue: section)!
        return halls[roomType]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let roomType = RoomType(rawValue: indexPath.section)!
        let hall = halls[roomType]![indexPath.row]
        
        let cell: UITableViewCell
        
        if roomType == .harnwell {
            cell = tableView.dequeueReusableCell(withIdentifier: "HarnwellCell")!
            cell.imageView?.image = UIImage(named: "harnwell")
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "PennCell")!
        }
        
        cell.textLabel?.text = hall.hallName
        cell.detailTextLabel?.text = String(hall.id)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let roomType = RoomType(rawValue: section)!
        
        switch roomType {
        case .harnwell: return "Harnwell"
        case .harrison: return "Harrison"
        case .rodin: return "Rodin"
        case .other: return "Other"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "LaundryDetailSegue", sender: halls[RoomType(rawValue: indexPath.section)!]![indexPath.row])
    }
    
    // MARK: - API Request
    func makeAPIRequest() {
        let endpoint: String = "https://api.pennlabs.org/laundry/halls/ids"
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error: API request failed...")
                return
            }
            let laundryResponse = try? JSONDecoder().decode(LaundryRequest.self, from: data)
            
            self.decode(laundryResponse?.halls ?? [])
        }
        task.resume()
    }
    
    private func decode(_ halls: [LaundryRoom]) {
        var harrison = halls.filter({ $0.location == "Harrison" }).sorted(by: { $0.hallName < $1.hallName })
        var harnwell = halls.filter({ $0.location == "Harnwell" }).sorted(by: { $0.hallName < $1.hallName })
        var rodin = halls.filter({ $0.location == "Rodin" }).sorted(by: { $0.hallName < $1.hallName })
        var other = halls.filter { (room) -> Bool in
            return room.location != "Harrison" && room.location != "Harnwell" && room.location != "Rodin"
        }.sorted(by: { $0.hallName < $1.hallName })
        self.halls = [
            RoomType.harnwell : harnwell,
            RoomType.harrison : harrison,
            RoomType.rodin : rodin,
            RoomType.other : other
        ]
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Segue Control
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LaundryDetailSegue", let sender = sender as? LaundryRoom {
            let destination = segue.destination as? LaundryDetailViewController
            destination?.hall = sender
        }
    }
}

extension Dictionary where Value == [LaundryRoom] {
    func totalCount() -> Int {
        var i = 0
        for each in self.keys {
            i += (self[each]?.count ?? 0)
        }
        return i
    }
}
