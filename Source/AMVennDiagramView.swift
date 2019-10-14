//
//  AMVennDiagramView.swift
//  AMVennDiagramView, https://github.com/adventam10/AMVennDiagramView
//
//  Created by am10 on 2018/02/12.
//  Copyright © 2018年 am10. All rights reserved.
//

import UIKit

public protocol AMVennDiagramViewDataSource: AnyObject {
    // MARK:- Required
    func vennDiagramView(_ vennDiagramView: AMVennDiagramView, fillColorForSection section: Int) -> UIColor
    func vennDiagramView(_ vennDiagramView: AMVennDiagramView, strokeColorForSection section: Int) -> UIColor
    // MARK:- Optional
    func vennDiagramView(_ vennDiagramView: AMVennDiagramView, titleForSection section: Int, value: CGFloat) -> String
    func titleForCommonArea(in vennDiagramView: AMVennDiagramView, value: CGFloat) -> String
    func vennDiagramView(_ vennDiagramView: AMVennDiagramView, textColorForSection section: Int) -> UIColor
    func textColorForCommonArea(in vennDiagramView: AMVennDiagramView) -> UIColor
    func vennDiagramView(_ vennDiagramView: AMVennDiagramView, textFontForSection section: Int) -> UIFont
    func textFontForCommonArea(in vennDiagramView: AMVennDiagramView) -> UIFont
}

public extension AMVennDiagramViewDataSource {
    func vennDiagramView(_ vennDiagramView: AMVennDiagramView, titleForSection section: Int, value: CGFloat) -> String {
        return ""
    }
    
    func titleForCommonArea(in vennDiagramView: AMVennDiagramView, value: CGFloat) -> String {
        return ""
    }
    
    func vennDiagramView(_ vennDiagramView: AMVennDiagramView, textColorForSection section: Int) -> UIColor {
        return .black
    }
    
    func textColorForCommonArea(in vennDiagramView: AMVennDiagramView) -> UIColor {
        return .black
    }
    
    func vennDiagramView(_ vennDiagramView: AMVennDiagramView, textFontForSection section: Int) -> UIFont {
        return .systemFont(ofSize: 17)
    }
    
    func textFontForCommonArea(in vennDiagramView: AMVennDiagramView) -> UIFont {
        return .systemFont(ofSize: 17)
    }
}

public class AMVennDiagramView: UIView {

    weak public var dataSource: AMVennDiagramViewDataSource?
    public var commonAreaLineColor: UIColor = .black
    
    override public var bounds: CGRect {
        didSet {
            reloadData()
        }
    }

    private let AMVErrorValue: CGFloat = -1.0
    private let AMVLabelSpace: CGFloat = 5
    private let AMVCommonAreaLabelLineLength: CGFloat = 10
    private let area1Label = UILabel()
    private let area2Label = UILabel()
    private let commonAreaLabel = UILabel()
    
    private var commonAreaLineLayer: CAShapeLayer?
    private var circle1Layer: CAShapeLayer?
    private var circle2Layer: CAShapeLayer?
    private var commonValue: CGFloat = 0.0
    private var value1: CGFloat = 0.0
    private var value2: CGFloat = 0.0
    private var distance: CGFloat = 0
    
    override public func draw(_ rect: CGRect) {
        reloadData()
    }
    
    public func setupVennDiagram(value1: CGFloat, value2: CGFloat, commonValue: CGFloat) {
        self.value1 = value1
        self.value2 = value2
        self.commonValue = commonValue
        
        reloadData()
    }
    
    public func reloadData() {
        clear()
        prepareCircleLayer()
    }
    
    private func clear() {
        distance = 0
        circle1Layer?.removeFromSuperlayer()
        circle2Layer?.removeFromSuperlayer()
        
        circle1Layer = nil
        circle2Layer = nil
        
        area1Label.removeFromSuperview()
        area2Label.removeFromSuperview()
        commonAreaLabel.removeFromSuperview()
        commonAreaLineLayer?.removeFromSuperlayer()
        commonAreaLineLayer = nil
    }
    
