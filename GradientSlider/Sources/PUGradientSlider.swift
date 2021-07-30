//
//  PUGradientSlider.swift
//  GradientSlider
//
//  Created by Payal U on 20/01/21.
//

import Foundation
import UIKit

public class PUGradientSlider {
    private var tgl = CAGradientLayer()
    public var startColorCGColor: CGColor = UIColor.red.cgColor
    public var endColorCGColor: CGColor = UIColor.yellow.cgColor
    public init() {}
    public func setSlider(slider:UISlider) {
        
        let frame = CGRect(x: 0.0, y: 0.0, width: slider.bounds.width, height: 12.0 )
        tgl.frame = frame
        
        tgl.colors = [startColorCGColor, endColorCGColor]
        
        tgl.borderWidth = 1.5
        tgl.borderColor = UIColor.white.cgColor
        
        
        tgl.endPoint = CGPoint(x: 1.0, y:  1.0)
        tgl.startPoint = CGPoint(x: 0.0, y:  1.0)
        tgl.masksToBounds = true
        tgl.cornerRadius = 6.0
        
        UIGraphicsBeginImageContextWithOptions(tgl.frame.size, false, 0.0)
        tgl.render(in: UIGraphicsGetCurrentContext()!)
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        DispatchQueue.main.async {
            slider.setMaximumTrackImage(backgroundImage?.resizableImage(withCapInsets: .zero, resizingMode: .stretch),  for: .normal)
            slider.setMinimumTrackImage(backgroundImage?.resizableImage(withCapInsets:.zero, resizingMode: .stretch),  for: .normal)
            
        }
        
        let layerFrame = CGRect(x: 0, y: 0, width: 25.0, height: 25.0)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = CGPath(rect: layerFrame, transform: nil)
        shapeLayer.fillColor = UIColor.white.cgColor
        
        let thumb = CALayer.init()
        thumb.frame = layerFrame
        thumb.cornerRadius = layerFrame.width / 2
        thumb.addSublayer(shapeLayer)
        
        UIGraphicsBeginImageContextWithOptions(thumb.frame.size, false, 0.0)
        
        thumb.render(in: UIGraphicsGetCurrentContext()!)
        var thumbImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        thumbImage = thumbImage!.rounded(with: UIColor.gray, width: 1.5)
        slider.setThumbImage(thumbImage, for: .normal)
        slider.setThumbImage(thumbImage, for: .highlighted)
        slider.clipsToBounds = true
        
    }
    
    public func getColor(point: CGFloat) -> UIColor {
        
        let startPoint = tgl.startPoint
        let endPoint = tgl.endPoint
        
        if point == 1 {
            return UIColor(cgColor: endColorCGColor)
        }
        if point == 0 {
            return UIColor(cgColor: startColorCGColor)
        }
        
        let x = (endPoint.x - (point)) / (endPoint.x - startPoint.x)
        
        if let start = tgl.colors?.first,
           let end = tgl.colors?.last {
            
            let startColorCGColor = start as! CGColor
            let endColorCGColor = end as! CGColor
            
            let startColor = UIColor(cgColor: startColorCGColor)
            let endColor = UIColor(cgColor: endColorCGColor)
            
            var startR: CGFloat = 0
            var startG: CGFloat = 0
            var startB: CGFloat = 0
            var endR: CGFloat = 0
            var endG: CGFloat = 0
            var endB: CGFloat = 0
            startColor.getRed(&startR, green: &startG, blue: &startB, alpha: nil)
            endColor.getRed(&endR, green: &endG, blue: &endB, alpha: nil)
            
            let r,g,b: CGFloat
            
            if x <= 0 {
                r = startR
                g = startG
                b = startB
            } else if x >= 1 {
                r = endR
                g = endG
                b = endB
            } else {
                r = x * startR + (1.0 - x) * endR
                g = x * startG + (1.0 - x) * endG
                b = x * startB + (1.0 - x) * endB
            }
            
            return UIColor(red: r, green: g, blue: b, alpha: 1)
        }
        return .clear
    }
}
extension UIImage {
    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize  { .init(width: breadth, height: breadth) }
    var breadthRect: CGRect  { .init(origin: .zero, size: breadthSize) }
    func rounded(with color: UIColor, width: CGFloat) -> UIImage? {
        
        guard let cgImage = cgImage?.cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : .zero, y: isPortrait ? ((size.height-size.width)/2).rounded(.down) : .zero), size: breadthSize)) else { return nil }
        
        let bleed = breadthRect.insetBy(dx: -width, dy: -width)
        let format = imageRendererFormat
        format.opaque = false
        
        return UIGraphicsImageRenderer(size: bleed.size, format: format).image { context in
            UIBezierPath(ovalIn: .init(origin: .zero, size: bleed.size)).addClip()
            var strokeRect =  breadthRect.insetBy(dx: -width/2, dy: -width/2)
            strokeRect.origin = .init(x: width/2, y: width/2)
            UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation)
                .draw(in: strokeRect.insetBy(dx: width/2, dy: width/2))
            context.cgContext.setStrokeColor(color.cgColor)
            let line: UIBezierPath = .init(ovalIn: strokeRect)
            line.lineWidth = width
            line.stroke()
        }
    }
}
extension UIImage {
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}
