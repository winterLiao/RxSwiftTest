//
//  WTButtonViewController.swift
//  RxSwiftTest
//
//  Created by 廖文韬 on 2018/7/31.
//  Copyright © 2018年 廖文韬. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class WTButtonViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var switchs: UISwitch!
    
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button1: UIButton!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.rx.tap.subscribe(onNext:{ [weak self] in
            self?.showMessage(text: "按钮被点击啦")
        })
            .disposed(by: disposeBag)
        
        
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        timer.map { "\($0)"     }
            .bind(to: button.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        let timer2 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        timer2.map{
            let imageName = ( $0 % 2 == 0 ? "navBack1" : "navBack3" )
            return UIImage.init(named: imageName)!
        }
            .bind(to: button.rx.image())
            .disposed(by:disposeBag)
        
        
        //将按钮放入数组中，并进行强制解包
        let buttons = [button1,button2,button3].map({$0!})
        button1.isSelected = true
        
        //创建一个可观察序列，它可以发送最后一次点击的按钮（也就是我们需要选中的按钮）
        let selectButton = Observable.from(buttons.map({button in button.rx.tap.map{return button}}))
                                     .merge()

        //遍历按钮对selectedButton进行订阅，根据它是否是当前选中的按钮绑定isSelected属性
        for btn in buttons {
            selectButton.map {$0 == btn}
            .bind(to: btn.rx.isSelected)
            .disposed(by: disposeBag)
        }
        
        //UISwitch
        switchs.rx.isOn.bind(to: button1.rx.isEnabled)
            .disposed(by: disposeBag)
        
        switchs.rx.isOn.asObservable()
            .subscribe(onNext:{[weak self] in
                print("开关状态:\($0)")
                self?.button2.isEnabled = $0
            })
            .disposed(by: disposeBag)
    }
    
    func showMessage(text : String){
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "哦", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

}
