////   /*
//
//  Project: AudioPlayerApp
//  File: PlayerViewController.swift
//  Created by: Robert Bikmurzin
//  Date: 15.09.2023
//
//  Status: in progress | Decorated
//
//  */

import UIKit

class PlayerViewController: UIViewController {
    weak var model: Model? = nil
    weak var delegate: SongListScreenForPlayerVC?
    
    let trackName = UILabel()
    let authorName = UILabel()
    let slider = UISlider()
    let prevTrackBtn = UIButton()
    let nextTrackBtn = UIButton()
    let playPauseBtn = UIButton()
    let currentTimeLabel = UILabel()
    let trackDurationLabel = UILabel()
    let closeBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        if let model = model {
            model.delegate = self
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let delegate = delegate else { return }
        delegate.playerVCWillDisappear()
    }
}

// MARK: Protocol Implementation
extension PlayerViewController: PlayerViewControllerProtocolForModel {
    func trackHasEnded() {
        configureTextInfo()
    }
}

// MARK: Actions for Buttons
extension PlayerViewController {
    
    @objc func closwBtnClicked() {
        dismiss(animated: true)
    }
    
    @objc func updateSlider() {
        guard let model = model, let player = model.player else {return}
        slider.value = Float(player.currentTime)
        currentTimeLabel.text = model.durationInMinutes(player.currentTime)
    }
    
    @objc func sliderMoving() {
        guard let model = model, let player = model.player else {return}
        player.currentTime = TimeInterval(slider.value)
        player.prepareToPlay()
    }
    
    @objc func prevBtnClicked() {
        guard let model = model else { return }
        model.previousSong()
        configureTextInfo()
    }
    
    @objc func nextBtnClicked() {
        guard let model = model else { return }
        model.nextSong()
        configureTextInfo()
    }
    
    @objc func playPauseBtnClicked() {
        guard let player = model?.player else { return }
        if player.isPlaying {
            player.pause()
            playPauseBtn.setBackgroundImage(UIImage(systemName: "play"), for: .normal)
        } else {
            player.play()
            playPauseBtn.setBackgroundImage(UIImage(systemName: "pause"), for: .normal)
        }
    }
}

// MARK: Configuring View
extension PlayerViewController {
    func configureTextInfo() {
        if let model = model {
            let song = model.songs[model.currentIndex]
            trackName.text = song.trackName
            authorName.text = song.artistName
            slider.minimumValue = 0
            slider.maximumValue = Float(model.player?.duration ?? 0)
            currentTimeLabel.text = model.durationInMinutes(0)
            trackDurationLabel.text = model.durationInMinutes(model.player?.duration)
        }
    }
    
    func configureView() {
        // ----------------------
        // Adding Subviews
        // ----------------------
        view.addSubview(trackName)
        view.addSubview(authorName)
        view.addSubview(slider)
        view.addSubview(currentTimeLabel)
        view.addSubview(trackDurationLabel)
        view.addSubview(prevTrackBtn)
        view.addSubview(playPauseBtn)
        view.addSubview(nextTrackBtn)
        view.addSubview(closeBtn)
        // ----------------------
        // Activating Constraints
        // ----------------------
        trackName.translatesAutoresizingMaskIntoConstraints = false
        authorName.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        trackDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        prevTrackBtn.translatesAutoresizingMaskIntoConstraints = false
        playPauseBtn.translatesAutoresizingMaskIntoConstraints = false
        nextTrackBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        // ----------------------
        // Configure Details of Subviews
        // ----------------------
        configureTextInfo()
        trackName.font = .boldSystemFont(ofSize: 20)
        authorName.font = .systemFont(ofSize: 15)
        playPauseBtn.setBackgroundImage(UIImage(systemName: model?.player?.isPlaying ?? true ? "pause" : "play"), for: .normal)
        prevTrackBtn.setBackgroundImage(UIImage(systemName: "backward.end"), for: .normal)
        nextTrackBtn.setBackgroundImage(UIImage(systemName: "forward.end"), for: .normal)
        playPauseBtn.addTarget(self, action: #selector(playPauseBtnClicked), for: .touchUpInside)
        nextTrackBtn.addTarget(self, action: #selector(nextBtnClicked), for: .touchUpInside)
        prevTrackBtn.addTarget(self, action: #selector(prevBtnClicked), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderMoving), for: .valueChanged)
        closeBtn.setTitle("Close", for: .normal)
        closeBtn.setTitleColor(.systemBlue, for: .normal)
        closeBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closwBtnClicked), for: .touchUpInside)
        let sizeForButtons: CGFloat = view.bounds.height / 21.3
        let indentSize: CGFloat = view.bounds.height / 56.8
        // ----------------------
        // Setting Constraints
        // ----------------------
        NSLayoutConstraint.activate([
            trackName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackName.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            authorName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authorName.topAnchor.constraint(equalTo: trackName.bottomAnchor, constant: indentSize)
        ])
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: authorName.bottomAnchor, constant: indentSize * 4),
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: indentSize),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -indentSize)
        ])
        NSLayoutConstraint.activate([
            currentTimeLabel.leadingAnchor.constraint(equalTo: slider.leadingAnchor),
            currentTimeLabel.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -5),
            trackDurationLabel.trailingAnchor.constraint(equalTo: slider.trailingAnchor),
            trackDurationLabel.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -5)
        ])
        NSLayoutConstraint.activate([
            playPauseBtn.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: indentSize * 1.5),
            playPauseBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseBtn.widthAnchor.constraint(equalToConstant: sizeForButtons),
            playPauseBtn.heightAnchor.constraint(equalToConstant: sizeForButtons),
            prevTrackBtn.centerYAnchor.constraint(equalTo: playPauseBtn.centerYAnchor),
            prevTrackBtn.trailingAnchor.constraint(equalTo: playPauseBtn.leadingAnchor, constant: -indentSize * 1.5),
            prevTrackBtn.heightAnchor.constraint(equalToConstant: sizeForButtons * 0.6),
            prevTrackBtn.widthAnchor.constraint(equalToConstant: sizeForButtons * 0.6),
            nextTrackBtn.centerYAnchor.constraint(equalTo: playPauseBtn.centerYAnchor),
            nextTrackBtn.leadingAnchor.constraint(equalTo: playPauseBtn.trailingAnchor, constant: indentSize * 1.5),
            nextTrackBtn.heightAnchor.constraint(equalToConstant: sizeForButtons * 0.6),
            nextTrackBtn.widthAnchor.constraint(equalToConstant: sizeForButtons * 0.6)
        ])
        NSLayoutConstraint.activate([
            closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: indentSize),
            closeBtn.leadingAnchor .constraint(equalTo: view.leadingAnchor, constant: indentSize),
        ])
    }
}
