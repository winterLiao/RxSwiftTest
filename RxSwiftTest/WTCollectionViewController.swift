//
//  WTCollectionViewController.swift
//  RxSwiftTest
//
//  Created by 廖文韬 on 2018/8/13.
//  Copyright © 2018年 廖文韬. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class WTCollectionViewController: UIViewController {

    let disposeBag = DisposeBag()

    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = Observable.just([
            SectionModel(model: "吴亦凡战队", items:
                ["那吾克热","王以太","blow fever"]),
            SectionModel(model: "热狗队", items:
                ["功夫胖","派克特","刘柏辛"]),
            SectionModel(model: "潘玮柏战队", items:
                ["ICE","周汤豪","艾热"]),
            ])
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 70)
        flowLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 40)
        self.collectionView.setCollectionViewLayout(flowLayout, animated: true)
        
        self.collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Section")
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String,String>>(
            configureCell:  { (dataSource, collectionView, indexPath, element) -> UICollectionViewCell in
            let cell : CollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionCell
            cell.label.text = element
                return cell},
            configureSupplementaryView: {(dataSource ,collectionView, kind, indexPath) in
                let section = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                  withReuseIdentifier: "Section", for: indexPath) as! SectionHeader
                section.label.text = "\(dataSource[indexPath.section].model)"
                return section}
        )
        
        items.bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(String.self).subscribe(onNext:{item in
            print("为\(item)投上一票")
        })
            .disposed(by: disposeBag)

    }


}

extension WTCollectionViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 30) / 3, height: 50)
    }
}


class CollectionCell : UICollectionViewCell{
    
    var label : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.green
        
        label = UILabel(frame: frame)
        label.textColor = UIColor.black
        label.textAlignment = .center
        self.contentView.addSubview(label)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SectionHeader : UICollectionReusableView{
    var label : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.orange
        label = UILabel(frame: frame)
        label.textColor = UIColor.white
        label.textAlignment = .center
        self.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

