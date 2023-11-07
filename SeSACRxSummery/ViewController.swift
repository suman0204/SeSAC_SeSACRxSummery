//
//  ViewController.swift
//  SeSACRxSummery
//
//  Created by jack on 2023/11/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BoxOfficeViewController: UIViewController {
    
    let tableView = UITableView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout() )
    let searchBar = UISearchBar()
    
    let disposeBag = DisposeBag()
    
    let array = Array<String>()
    let items = PublishSubject<[DailyBoxOfficeList]>()//Observable.just(["테스트1", "테스트2", "테스트3"]) //값을 한 번에 방출
    
    let recent = BehaviorRelay(value: ["테스트4", "테스트5", "테스트6"]) //BehaviorSubject(value: ["테스트4", "테스트5", "테스트6"]) //Observable.just(["테스트4", "테스트5", "테스트6"]) 새로운 값을 전달 받을 수 있도록 Subject로 바꿔준다

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    func bind() {
        
        items
            .bind(to: tableView.rx.items(cellIdentifier: "MovieCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element.movieNm) @ row \(element.openDt)"
            }
            .disposed(by: disposeBag)

        recent
            .asDriver() //Driver<[String]>
            .drive(collectionView.rx.items(cellIdentifier: "MovieCollectionCell", cellType: MovieCollectionViewCell.self)) { (row, element, cell) in
                cell.label.text = "\(element) @ row \(row)"
            }
            .disposed(by: disposeBag)
//            .bind(to: collectionView.rx.items(cellIdentifier: "MovieCollectionCell", cellType: MovieCollectionViewCell.self)) { (row, element, cell) in
//                cell.label.text = "\(element) @ row \(row)"
//            }
//            .disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(searchBar.rx.text.orEmpty, resultSelector: { void, query in
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
                owner.items.onNext(data)
                
            })
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.modelSelected(DailyBoxOfficeList.self), tableView.rx.itemSelected)
            .map { $0.0.movieNm }
            .debug()
            .subscribe(with: self) { owner, value in
//                print(value.0, value.1)
//                value.0.movieNm
                //1.try 2.recent는 subject, 하지만 오류가 발생할 일이 없다 -> Relay로 쓸 수 있다
                var data = owner.recent.value 
                data.append(value)
                
                owner.recent.accept(data)
                
            }
            .disposed(by: disposeBag)
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieCell")
        tableView.backgroundColor = .green
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionCell")
        collectionView.backgroundColor = .red
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
    }
     
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
   
}
