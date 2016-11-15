//
//  SunView.swift
//  Pace
//
//  Created by Joey on 11/13/16.
//  Copyright © 2016 NelsonJE. All rights reserved.
//

import UIKit

class SunView: UIView, CAAnimationDelegate {
    
    // MARK: Properties
    var state = SunState.Morning
    
    // Sun/Moon and accessories
    var sun = UIView()
    let crescent = UIImageView()
    var verticalBar = UIView()
    var horizontalBar = UIView()
    var forwardBar = UIView()
    var backwardBar = UIView()
    var smallRing = UIView()
    var largeRing = UIView()
    
    // Gradient
    var gradientLayer = CAGradientLayer()
    var currentGradientColors = [CGColor]()
    
    // Mountains
    var backMountain = UIView()
    var midMountain = UIView()
    var frontMountain = UIView()
    
    // Constants
    let sunSize:CGFloat = 110
    let mountainSize:CGFloat = 250
    let sunTopBuffer:CGFloat = 50
    let sunBottomBuffer:CGFloat = 150
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let barWidth: CGFloat = 8
    let barHeight:CGFloat = 150
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        configureSubviews()
        applyConstraints()
    }
    
    
    // MARK: View Configuration
    private func configureSubviews(){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = gradientColorsForState(state: state)
        currentGradientColors = gradientColorsForState(state: state)
        layer.insertSublayer(gradientLayer, at: 0)
        
        sun.layer.cornerRadius = sunSize / 2
        sun.backgroundColor = sunColorForState(state: state)
        
        crescent.image = #imageLiteral(resourceName: "Crescent")
        crescent.contentMode = .scaleAspectFit
        crescent.alpha = crescentAlphaForState(state: state)
        
        setMountainColors(mtColors: mountainColorForState(state: state))
        
        backMountain.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
        midMountain.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
        frontMountain.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))

        barTransformForState(state: state)
        
        forwardBar.backgroundColor = sun.backgroundColor
        backwardBar.backgroundColor = sun.backgroundColor
        horizontalBar.backgroundColor = sun.backgroundColor
        verticalBar.backgroundColor = sun.backgroundColor
        
        forwardBar.layer.cornerRadius = 4
        backwardBar.layer.cornerRadius = 4
        horizontalBar.layer.cornerRadius = 4
        verticalBar.layer.cornerRadius = 4
        
        smallRing.layer.cornerRadius = sunSize
        largeRing.layer.cornerRadius = (sunSize * 3) / 2

        setRingTransformForState(state: state)
        setRingAlpha(alpha: ringAlphaForState(state: state))
        setRingColor()
        
        sun.translatesAutoresizingMaskIntoConstraints = false
        backMountain.translatesAutoresizingMaskIntoConstraints = false
        midMountain.translatesAutoresizingMaskIntoConstraints = false
        frontMountain.translatesAutoresizingMaskIntoConstraints = false
        crescent.translatesAutoresizingMaskIntoConstraints = false
        forwardBar.translatesAutoresizingMaskIntoConstraints = false
        backwardBar.translatesAutoresizingMaskIntoConstraints = false
        verticalBar.translatesAutoresizingMaskIntoConstraints = false
        horizontalBar.translatesAutoresizingMaskIntoConstraints = false
        smallRing.translatesAutoresizingMaskIntoConstraints = false
        largeRing.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(sun)
        addSubview(backMountain)
        addSubview(midMountain)
        addSubview(frontMountain)
        sun.addSubview(crescent)
        sun.addSubview(forwardBar)
        sun.addSubview(backwardBar)
        sun.addSubview(verticalBar)
        sun.addSubview(horizontalBar)
        sun.addSubview(smallRing)
        sun.addSubview(largeRing)
        
        sun.sendSubview(toBack: forwardBar)
        sun.sendSubview(toBack: backwardBar)
        sun.sendSubview(toBack: verticalBar)
        sun.sendSubview(toBack: horizontalBar)
    }
    
    
    //MARK: Constraints
    private func applyConstraints() {
        let margins = layoutMarginsGuide
        
        sun.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        sun.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -sunBottomBuffer).isActive = true
        sun.widthAnchor.constraint(equalToConstant: sunSize).isActive = true
        sun.heightAnchor.constraint(equalToConstant: sunSize).isActive = true
        
        smallRing.centerXAnchor.constraint(equalTo: sun.centerXAnchor).isActive = true
        smallRing.centerYAnchor.constraint(equalTo: sun.centerYAnchor).isActive = true
        smallRing.widthAnchor.constraint(equalToConstant: sunSize * 2).isActive = true
        smallRing.heightAnchor.constraint(equalToConstant: sunSize * 2).isActive = true
        
        largeRing.centerXAnchor.constraint(equalTo: sun.centerXAnchor).isActive = true
        largeRing.centerYAnchor.constraint(equalTo: sun.centerYAnchor).isActive = true
        largeRing.widthAnchor.constraint(equalToConstant: sunSize * 3).isActive = true
        largeRing.heightAnchor.constraint(equalToConstant: sunSize * 3).isActive = true
        
        crescent.bottomAnchor.constraint(equalTo: sun.bottomAnchor, constant: 0.5).isActive = true
        crescent.leftAnchor.constraint(equalTo: sun.leftAnchor, constant: -1).isActive = true
        crescent.widthAnchor.constraint(equalToConstant: 86).isActive = true
        crescent.heightAnchor.constraint(equalToConstant: 101).isActive = true
        
        verticalBar.centerXAnchor.constraint(equalTo: sun.centerXAnchor).isActive = true
        verticalBar.centerYAnchor.constraint(equalTo: sun.centerYAnchor).isActive = true
        verticalBar.widthAnchor.constraint(equalToConstant: barWidth).isActive = true
        verticalBar.heightAnchor.constraint(equalToConstant: barHeight).isActive = true
        
        horizontalBar.centerXAnchor.constraint(equalTo: sun.centerXAnchor).isActive = true
        horizontalBar.centerYAnchor.constraint(equalTo: sun.centerYAnchor).isActive = true
        horizontalBar.widthAnchor.constraint(equalToConstant: barWidth).isActive = true
        horizontalBar.heightAnchor.constraint(equalToConstant: barHeight).isActive = true
        
        forwardBar.centerXAnchor.constraint(equalTo: sun.centerXAnchor).isActive = true
        forwardBar.centerYAnchor.constraint(equalTo: sun.centerYAnchor).isActive = true
        forwardBar.widthAnchor.constraint(equalToConstant: barWidth).isActive = true
        forwardBar.heightAnchor.constraint(equalToConstant: barHeight).isActive = true
        
        backwardBar.centerXAnchor.constraint(equalTo: sun.centerXAnchor).isActive = true
        backwardBar.centerYAnchor.constraint(equalTo: sun.centerYAnchor).isActive = true
        backwardBar.widthAnchor.constraint(equalToConstant: barWidth).isActive = true
        backwardBar.heightAnchor.constraint(equalToConstant: barHeight).isActive = true
        
        backMountain.centerYAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        backMountain.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        backMountain.widthAnchor.constraint(equalToConstant: mountainSize).isActive = true
        backMountain.heightAnchor.constraint(equalToConstant: mountainSize).isActive = true
        
        midMountain.topAnchor.constraint(equalTo: backMountain.topAnchor, constant: 20).isActive = true
        midMountain.centerXAnchor.constraint(equalTo: backMountain.centerXAnchor, constant: -100).isActive = true
        midMountain.widthAnchor.constraint(equalToConstant: mountainSize).isActive = true
        midMountain.heightAnchor.constraint(equalToConstant: mountainSize).isActive = true
        
        frontMountain.topAnchor.constraint(equalTo: backMountain.topAnchor, constant: 50).isActive = true
        frontMountain.centerXAnchor.constraint(equalTo: backMountain.centerXAnchor, constant: 130).isActive = true
        frontMountain.widthAnchor.constraint(equalToConstant: mountainSize).isActive = true
        frontMountain.heightAnchor.constraint(equalToConstant: mountainSize).isActive = true
    }
    
    //MARK: Animations
    func moveSun(point: CGPoint) {
        sun.center = CGPoint(x: screenWidth / 2, y: point.y)

        if sun.frame.origin.y < sunTopBuffer {
            sun.center = CGPoint(x: screenWidth / 2, y: (sunSize / 2) + sunTopBuffer)
        } else if sun.frame.maxY > screenHeight - sunBottomBuffer {
            sun.center = CGPoint(x: screenWidth / 2, y: (screenHeight - sunSize / 2) - sunBottomBuffer)
        }
        
        animateWithOffset(offset:point.y)
    }
    
    func animateWithOffset(offset: CGFloat) {
        let percent = (offset - sunTopBuffer - (sunSize / 2))/(screenHeight - (sunTopBuffer + sunBottomBuffer + sunSize))
        
        if percent < 0 || percent > 1.0 {
            return
        }
        
        animateColors(percent: percent)
        animateSunAccessory(percent: percent)
    }
    
    func animateColors(percent: CGFloat) {
        var tempPercent = percent * 2
        var fromState = SunState.Morning
        var toState = SunState.Morning
        
        if percent <= 0.5 {
            tempPercent = percent * 2
            fromState = .Night
            toState = .Noon
        }
        else {
            tempPercent = (percent - 0.5) * 2
            fromState = .Noon
            toState = .Morning
        }
        
        let fromSun = sunColorForState(state: fromState)
        let toSun = sunColorForState(state: toState)
        let fromGradient = gradientColorsForState(state: fromState)
        let toGradient = gradientColorsForState(state: toState)
        let fromMountainColors = mountainColorForState(state: fromState)
        let toMountainColors = mountainColorForState(state: toState)
        
        let mountainColors = [transitionColorToColor(fromMountainColors[0], toColor: toMountainColors[0], percent: tempPercent),
                              transitionColorToColor(fromMountainColors[1], toColor: toMountainColors[1], percent: tempPercent),
                              transitionColorToColor(fromMountainColors[2], toColor: toMountainColors[2], percent: tempPercent)]
        
        let topColor = transitionColorToColor(UIColor(cgColor: fromGradient[0]), toColor: UIColor(cgColor: toGradient[0]), percent: tempPercent)
        let bottomColor = transitionColorToColor(UIColor(cgColor: fromGradient[1]), toColor: UIColor(cgColor: toGradient[1]), percent: tempPercent)
        gradientLayer.removeFromSuperlayer()
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)
        
        currentGradientColors = [topColor.cgColor, bottomColor.cgColor]
        sun.backgroundColor = transitionColorToColor(fromSun, toColor: toSun, percent: tempPercent)
        setRingColor()
        setBarColor(color: sun.backgroundColor!)
        setMountainColors(mtColors: mountainColors)
    }
    
    func animateSunAccessory(percent: CGFloat) {
        if percent > 0.667 { //morning animations
            let tempPercent = (percent - 0.667) * 3
            setRingAlpha(alpha: tempPercent * 0.08)
            
            let shrink = CGAffineTransform(scaleX: tempPercent, y: tempPercent)
            smallRing.transform = shrink
            largeRing.transform = shrink
            
        } else if percent < 0.334 { //night animation
            crescent.alpha = 1 - percent - 0.7
        } else { //noon animations
            var tempPercent = (percent - 0.334) * 3
            
            if tempPercent < 0.5 {
                tempPercent = tempPercent + 0.5
            } else {
                tempPercent = 1 - (tempPercent - 0.5)
            }
            
            let stretch = CGAffineTransform(scaleX: tempPercent, y: tempPercent)
            verticalBar.transform = stretch
            forwardBar.transform = stretch.rotated(by: CGFloat(M_PI_4))
            backwardBar.transform = stretch.rotated(by: CGFloat(-M_PI_4))
            horizontalBar.transform = CGAffineTransform(scaleX: tempPercent, y: tempPercent).rotated(by: CGFloat(M_PI_2))
        }
    }
    
    func sunToNearestStop() {
        let percent = (sun.center.y - sunTopBuffer - (sunSize / 2))/(screenHeight - (sunTopBuffer + sunBottomBuffer + sunSize))
        var yCoord: CGFloat = 0
        var toColors = [CGColor]()
        var toState = SunState.Morning
        
        if percent < 0.33 {
            toState = .Night
            yCoord = sunTopBuffer + (sunSize / 2)
        } else if percent > 0.66 {
            toState = .Morning
            yCoord = screenHeight - sunBottomBuffer - (sunSize / 2)
        } else {
            toState = .Noon
            yCoord = (screenHeight / 2) - sunTopBuffer
        }
        
        toColors = gradientColorsForState(state: toState)
        let fromColors = currentGradientColors
        
        self.gradientLayer.colors = toColors as [AnyObject]
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = 0.25
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.delegate = self
        self.gradientLayer.add(animation, forKey:"animateGradient")
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseIn, .allowUserInteraction], animations: {
            self.sun.backgroundColor = self.sunColorForState(state: toState)
            self.setBarColor(color: self.sunColorForState(state: toState))
            self.sun.center = CGPoint(x: self.screenWidth / 2, y: yCoord)
            self.barTransformForState(state: toState)
            self.crescent.alpha = self.crescentAlphaForState(state: toState)
            self.setMountainColors(mtColors: self.mountainColorForState(state: toState))
            self.setRingAlpha(alpha: self.ringAlphaForState(state: toState))
            self.setRingTransformForState(state: toState)
        }, completion: nil)
    }
    
    //MARK: Helper methods
    func gradientColorsForState(state: SunState) -> [CGColor] {
        switch state {
        case .Morning:
            return [UIColor.fromHex(rgbValue: 0x7A4287).cgColor, UIColor.fromHex(rgbValue: 0x9E8EA2).cgColor]
        case .Noon:
            return [UIColor.fromHex(rgbValue: 0x43B0CE).cgColor, UIColor.fromHex(rgbValue: 0xC7CDD0).cgColor]
        case .Night:
            return [UIColor.fromHex(rgbValue: 0x934644).cgColor, UIColor.fromHex(rgbValue: 0xFFB970).cgColor]
        }
    }
    
    func sunColorForState(state: SunState) -> UIColor {
        switch state {
        case .Morning:
            return UIColor.fromHex(rgbValue: 0xFFE36C)
        case .Noon:
            return UIColor.fromHex(rgbValue: 0xFFE7B4)
        case .Night:
            return UIColor.lightGray
        }
    }
    
    /// returns [frontColor, midColor, backColor]
    func mountainColorForState(state: SunState) -> [UIColor] {
        switch state {
        case .Morning:
            return [UIColor.fromHex(rgbValue: 0x776B5F), UIColor.fromHex(rgbValue: 0x62564A), UIColor.fromHex(rgbValue: 0x463C32)]
        case .Noon:
            return [UIColor.fromHex(rgbValue: 0xDCB280), UIColor.fromHex(rgbValue: 0xD5A06A), UIColor.fromHex(rgbValue: 0xDF9B5C)]
        case .Night:
            return [UIColor.fromHex(rgbValue: 0x88694C), UIColor.fromHex(rgbValue: 0x664D35), UIColor.fromHex(rgbValue: 0x483523)]
        }
    }
    
    func crescentAlphaForState(state: SunState) -> CGFloat {
        switch state {
        case .Morning, .Noon:
            return 0.0
        case .Night:
            return 0.25
        }
    }
    
    func ringAlphaForState(state: SunState) -> CGFloat {
        switch state {
        case .Night, .Noon:
            return 0.0
        case .Morning:
            return 0.08
        }
    }
    
    func setRingTransformForState(state: SunState) {
        var transform = CGAffineTransform()
        switch state {
        case .Night, .Noon:
            transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        case .Morning:
            transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        smallRing.transform = transform
        largeRing.transform = transform
    }
    
    func barTransformForState(state: SunState) {
        var stretch = CGAffineTransform(scaleX: 0.0, y: 0.0)
        switch state {
        case .Morning, .Night:
            stretch = CGAffineTransform(scaleX: 0.0, y: 0.0)
        case .Noon:
            stretch = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        verticalBar.transform = stretch
        forwardBar.transform = stretch.rotated(by: CGFloat(M_PI_4))
        backwardBar.transform = stretch.rotated(by: CGFloat(-M_PI_4))
        horizontalBar.transform = stretch.rotated(by: CGFloat(M_PI_2))
    }
    
    func setBarColor(color: UIColor) {
        forwardBar.backgroundColor = color
        backwardBar.backgroundColor = color
        horizontalBar.backgroundColor = color
        verticalBar.backgroundColor = color
    }
    
    func setMountainColors(mtColors: [UIColor]) {
        frontMountain.backgroundColor = mtColors[0]
        midMountain.backgroundColor = mtColors[1]
        backMountain.backgroundColor = mtColors[2]
    }
    
    func setRingColor() {
        smallRing.backgroundColor = sun.backgroundColor
        largeRing.backgroundColor = sun.backgroundColor
    }
    
    func setRingAlpha(alpha: CGFloat) {
        smallRing.alpha = alpha
        largeRing.alpha = alpha
    }
    
    func transitionColorToColor(_ fromColor: UIColor, toColor: UIColor, percent: CGFloat) -> UIColor{
        let fromRGB = fromColor.rgb()!
        let toRGB = toColor.rgb()!
        let red = fromRGB.red + (percent * (toRGB.red - fromRGB.red))
        let green = fromRGB.green + (percent * (toRGB.green - fromRGB.green))
        let blue = fromRGB.blue + (percent * (toRGB.blue - fromRGB.blue))
        
        return UIColor(red: red/256, green: green/256, blue: blue/256, alpha: 1.0)
    }
}

enum SunState {
   case Morning, Noon, Night
}

extension UIColor{
    class func fromHex(rgbValue:UInt32, alpha:Double=1.0) -> UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func rgb() -> (red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = CGFloat(fRed * 255.0)
            let iGreen = CGFloat(fGreen * 255.0)
            let iBlue = CGFloat(fBlue * 255.0)
            let iAlpha = CGFloat(fAlpha * 255.0)
            
            return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}
