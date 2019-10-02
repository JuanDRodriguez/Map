//
//  SecondViewController.swift
//  Maps
//
//  Created by Pronto on 10/1/19.
//  Copyright © 2019 Pronto. All rights reserved.
//

import UIKit
import GooglePlaces
class SecondViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var items: [GMSPlace] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PlaceCell", bundle: nil), forCellReuseIdentifier: "PlaceCell")
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.items = ModelData.shared.items
        tableView.reloadData()
        
    }

}

extension SecondViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceCell
        cell.display(item: items[indexPath.row])
        return cell
    }
    
    
}
