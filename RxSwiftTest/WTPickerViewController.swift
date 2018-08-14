//
//  WTPickerViewController.swift
//  RxSwiftTest
//
//  Created by 廖文韬 on 2018/8/13.
//  Copyright © 2018年 廖文韬. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class WTPickerViewController: UIViewController {

    let disposeBag = DisposeBag()
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerView2: UIPickerView!
    
    private let adapter1 = RxPickerViewStringAdapter<[String]>(
        components: [],
        numberOfComponents: { _,_,_  in 1 },
        numberOfRowsInComponent: { (_, _, items, _) -> Int in
            return items.count},
        titleForRow: { (_, _, items, row, _) -> String? in
            return items[row]}
    )
    
    private let adapter2 = RxPickerViewStringAdapter<[[String]]>(
        components: [],
        numberOfComponents: { dataSource,pickerView,components  in components.count },
        numberOfRowsInComponent: { (_, _, components, component) -> Int in
            return components[component].count},
        titleForRow: { (_, _, components, row, component) -> String? in
            return components[component][row]}
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.just(["1","2","3"])
            .bind(to: pickerView.rx.items(adapter: adapter1))
            .disposed(by: disposeBag)
        
        Observable.just([["1","2","3"],["A","B","C"]])
            .bind(to: pickerView2.rx.items(adapter: adapter2))
            .disposed(by: disposeBag)
    }


}
