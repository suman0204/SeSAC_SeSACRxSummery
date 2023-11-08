//
//  ViewModelType.swift
//  SeSACRxSummery
//
//  Created by 홍수만 on 2023/11/08.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

//class TestViewModel: ViewModelType {
//    
//    typealias Input = Jack
//    
//    typealias Output = Hue
//    
//    struct Jack {
//        
//    }
//    
//    struct Hue {
//        
//    }
//    
//    func transform(input: Jack) -> Hue {
//        <#code#>
//    }
//}
