//
//  SunViewController.swift
//  Pace
//
//  Created by Joey on 11/13/16.
//  Copyright © 2016 NelsonJE. All rights reserved.
//

import UIKit

class SunViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK: Properties
    let sunView = SunView()
    
    override func viewDidLoad() {
        view = sunView
        sunView.sun.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(sunMoved(_:))))
    }
    
    func sunMoved(_ gr: UIPanGestureRecognizer) {
        switch gr.state {
        case .began:
            sunView.moveSun(point: gr.location(in: sunView))
        case .ended:
            sunView.sunToNearestStop()
        case .changed:
            sunView.moveSun(point: gr.location(in: sunView))
        default:
            return
        }
    }
}
