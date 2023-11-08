//
//  BoxOfficeViewModel.swift
//  SeSACRxSummery
//
//  Created by 홍수만 on 2023/11/08.
//

import Foundation
import RxSwift
import RxCocoa

class BoxOfficeViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    var recent = ["테스트4", "테스트5", "테스트6"]
  
    struct Input {
        let searchButtonTapped: ControlEvent<Void> //searchBar.rx.searchButtonClicked
        let searchText: ControlProperty<String> //searchBar.rx.text.orEmpty
        let recentText: PublishSubject<String>
    }
    
    struct Output {
        let recent: BehaviorRelay<[String]>
        let items: PublishSubject<[DailyBoxOfficeList]>
    }
    
    func transform(input: Input) -> Output {
        
        let boxOfficeList = PublishSubject<[DailyBoxOfficeList]>()
        let recentList = BehaviorRelay(value: recent)
        
        input.searchButtonTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText, resultSelector: { void, query in
                return query
            })
            .map { text -> Int in
                guard let newText = Int(text) else { return 20231106 }
                return newText
            }
            .map { validText -> String in
                return String(validText)
            }
            .flatMap{
                BoxOfficeNetwork.fetchBoxOfficeData(date: $0)
            }
            .subscribe(with: self, onNext: { owner, movie in
//                print(movie)
                
                let data = movie.boxOfficeResult.dailyBoxOfficeList
                boxOfficeList.onNext(data)
                
            })
            .disposed(by: disposeBag)
        
        input.recentText
            .subscribe(with: self) { owner, value in
                owner.recent.append(value)
                recentList.accept(owner.recent)
            }
            .disposed(by: disposeBag)
        
        return Output(recent: recentList, items: boxOfficeList)
    }
}
