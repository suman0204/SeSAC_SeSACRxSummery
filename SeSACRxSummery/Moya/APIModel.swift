//
//  APIModel.swift
//  SeSACRxSummery
//
//  Created by 홍수만 on 2023/11/09.
//

import Foundation

//서버에 보낼 때의 구조
struct Join: Encodable {
    let email: String
    let password: String
    let nick: String
}

//서버에 보낼 때의 구조
struct Login: Encodable {
    let email: String
    let password: String
}

//서버에서 받아온 데이터에 대응할 구조체
struct JoinResponse: Decodable {
    let email: String
    let nick: String
}