    private func prepareCircleLayer() {
        guard let dataSource = dataSource else {
            return
        }
        
        setupDistance()
        let rate = calculateRate()
        if rate == AMVErrorValue {
            return
        }
        
        circle1Layer = CAShapeLayer()
        circle2Layer = CAShapeLayer()
        guard let circle1Layer = circle1Layer,
            let circle2Layer = circle2Layer else {
            return
        }
        
        let radius1 = calculateRadius(area: value1) * rate
        let radius2 = calculateRadius(area: value2) * rate
        let center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        let d = distance * rate
        var x1 = center.x - radius1 - (((radius1 + d + radius2)/2) - radius1)
        var x2 = x1 + radius1 + d - radius2
        if d == abs(radius1 - radius2) {
            if radius1 < radius2 {
                x2 = center.x - radius2
                x1 = x2
            }
        }
        
        let strokeColor1 = dataSource.vennDiagramView(self, strokeColorForSection: 0)
        let fillColor1 = dataSource.vennDiagramView(self, fillColorForSection: 0)
        circle1Layer.frame = CGRect(x: x1, y: center.y - radius1, width: radius1*2, height: radius1*2)
        circle1Layer.strokeColor = strokeColor1.cgColor
        circle1Layer.fillColor = fillColor1.cgColor
        let path1 = UIBezierPath(ovalIn: circle1Layer.bounds)
        circle1Layer.path = path1.cgPath
        layer.addSublayer(circle1Layer)
        
        let strokeColor2 = dataSource.vennDiagramView(self, strokeColorForSection: 1)
        let fillColor2 = dataSource.vennDiagramView(self, fillColorForSection: 1)
        circle2Layer.frame = CGRect(x: x2, y: center.y - radius2, width: radius2*2, height: radius2*2)
        circle2Layer.strokeColor = strokeColor2.cgColor
        circle2Layer.fillColor = fillColor2.cgColor
        let path2 = UIBezierPath(ovalIn: circle2Layer.bounds)
        circle2Layer.path = path2.cgPath
        layer.addSublayer(circle2Layer)
        
        showLabels(circle1CenterX: circle1Layer.position.x,
                   circle2CenterX: circle2Layer.position.x,
                   radius1: radius1,
                   radius2: radius2,
                   distance: d)
    }
    
    private func setupDistance() {
        let valueS = value1 < value2 ? value1 : value2
        let radius1 = calculateRadius(area: value1)
        let radius2 = calculateRadius(area: value2)
        
        if commonValue == 0 {
            distance = radius1 + radius2
            return
        } else if commonValue == valueS {
            distance = abs(radius1 - radius2)
            return
        }
        
        let d = calculateDistance(radius1: radius1, radius2: radius2, totalArea: value1 + value2 - commonValue)
        distance = compensateDistance(radius1: radius1, radius2: radius2, distance: d)
    }
    
    private func calculateRate() -> CGFloat {
        if commonValue < 0 || value1 < 0 || value2 < 0 {
            print("AMVennDiagramView Error:  negative value")
            return AMVErrorValue
        }
        
        if value1 == 0.0 || value2 == 0.0 {
            print("AMVennDiagramView Error:  zero value")
            return AMVErrorValue
        }
        
        let valueL = value1 < value2 ? value2 : value1
        let valueS = value1 < value2 ? value1 : value2
        
        if valueS < commonValue {
            print("AMVennDiagramView Error: commonValue is over small value.")
            return AMVErrorValue
        }
        
        let radiusL = calculateRadius(area: valueL)
        let radiusS = calculateRadius(area: valueS)
        
        let rateW = frame.size.width / (radiusS + radiusL + distance)
        let rateH = frame.size.height / (2*radiusL)
        
        return rateW < rateH ? rateW*0.9 : rateH*0.9
    }
    
    private func calculateRadius(area: CGFloat) -> CGFloat {
        return CGFloat(sqrt(Double(area)/Double.pi))
    }
    
    //MARK:- Calculate Distance
    private func compensateDistance(radius1: CGFloat, radius2: CGFloat, distance: CGFloat) -> CGFloat {
        if distance > radius1 + radius2 {
            return radius1 + radius2
        }
        
        if distance < abs(radius1-radius2) {
            return abs(radius1-radius2) + abs(radius1-radius2)*0.2
        }
        
        return distance
    }
    
    private func calculateDistance(radius1: CGFloat, radius2: CGFloat, totalArea: CGFloat) -> CGFloat {
        let r1 = Double(radius1)
        let r2 = Double(radius2)
        let pi = Double.pi
        
        var x:Double = ((r1 + r2) + abs(r1-r2))/2
        var index:Int = 0
        while true {
            if x > r1 + r2 ||
                x < abs(r1-r2) ||
                x.isNaN ||
                index > 10000 {
                return calculateDistance2(radius1: radius1, radius2: radius2, totalArea: totalArea)
            }
            
            let cos1 = min(max((pow(r1, 2) + pow(x, 2) - pow(r2, 2)) / (2*r1*x), -0.9999), 0.9999)
            let cos2 = min(max((pow(r2, 2) + pow(x, 2) - pow(r1, 2)) / (2*r2*x), -0.9999), 0.9999)
            
            let a = 2*r1
            let b = pow(r1, 2) - pow(r2, 2)
            let f1 = calculateX(a: a, b: b, x: x, commonF: cos1)*pow(r1, 2)
            
            let c = 2*r2
            let d = pow(r2, 2) - pow(r1, 2)
            let f2 = calculateX(a: c, b: d, x: x, commonF: cos2)*pow(r2, 2)
            
            let area = pow(r1, 2) * (pi - acos(cos1) + sin(acos(cos1))*cos(acos(cos1)))
                + pow(r2, 2) * (pi - acos(cos2) + sin(acos(cos2))*cos(acos(cos2)))
            let numerator =  area - Double(totalArea)
            let denominator = f1+f2
            
            let x2 = x - (numerator/denominator)
            if abs((x2 - x)/x) < 0.0001 {
                break
            }
            x = x2
            index += 1
        }
        
        return CGFloat(x)
    }
    
