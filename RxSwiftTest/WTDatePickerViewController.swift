//
//  WTPickerViewController.swift
//  RxSwiftTest
//
//  Created by 廖文韬 on 2018/8/2.
//  Copyright © 2018年 廖文韬. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WTDatePickerViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var timerPicker: UIDatePicker!
    @IBOutlet weak var startButton: UIButton!
    //剩余时间
    let leftTime = Variable(TimeInterval(180))
    //当前倒计时是否结束
    let countDownStopped = Variable(true)
    
    lazy var dateFormater : DateFormatter  = {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy年MM月dd日 HH:mm"
        return formater
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.rx.date
            .map{ [weak self] in
                "选中的时间:"  + self!.dateFormater.string(from: $0)
            }
            .bind(to:label.rx.text)
            .disposed(by: disposeBag)
        
        
        //倒计时
        //双向绑定
        DispatchQueue.main.async {
            _ = self.timerPicker.rx.countDownDuration <-> self.leftTime
        }
        
        Observable.combineLatest(leftTime.asObservable(),countDownStopped.asObservable()){
            leftTimeVlaue,countDownStoppedValue in
            if countDownStoppedValue{
                return "开始"
            }else{
                return "倒计时开始，还有 \(Int(leftTimeVlaue)) 秒..."
            }
        }.bind(to: startButton.rx.title())
        .disposed(by: disposeBag)
        
        //倒计时开始不能点击按钮和时间选择
        countDownStopped.asDriver().drive(timerPicker.rx.isEnabled).disposed(by: disposeBag)
        countDownStopped.asDriver().drive(startButton.rx.isEnabled).disposed(by: disposeBag)

        
        startButton.rx.tap.subscribe(onNext:{[weak self] in
            self?.startClicked()
        })
            .disposed(by: disposeBag)

    }
    
    func startClicked(){
        self.countDownStopped.value = false
        //创建一个计时器
        Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .takeUntil(countDownStopped.asObservable().filter({$0}))
            .subscribe{ event in
                self.leftTime.value -= 1
                if self.leftTime.value == 0{
                    self.countDownStopped.value = true
                    self.leftTime.value = 180
                }
        }.disposed(by: disposeBag)
    }
}
