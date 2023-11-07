//
//  ValidateViewModel.swift
//  SeSACRxSummery
//
//  Created by 홍수만 on 2023/11/07.
//

import Foundation
import RxSwift
import RxCocoa

class ValidateViewModel {
    
//    let validText = BehaviorRelay(value: "닉네임은 8자 이상")

    struct Input {
        let text: ControlProperty<String?> //nameTextField.rx.text
        let tap: ControlEvent<Void> //nextButton.rx.tap
    }
    
    struct Output {
        let tap: ControlEvent<Void> //tap 했을 때 따로 해주는게 없어서 그냥 들렸다 나간다
        let text: Driver<String>
        let validation: Observable<Bool>
    }

    // input으로 받아온 데이터를 가공하는 함수
    func transform(input: Input) -> Output {
        
        let validation = input
            .text
            .orEmpty
            .map { $0.count >= 8 }
        
        //RxCocoa는 UIKit 기반이므로 VM에 있을 수 없다고 생각하면 Observable로 대응해볼 수 있다
        let validText = BehaviorRelay(value: "닉네임은 8자 이상").asDriver()//Observable.of("닉네임은 8자 이상")
        return Output(
            tap: input.tap,
            text: validText,
            validation: validation)
    }
}
