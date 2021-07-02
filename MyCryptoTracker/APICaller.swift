//
//  APICaller.swift
//  MyCryptoTracker
//
//  Created by Jesther Silvestre on 7/1/21.
//

import UIKit
final class APICaller{
    static let shared = APICaller()
    public var icons:[Icon] = []
    private var whenReadyBlock: ((Result<[Crypto], Error>)->Void)?
    
    private struct Constants{
        static let APIKEY = "60515E80-EFED-48A2-A08D-7B570459723C"
        static let ASSETSENDPOINT = "https://rest-sandbox.coinapi.io/v1/assets/"
        static let APIICONS = "https://rest-sandbox.coinapi.io/v1/assets/icons/55/?apikey=60515E80-EFED-48A2-A08D-7B570459723C"
    }
    
    private init(){}
    
    //MARK: - PUBLIC
    public func getAllCryptoData(completion:@escaping (Result<[Crypto],Error>)->Void){
        
        guard !icons.isEmpty else {whenReadyBlock = completion; return}//load the image first before everything else
        
        guard let url = URL(string: Constants.ASSETSENDPOINT+"?apikey="+Constants.APIKEY) else{return}
        
        //creating the task
        let task = URLSession.shared.dataTask(with: url) { data, _,error in
            guard let data = data, error == nil else {return}
            do {
                //decoding the response
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                
                completion(.success(cryptos.sorted { first, second in
                    return first.price_usd ?? 0 > second.price_usd ?? 0
                }))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    // get all ICONS
    public func getAllIcons(){
        guard let url: URL = URL(string: Constants.APIICONS)else{return}
        //creating the task
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, _,error in
            guard let data = data, error == nil else {return}
            do {
                //decoding the response
                self?.icons = try JSONDecoder().decode([Icon].self, from: data)
                if let completion = self?.whenReadyBlock{
                    self?.getAllCryptoData(completion: completion)
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
}