    private func calculateX(a: Double, b: Double, x: Double, commonF: Double) -> Double {
        let f1 = (-1 / sqrt(1 - pow(commonF, 2))) * ((1/a) - (b/(a*pow(x, 2))))
        
        let f2a = (-2*pow(b, 2))/(pow(a, 2)*pow(x, 3))
        let f2b = (2*x)/pow(a, 2)
        let f2c = (4*pow(b, 4))/(pow(a, 4)*pow(x, 5))
        let f2d = (8*pow(b, 3))/(pow(a, 4)*pow(x, 3))
        let f2e = (-8*b*x)/pow(a, 4)
        let f2f = (-4*pow(x, 3))/pow(a, 4)
        
        let f2g = sqrt(pow(commonF, 2) - pow(commonF, 4))*2
        
        let f2 = (f2a+f2b+f2c+f2d+f2e+f2f)/f2g
        
        return f2 - f1
    }

    private func calculateDistance2(radius1: CGFloat, radius2: CGFloat, totalArea: CGFloat) -> CGFloat {
        let r1 = Double(radius1)
        let r2 = Double(radius2)
        let pi = Double.pi
        var lowX = abs(r1-r2)
        var highX = r1 + r2
        var x:Double = (lowX + highX)/2
        while true {
            if x > r1 + r2 ||
                x < abs(r1-r2) ||
                x.isNaN {
                break
            }
            
            let cos1 = min(max((pow(r1, 2) + pow(x, 2) - pow(r2, 2)) / (2*r1*x), -0.9999), 0.9999)
            let cos2 = min(max((pow(r2, 2) + pow(x, 2) - pow(r1, 2)) / (2*r2*x), -0.9999), 0.9999)
            
            let area = pow(r1, 2) * (pi - acos(cos1) + sin(acos(cos1))*cos(acos(cos1)))
                + pow(r2, 2) * (pi - acos(cos2) + sin(acos(cos2))*cos(acos(cos2)))
            let f1 =  area - Double(totalArea)
            
            if abs(f1) < 0.1 {
                break
            }
            
            if f1 > 0 {
                highX = x
            } else {
                lowX = x
            }
            x = (lowX + highX)/2
        }
        
        return CGFloat(x)
    }
    
    //MARK:- Show Labels
    private func showLabels(circle1CenterX: CGFloat, circle2CenterX: CGFloat,
                            radius1: CGFloat, radius2: CGFloat, distance: CGFloat) {
        guard let dataSource = dataSource else {
            return
        }
        
        let height = frame.size.height/3
        showArea1Label(text: dataSource.vennDiagramView(self, titleForSection: 0, value: value1),
                       textColor: dataSource.vennDiagramView(self, textColorForSection: 0),
                       font: dataSource.vennDiagramView(self, textFontForSection: 0),
                       labelHeight: height,
                       circle1CenterX: circle1CenterX,
                       circle2CenterX: circle2CenterX,
                       radius1: radius1,
                       radius2: radius2)
        
        showArea2Label(text: dataSource.vennDiagramView(self, titleForSection: 1, value: value2),
                       textColor: dataSource.vennDiagramView(self, textColorForSection: 1),
                       font: dataSource.vennDiagramView(self, textFontForSection: 1),
                       labelHeight: height,
                       circle1CenterX: circle1CenterX,
                       circle2CenterX: circle2CenterX,
                       radius1: radius1,
                       radius2: radius2)
        
        showCommonAreaLabel(text: dataSource.titleForCommonArea(in: self, value: commonValue),
                            textColor: dataSource.textColorForCommonArea(in: self),
                            font: dataSource.textFontForCommonArea(in: self),
                            labelHeight: height,
                            circle1CenterX: circle1CenterX,
                            circle2CenterX: circle2CenterX,
                            radius1: radius1,
                            radius2: radius2,
                            distance: distance)
    }
    
