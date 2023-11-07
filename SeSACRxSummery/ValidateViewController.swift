//
//  ValidateViewController.swift
//  SeSACRxSummery
//
//  Created by 홍수만 on 2023/11/07.
//

import UIKit
import RxSwift
import RxCocoa

class ValidateViewController: UIViewController {
    
    @IBOutlet var nameTextFiled: UITextField!
    @IBOutlet var validationLabel: UILabel!
    @IBOutlet var nextButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    let viewModel = ValidateViewModel()
//    let validText = BehaviorRelay(value: "닉네임은 8자 이상")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
        
        let input = ValidateViewModel.Input(text: nameTextFiled.rx.text, tap: nextButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
//        viewModel.validText
//            .asDriver()
        output.text
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        //텍스트필드 8글자 이상이면, 레이블을 숨기고 버튼을 활성화, 버튼 핑크색
        //텍스트필드 8글자 미만이면, 레이블을 보여주고 버튼 비활성화, 버튼 그레이색
//        nameTextFiled.rx.text.orEmpty
//            .map { $0.count >= 8 }
//            .subscribe(with: self) { owner, value in
//                owner.validationLabel.rx.isHidden.onNext(value)
//                owner.nextButton.rx.isEnabled.onNext(value)
//                
//                let color = value ? UIColor.systemPink : UIColor.gray
//                
//                owner.nextButton.rx.backgroundColor.onNext(color)
//            }
//            .disposed(by: disposeBag)
        
//        let validation = nameTextFiled.rx.text.orEmpty
//            .map { $0.count >= 8 }
//        
//        validation
        output.validation
            .bind(to: nextButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
//        validation
        output.validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemPink : .lightGray
                owner.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
            
//        nextButton.rx.tap
        output.tap
            .bind(with: self) { owner, _ in
                print("show alert")
            }
            .disposed(by: disposeBag)
    }
}
