//
//  APIManager.swift
//  SeSACRxSummery
//
//  Created by 홍수만 on 2023/11/09.
//

import Foundation
import Moya

class APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    
    let provider = MoyaProvider<SeSACAPI>()
    
    func signUp() {
        let data = Join(email: "a0204@a.com", password: "1234", nick: "칙촉촉칙")
        
        provider.request(.signUp(model: data)) { result in
            switch result {
            case .success(let value):
                print("success", value.statusCode, value.data)
                
                let result = try! JSONDecoder().decode(JoinResponse.self, from: value.data)
                
                print(result)
                
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
}
