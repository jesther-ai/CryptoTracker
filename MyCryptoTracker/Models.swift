//
//  Models.swift
//  MyCryptoTracker
//
//  Created by Jesther Silvestre on 7/1/21.
//

import Foundation

struct Crypto: Codable {
    let asset_id:String
    let name:String?
    let price_usd:Float?
    let id_icon:String?
}
//for ICONS decodable

struct Icon:Codable{
    let asset_id:String
    let url:String
}

//viewModelObject

class CryptoTableViewCellViewModel {
    let name:String
    let symbol:String
    let price:String
    let iconUrl:URL?
    var iconData:Data?
    
    init(name:String, symbol:String, price:String, iconUrl:URL?) {
        self.name = name
        self.symbol = symbol
        self.price = price
        self.iconUrl = iconUrl
    }
}


