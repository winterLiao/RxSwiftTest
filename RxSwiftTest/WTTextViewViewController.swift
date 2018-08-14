//
//  WTTextViewViewController.swift
//  RxSwiftTest
//
//  Created by 廖文韬 on 2018/7/31.
//  Copyright © 2018年 廖文韬. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class WTTextViewViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.rx.didBeginEditing
            .subscribe(onNext:{
                print("开始编辑")
            })
            .disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .subscribe(onNext:{
                print("结束编辑")
            })
            .disposed(by: disposeBag)

        textView.rx.didChange
            .subscribe(onNext:{
                print("内容变了")
            })
            .disposed(by: disposeBag)

        textView.rx.didChangeSelection
            .subscribe(onNext:{
                print("选择内容发生变化")
            })
            .disposed(by: disposeBag)

        
    }
}
