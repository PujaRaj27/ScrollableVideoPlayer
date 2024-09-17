//
//  ViewController.swift
//  ScrollableVideoPlayer
//
//  Created by PujaRaj on 16/09/24.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var collectionView: UICollectionView!
    var flicks = [Flick]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load flicks from JSON
        flicks = loadFlicks()
        // Setup CollectionView layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 600)
        layout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.isPagingEnabled = true
        view.addSubview(collectionView)
    }
  
    
    func loadFlicks() -> [Flick]{
        guard let url = Bundle.main.url(forResource: "Flicks", withExtension: "json"),
                  let data = try? Data(contentsOf: url),
                  let welcome = try? JSONDecoder().decode(ScrollableVideo.self, from: data) else {
                return []
            }
        return welcome.flicks
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flicks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
        let items = flicks[indexPath.item].arr
        cell.configure(with: items)
        return cell
    }

    // Play videos only for the currently visible cell
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            if let myCell = cell as? MyCell {
                myCell.startVideoPlaybackCycle(items: flicks[collectionView.indexPath(for: myCell)!.item].arr)
            }
        }
    }
}

