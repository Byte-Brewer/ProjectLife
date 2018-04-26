//
//  LifeCollectionViewController.swift
//  ProjectLife
//
//  Created by Nazar on 26.04.18.
//  Copyright © 2018 Nazar. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class LifeCollectionViewController: UICollectionViewController {
    
    let numberOfCell: Int = 299
    
    var dictionaryOfColor: [Int: Bool] = [:]
    
    var i = 0
    
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        createdColorArray()
        changeState()
        startTimet()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return numberOfCell
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        cell.contentView.backgroundColor = !dictionaryOfColor[indexPath.row]! ? UIColor.yellow : UIColor.blue
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        startAgain()
    }
    
    func createdColorArray() {
        for i in 0 ..< self.numberOfCell {
            dictionaryOfColor[i] = random()
        }
    }

    func random() -> Bool {
        return arc4random() % 4 == 0
    }
    
    func getNeighbors(indexPath: Int) -> [Int] {
        var arrayOfNeighbors: [Int] = []
        let k = 13
        arrayOfNeighbors.append(indexPath - k - 1)
        arrayOfNeighbors.append(indexPath - k)
        arrayOfNeighbors.append(indexPath - k + 1)
        arrayOfNeighbors.append(indexPath - 1)
        arrayOfNeighbors.append(indexPath + 1)
        arrayOfNeighbors.append(indexPath + k - 1)
        arrayOfNeighbors.append(indexPath + k)
        arrayOfNeighbors.append(indexPath + k + 1)
        return arrayOfNeighbors.filter({ $0 >= 0 && $0 < self.numberOfCell })
    }
    
    @objc func changeState() {
        var temp: [Int : Bool] = self.dictionaryOfColor
        print(i)
        for (cell, color) in dictionaryOfColor {
            let arrayOfColor = getArrayOfBool(neibors: getNeighbors(indexPath: cell))
            if !color {
                temp[cell] = (arrayOfColor.filter({ $0 == true }).count == 3)
            } else {
                let countLive = arrayOfColor.filter({ $0 == true }).count
                temp[cell] = ((countLive >= 2) && (countLive <= 3))
            }
        }
        
        guard self.dictionaryOfColor != temp else {
            startAgain()
            alertPresent()
            return
        }
        self.dictionaryOfColor = temp
        self.collectionView?.reloadData()
        i = i + 1
        
    }

    func getArrayOfBool(neibors: [Int]) -> [Bool] {
        var arrayBool: [Bool] = []
        for boolCol in neibors {
            arrayBool.append(self.dictionaryOfColor[boolCol]!)
        }
        return arrayBool
    }
    
    func startTimet() {
         timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(changeState), userInfo: nil, repeats: true)
    }
    
    func startAgain() {
        print("Touch")
        if !timer.isValid {
            i = 1
            createdColorArray()
            startTimet()
            print("Touch  Start")
        } else {
            timer.invalidate()
            print("Touch  Finish")
        }
    }
    
    func alertPresent() {
        let alert = UIAlertController(title: "Зупинено!", message: "Умови життя не дозволяють продовжувати", preferredStyle: UIAlertControllerStyle.alert)
        let  ok  = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
}
