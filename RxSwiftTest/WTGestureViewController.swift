//
//  WTGestureViewController.swift
//  RxSwiftTest
//
//  Created by 廖文韬 on 2018/8/2.
//  Copyright © 2018年 廖文韬. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WTGestureViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeGesture = UISwipeGestureRecognizer()
        swipeGesture.direction = .up
        self.view.addGestureRecognizer(swipeGesture)
        
        let tapGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tapGesture)
        
        swipeGesture.rx.event
            .subscribe(onNext:{ [weak self] recognizer in
                let point = recognizer.location(in: recognizer.view)
                self?.showMessage(text: "上滑了",message: "x:\(point.x) y: \(point.y)")
            })
            .disposed(by: disposeBag)
        
        tapGesture.rx.event
            .subscribe(onNext:{ [weak self] recognizer in
                let point = recognizer.location(in: recognizer.view)
                self?.showMessage(text: "点击了",message: "x:\(point.x) y: \(point.y)")
            })
            .disposed(by: disposeBag)
        
        //另一种写法
//        gesture.rx.event
//            .bind { [weak self] recognizer in
//                //这个点是滑动的起点
//                let point = recognizer.location(in: recognizer.view)
//                self?.showMessage(text: "向上划动", message: "\(point.x) \(point.y)")
//            }
//            .disposed(by: disposeBag)
        
        
    }
    
    
    func showMessage(text : String,message:String){
        let alert = UIAlertController(title: text, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "哦", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
