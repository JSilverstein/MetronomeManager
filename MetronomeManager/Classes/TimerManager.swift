//
//  TimerManager.swift
//  Metronome
//
//  Created by Jacob Silverstein on 3/11/18.
//  Copyright © 2018 Jacob Silverstein. All rights reserved.
//

import Foundation
import AVFoundation

public protocol TimerManagerDelegate: class {
    func timerDidFire()
}

public class TimerManager {
    
    var i = 0
    public var link: CADisplayLink?
    public var currentBpm: Double?
    
    public init() {}
    
    public weak var delegate: TimerManagerDelegate?
    
    public func startTimer() {
        link?.remove(from: RunLoop.current, forMode: .defaultRunLoopMode)
        link = nil
        link = CADisplayLink.init(target: self, selector: #selector(timerDidFire))
        if #available(iOS 10.0, *) {
            link!.preferredFramesPerSecond = 60
        } else {
            // Fallback on earlier versions
        }
        link!.add(to: RunLoop.current, forMode: .defaultRunLoopMode)
    }
    
    public func stopTimer() {
        link?.remove(from: RunLoop.current, forMode: .defaultRunLoopMode)
        link = nil
    }
    
    @objc func timerDidFire() {
        i += 1
        if i > getFrames(fromBPM: currentBpm!) {
            self.delegate?.timerDidFire()
            i = 0
        }
    }
    
    public func getFrames(fromBPM bpm: Double) -> Int {
        let seconds: Double = 60 / bpm
        let frames = seconds * 60
        return Int(frames)
    }
}
