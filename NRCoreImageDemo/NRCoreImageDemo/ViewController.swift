//
//  ViewController.swift
//  NRCoreImageDemo
//
//  Created by NicoRobine on 2020/6/10.
//  Copyright © 2020 NicoRobine. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var collectionView: UICollectionView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUI()
    }
    
    func initialUI() {
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NRCollectionCell.self, forCellWithReuseIdentifier: .cellIdentifier)
        view.addSubview(collectionView)
    }
    
    // MARK: - Delegate
    // MARK: UICollectionDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NRCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: .cellIdentifier, for: indexPath) as! NRCollectionCell
        if var image = UIImage(named: .testImageName) {
            
            if var ciImage = CIImage(image: image) {
                switch indexPath.row {
                case 1:
                    cell.labelView.text = "blur"
                    ciImage = blur(radius: 10.0)(ciImage)
                case 2:
                    cell.labelView.text = "generate"
                    ciImage = generate(color: UIColor.green)(ciImage)
                case 3:
                    cell.labelView.text = "overlay"
                    ciImage = overlay(color: UIColor.blue)(ciImage)
                case 4:
                    cell.labelView.text = "compose"
                    ciImage = compose(filter: blur(radius: 10.0), with: overlay(color: UIColor.green))(ciImage)
                case 5:
                    cell.labelView.text = "compose"
                    ciImage = (blur(radius: 10.0) >>> overlay(color: UIColor.green))(ciImage)
                default:
                    cell.labelView.text = "default"
                }
                image = UIImage(ciImage: ciImage)
            }
            cell.imageView.contentMode = UIView.ContentMode.scaleAspectFit
            cell.imageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width - 20)/2, height: (view.frame.size.width - 20)/2)
    }
}

class NRCollectionCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var labelView: UILabel!
    
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        imageView.contentMode = .scaleAspectFit
        labelView = UILabel(frame: CGRect(x: 0, y: 0, width: 44, height: 22))
        
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(labelView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView.frame = CGRect(origin: CGPoint(x: 4, y: 4), size: CGSize(width: bounds.size.width - 8, height: bounds.size.height - 8 - labelView.frame.size.height))
        labelView.frame = CGRect(origin: CGPoint(x: 4, y: imageView.frame.maxY + 2), size: CGSize(width: frame.size.width - 8, height: 22))
    }
}

fileprivate extension String {
    static let cellIdentifier = "cell_identifier";
    static let testImageName = "500x500"
}
