//
//  ViewController.swift
//  RxSwiftTest
//
//  Created by 廖文韬 on 2018/7/27.
//  Copyright © 2018年 廖文韬. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var eidtButton: UIBarButtonItem!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var dataItem = ["UILabel的使用","UIbutton、UISwitch的使用","UITextField的使用","UITextView的使用","其他UI控件的使用","UIGesture的使用","UIDatePicker的使用","UIPickerView的使用","UICollectionView的使用"]
        let vcName = ["WTLabelVC","WTButtonVC","WTTextFieldVC","WTTextViewVC","WTOtherViewVC","WTGestureViewVC","WTPickerVC","WTPickerViewVC","WTCollectionViewVC"]
        let items = Observable.just([SectionModel(model: "",
                                                  items: dataItem)])
        
        var isEditing = false
        eidtButton.rx.tap
            .subscribe(onNext:{[weak self] in
                isEditing = !isEditing
                if isEditing {
                    self?.eidtButton.title = "取消"
                }else{
                    self?.eidtButton.title = "编辑"
                }
                self?.tableView.isEditing = isEditing
            })
            .disposed(by: disposeBag)
        
        let dataSouce = RxTableViewSectionedReloadDataSource<SectionModel<String,String>>(configureCell:{ (dataSouece, tv, indexPath, element) -> UITableViewCell in
            let cell = tv.dequeueReusableCell(withIdentifier: "cell")!
            cell.textLabel?.text = element
            cell.selectionStyle = .none
            return cell
            })
        
        tableView.rx.setDelegate(self)
        .disposed(by: disposeBag)
        
        //点击选择
        tableView.rx            
            .itemSelected
            .subscribe(onNext: {indexPath in
                self.pushVC(vcName: vcName[indexPath.row],vcTitle:dataItem[indexPath.row])
            })
            .disposed(by: disposeBag)
        
        
        //删除
        dataSouce.canEditRowAtIndexPath = {item,indexPath  in
            if indexPath.row == 0 {
                return true
            }
            return false
        }
        tableView.rx.itemDeleted.subscribe(onNext :{ [weak self] indexPath in
        }).disposed(by: disposeBag)
        
        //移动
        dataSouce.canMoveRowAtIndexPath = {item,indexPath  in
            if indexPath.row == 0 {
                return true
            }
            return false
        }
        
        tableView.rx.itemMoved.subscribe(onNext: { (sourceIndexPath, destinationIndexPath) in
            }).disposed(by: disposeBag)
                

        items.bind(to: tableView.rx.items(dataSource: dataSouce))
            .disposed(by: disposeBag)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView.init()
        
        
        
        
    }

}

extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)
        -> CGFloat {
            return 60
    }
}

extension ViewController{
    func pushVC(vcName:String,vcTitle:String)  {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: vcName)
        vc.title = vcTitle
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

