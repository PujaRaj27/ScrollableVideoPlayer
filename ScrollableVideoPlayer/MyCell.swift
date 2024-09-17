//
//  MyCell.swift
//  ScrollableVideoPlayer
//
//  Created by PujaRaj on 16/09/24.
//

import UIKit
import AVKit

class MyCell: UICollectionViewCell {
    var videoViews = [UIImageView]()
    var videoPlayers = [AVPlayer]()
    var currentIndex = 0
    var timer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGrid()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGrid()
    }

    func setupGrid() {
        // Create 4 UIImageViews to hold video thumbnails
        let gridSize = 2
        let videoWidth = self.frame.width / CGFloat(gridSize)
        let videoHeight = self.frame.height / CGFloat(gridSize)
        
        for i in 0..<4 {
            let row = i / gridSize
            let col = i % gridSize
            let videoView = UIImageView(frame: CGRect(x: CGFloat(col) * videoWidth, y: CGFloat(row) * videoHeight, width: videoWidth, height: videoHeight))
            videoView.contentMode = .scaleAspectFill
            videoView.clipsToBounds = true
            self.contentView.addSubview(videoView)
            videoViews.append(videoView)
        }
    }
    
    // Method to configure each cell with video data and thumbnail
    func configure(with items: [Arr]) {
        for (index, item) in items.enumerated() {
            if let url = URL(string: item.thumbnail) {
                // Load thumbnails asynchronously
                loadImageAsync(url: url) { [weak self] image in
                    self?.videoViews[index].image = image
                }
            }
        }
        startVideoPlaybackCycle(items: items)
    }

    // Load images asynchronously (Placeholder logic can be added here)
    private func loadImageAsync(url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            let image = data.flatMap { UIImage(data: $0) } ?? UIImage(named: "placeholder")
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    // Method to start video playback in sequence
    func startVideoPlaybackCycle(items: [Arr]) {
        timer?.invalidate()
        currentIndex = 0
        playNextVideo(items: items)
    }

    // Play the next video in sequence
    private func playNextVideo(items: [Arr]) {
        guard currentIndex < items.count else { return }
        
        let videoUrl = URL(string: items[currentIndex].video)!
        let player = AVPlayer(url: videoUrl)
        player.rate = 2.0 // Set playback rate to 2x
        
        // Attach player to the correct videoView
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoViews[currentIndex].bounds
        videoViews[currentIndex].layer.sublayers?.removeAll() // Clear previous video
        videoViews[currentIndex].layer.addSublayer(playerLayer)
        
        player.play()
        
        // Play for 6 seconds then move to the next video
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [weak self] in
            player.pause()
            self?.currentIndex += 1
            self?.playNextVideo(items: items)
        }
    }
}
