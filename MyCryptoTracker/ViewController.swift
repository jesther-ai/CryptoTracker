//
//  ViewController.swift
//  MyCryptoTracker
//
//  Created by Jesther Silvestre on 7/1/21.
//

import UIKit

class ViewController: UIViewController {
    
    //setup tableView programmatically
    private let tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.IDENTIFIER)
        
        return tableView
    }()
    //formatter
    static let formatter : NumberFormatter = {
      let format = NumberFormatter()
        format.locale = .current
        format.allowsFloats = true
        format.numberStyle = .currency
        format.formatterBehavior = .default
        return format
    }()
    
    //array of viewMODELSSSS
    private var viewModels = [CryptoTableViewCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Jesther CryptoTracker"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        APICaller.shared.getAllCryptoData { [weak self]result in
            switch result{
            case .success(let models):
                self?.viewModels = models.compactMap({ model in
                    let iconUrl = URL(string: APICaller.shared.icons.filter({ icon in
                        icon.asset_id == model.asset_id
                    }).first?.url ?? "")
                    let price:Double = Double(model.price_usd ?? 0) * 47.70
                    return CryptoTableViewCellViewModel(name: model.name ?? "N/A",
                                                        symbol: model.asset_id,
                                                        price: ViewController.formatter.string(from: NSNumber(floatLiteral: price)) ?? "",
                                                        iconUrl: iconUrl)
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):print("Error:\(error)");
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.IDENTIFIER, for: indexPath) as? CryptoTableViewCell else{fatalError()}
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}

