//
//  RemoteProduct.swift
//  WishList
//
//  Created by 박준영 on 4/16/24.
//

import UIKit


struct RemoteProduct: Decodable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let thumbnail: URL
}