    private func showArea1Label(text: String, textColor: UIColor, font: UIFont,
                                labelHeight: CGFloat, circle1CenterX: CGFloat, circle2CenterX: CGFloat,
                                radius1: CGFloat, radius2: CGFloat) {
        let valueS = value1 < value2 ? value1 : value2
        var maxX = circle2CenterX - radius2
        if commonValue == valueS {
            if value1 < value2 {
                maxX = circle1CenterX + radius1
            } else if value1 == value2 {
                maxX = circle1CenterX
            }
        }
        
        area1Label.frame = CGRect(x: AMVLabelSpace,
                                  y: frame.size.height/2 - labelHeight/2,
                                  width: maxX - AMVLabelSpace*2,
                                  height: labelHeight)
        area1Label.textColor = textColor
        area1Label.text = text
        area1Label.font = font
        area1Label.textAlignment = .right
        area1Label.numberOfLines = 0
        addSubview(area1Label)
    }
    
    private func showArea2Label(text: String, textColor: UIColor, font: UIFont,
                                labelHeight: CGFloat, circle1CenterX: CGFloat, circle2CenterX: CGFloat,
                                radius1: CGFloat, radius2: CGFloat) {
        let valueS = value1 < value2 ? value1 : value2
        var minX = circle1CenterX + radius1
        if commonValue == valueS {
            if value2 < value1 {
                minX = circle2CenterX - radius2
            } else if value1 == value2 {
                minX = circle1CenterX
            }
        }
        
        let positionX = minX + AMVLabelSpace
        area2Label.frame = CGRect(x: positionX,
                                  y: frame.size.height/2 - labelHeight/2,
                                  width: frame.size.width - positionX - AMVLabelSpace,
                                  height: labelHeight)
        area2Label.textColor = textColor
        area2Label.text = text
        area2Label.font = font
        area2Label.numberOfLines = 0
        addSubview(area2Label)
    }
    
    private func showCommonAreaLabel(text: String, textColor: UIColor, font: UIFont,
                                     labelHeight: CGFloat, circle1CenterX: CGFloat, circle2CenterX: CGFloat,
                                     radius1: CGFloat, radius2: CGFloat, distance: CGFloat) {
        if text.isEmpty || commonValue == 0 {
            return
        }
        
        let valueS = value1 < value2 ? value1 : value2
        var minX = circle1CenterX + radius1
        if commonValue == valueS {
            if value2 < value1 {
                minX = circle2CenterX + 10
            } else if value1 == value2 {
                minX = circle1CenterX
            }
        }
        
        minX += AMVCommonAreaLabelLineLength
        commonAreaLabel.frame = CGRect(x: minX,
                                       y: 0,
                                       width: frame.size.width - minX,
                                       height: labelHeight)
        commonAreaLabel.textColor = textColor
        commonAreaLabel.text = text
        commonAreaLabel.font = font
        commonAreaLabel.numberOfLines = 0
        var rect = commonAreaLabel.frame
        commonAreaLabel.sizeToFit()
        rect.size.height = commonAreaLabel.frame.size.height
        if rect.size.height > labelHeight {
            rect.size.height = labelHeight
        }
        commonAreaLabel.frame = rect
        addSubview(commonAreaLabel)
        
        showCommonAreaLine(circle1CenterX: circle1CenterX,
                           circle2CenterX: circle2CenterX,
                           radius1: radius1,
                           radius2: radius2,
                           distance: distance)
    }
    
    private func showCommonAreaLine(circle1CenterX: CGFloat, circle2CenterX: CGFloat,
                                    radius1: CGFloat, radius2: CGFloat, distance: CGFloat) {
        commonAreaLineLayer = CAShapeLayer()
        guard let commonAreaLineLayer = commonAreaLineLayer else {
            return
        }
        
        commonAreaLineLayer.frame = bounds
        commonAreaLineLayer.strokeColor = commonAreaLineColor.cgColor
        commonAreaLineLayer.fillColor = UIColor.clear.cgColor
        
        let startX = calculateCommonAreaLineStartX(circle1CenterX: circle1CenterX,
                                                   circle2CenterX: circle2CenterX,
                                                   radius1: radius1,
                                                   radius2: radius2,
                                                   distance: distance)
        let endX = commonAreaLabel.frame.origin.x
        let startPoint = CGPoint(x: startX, y: frame.size.height/2)
        let point2 = CGPoint(x: endX - AMVCommonAreaLabelLineLength, y: commonAreaLabel.center.y)
        let endPoint = CGPoint(x: endX, y: commonAreaLabel.center.y)
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: point2)
        path.addLine(to: endPoint)
        commonAreaLineLayer.path = path.cgPath
        layer.addSublayer(commonAreaLineLayer)
    }
    
    private func calculateCommonAreaLineStartX(circle1CenterX: CGFloat, circle2CenterX: CGFloat,
                                               radius1: CGFloat, radius2: CGFloat, distance: CGFloat) -> CGFloat {
        let valueS = value1 < value2 ? value1 : value2
        if commonValue == valueS {
            return value2 < value1 ? circle2CenterX : circle1CenterX
        }
        
        let x = circle2CenterX - radius2
        let commonAreaLength = radius1 + radius2 - distance
        return x + commonAreaLength/2
    }
}
