//
//  TipsView.swift
//  TipsViewTest
//
//  Created by dlleng on 2021/8/3.
//

import UIKit

enum TipsViewOption {
    //尖头方向
    enum Direction {
        case top
        case bottom
        case left
        case right
    }
    //尖头位置
    enum Padding {
        case center
        case paddingLeft(CGFloat)
        case paddingRight(CGFloat)
        case paddingTop(CGFloat)
        case paddingBottom(CGFloat)
    }
    
    case cornerRadius(CGFloat)
    case arrowWidth(CGFloat)
    case arrowHeight(CGFloat)
    case arrowCorner(CGFloat)
    case arrowDirection(Direction)
    case arrowPadding(Padding)
    case fillColor(UIColor)
    case borderColor(UIColor)
    case borderWidth(CGFloat)
    
}

class TipsView: UIView {
    private var cornerRadius: CGFloat = 10
    //尖头的宽高 高就是按尖头指向的方向 宽是等腰三角形的宽
    fileprivate var arrowWidth: CGFloat = 10
    fileprivate var arrowHeight: CGFloat = 5
    private var arrowCorner: CGFloat = 3
    fileprivate var arrowDirection: TipsViewOption.Direction = .top
    private var arrowPadding: TipsViewOption.Padding = .center
    
    private var fillColor: UIColor = .white
    private var borderColor: UIColor = .clear
    private var borderWidth: CGFloat = 0
    
    private let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(shapeLayer)
    }
    
    init(frame: CGRect, opts: [TipsViewOption]?) {
        super.init(frame: frame)
        layer.addSublayer(shapeLayer)
        if let opts = opts {
            set(opts: opts)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(opts: [TipsViewOption]) {
        for opt in opts {
            switch opt {
            case .cornerRadius(let v):
                cornerRadius = v
            case .arrowWidth(let v):
                arrowWidth = v
            case .arrowHeight(let v):
                arrowHeight = v
            case .arrowCorner(let v):
                arrowCorner = v
            case .arrowDirection(let v):
                arrowDirection = v
            case .arrowPadding(let v):
                arrowPadding = v
            case .fillColor(let v):
                fillColor = v
            case .borderColor(let v):
                borderColor = v
            case .borderWidth(let v):
                borderWidth = v
            }
        }
        updateUI()
    }
    
    func updateUI() {
        drawBackground()
    }
}


fileprivate extension TipsView {
    func drawBackground() {
        shapeLayer.frame = self.bounds
        arrowCorner = max(arrowCorner, 0.1)

        let path = UIBezierPath()
        path.lineWidth = borderWidth
        path.lineJoinStyle = .round
        path.removeAllPoints()
        
        let arrowSize = CGSize(width: arrowWidth, height: arrowHeight)
        var rect = self.bounds
        switch arrowDirection {
        case .top:
            rect.origin.y = arrowSize.height
            rect.size.height -= arrowSize.height
        case .bottom:
            rect.size.height -= arrowSize.height
        case .left:
            rect.origin.x = arrowSize.height
            rect.size.width -= arrowSize.height
        case .right:
            rect.size.width -= arrowSize.height
        }
        
        var arrowX: CGFloat = 0
        switch arrowPadding {
        case .center:
            arrowX = isHorizontal ? rect.width/2 : rect.height/2
        case .paddingLeft(let left):
            arrowX = left
        case .paddingRight(let right):
            arrowX = isHorizontal ? rect.width - right : rect.height - right
        case .paddingTop(let top):
            arrowX = top
        case .paddingBottom(let bottom):
            arrowX = isHorizontal ? rect.width - bottom : rect.height - bottom
        }
        
        let arrowY = arrowCorner/arrowSize.width*2*sqrt(arrowSize.width*arrowSize.width/4+arrowSize.height*arrowSize.height)
        let radian = acos(arrowCorner/arrowY)
        let tx = arrowCorner * sin(radian)
        let ty = arrowY - arrowCorner * cos(radian)
        
        switch arrowDirection {
        case .top:
            let startPoint = CGPoint(x: rect.maxX-cornerRadius, y: rect.minY)
            //right
            path.move(to: startPoint)
            drawFrameRight(path: path, rect: rect)
            //bottom
            drawFrameBottom(path: path, rect: rect)
            //left
            drawFrameLeft(path: path, rect: rect)
            //top
            path.addArc(
                withCenter: CGPoint(x: rect.minX+cornerRadius, y: rect.minY+cornerRadius),
                radius: cornerRadius,
                startAngle: CGFloat.pi,
                endAngle: CGFloat.pi*3/2, clockwise: true)
            //arrow
            path.addLine(to: CGPoint(x: rect.minX+arrowX-arrowSize.width/2, y: rect.minY))
            //corner
            path.addLine(to: CGPoint(x: rect.minX+arrowX-tx, y: rect.minY-arrowSize.height+ty))
            path.addArc(
                withCenter: CGPoint(x: rect.minX+arrowX, y: rect.minY-arrowSize.height+arrowY),
                radius: arrowCorner,
                startAngle: -CGFloat.pi/2-radian,
                endAngle: -CGFloat.pi/2+radian, clockwise: true)
            path.addLine(to: CGPoint(x: rect.minX+arrowX+arrowSize.width/2, y: rect.minY))
            path.addLine(to: startPoint)
        case .bottom:
            let startPoint = CGPoint(x: rect.minX+cornerRadius, y: rect.maxY)
            //left
            path.move(to: startPoint)
            drawFrameLeft(path: path, rect: rect)
            //top
            drawFrameTop(path: path, rect: rect)
            //right
            drawFrameRight(path: path, rect: rect)
            //bottom
            path.addArc(
                withCenter: CGPoint(x: rect.maxX-cornerRadius, y: rect.maxY-cornerRadius),
                radius: cornerRadius,
                startAngle: 0,
                endAngle: CGFloat.pi/2, clockwise: true)
            //arrow
            path.addLine(to: CGPoint(x: rect.minX+arrowX+arrowSize.width/2, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX+arrowX+tx, y: rect.maxY+arrowSize.height-ty))
            path.addArc(
                withCenter: CGPoint(x: rect.minX+arrowX, y: rect.maxY+arrowSize.height-arrowY),
                radius: arrowCorner,
                startAngle: CGFloat.pi/2-radian,
                endAngle: CGFloat.pi/2+radian, clockwise: true)
            path.addLine(to: CGPoint(x: rect.minX+arrowX-arrowSize.width/2, y: rect.maxY))
            path.addLine(to: startPoint)
        case .left:
            let startPoint = CGPoint(x: rect.minX, y: rect.minY+cornerRadius)
            //top
            path.move(to: startPoint)
            drawFrameTop(path: path, rect: rect)
            //right
            drawFrameRight(path: path, rect: rect)
            //bottom
            drawFrameBottom(path: path, rect: rect)
            //left
            path.addArc(
                withCenter: CGPoint(x: rect.minX+cornerRadius, y: rect.maxY-cornerRadius),
                radius: cornerRadius,
                startAngle: CGFloat.pi/2,
                endAngle: CGFloat.pi, clockwise: true)
            //arrow
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY+arrowX+arrowSize.width/2))
            path.addLine(to: CGPoint(x: rect.minX-arrowSize.height+ty, y: rect.minY+arrowX+tx))
            path.addArc(
                withCenter: CGPoint(x: rect.minX-arrowSize.height+arrowY, y: rect.minY+arrowX),
                radius: arrowCorner,
                startAngle: CGFloat.pi-radian,
                endAngle: CGFloat.pi+radian, clockwise: true)
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY+arrowX-arrowSize.width/2))
            path.addLine(to: startPoint)
        case .right:
            let startPoint = CGPoint(x: rect.maxX, y: rect.maxY-cornerRadius)
            //bottom
            path.move(to: startPoint)
            drawFrameBottom(path: path, rect: rect)
            //left
            drawFrameLeft(path: path, rect: rect)
            //top
            drawFrameTop(path: path, rect: rect)
            //right
            path.addArc(
                withCenter: CGPoint(x: rect.maxX-cornerRadius, y: rect.minY+cornerRadius),
                radius: cornerRadius,
                startAngle: -CGFloat.pi/2,
                endAngle: 0, clockwise: true)
            //arrow
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY+arrowX-arrowSize.width/2))
            path.addLine(to: CGPoint(x: rect.maxX+arrowSize.height-ty, y: rect.minY+arrowX-tx))
            path.addArc(
                withCenter: CGPoint(x: rect.maxX+arrowSize.height-arrowY, y: rect.minY+arrowX),
                radius: arrowCorner,
                startAngle: 0-radian,
                endAngle: 0+radian, clockwise: true)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY+arrowX+arrowSize.width/2))
            path.addLine(to: startPoint)
        }
        path.close()

        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = borderColor.cgColor
    }
    
    func drawFrameLeft(path: UIBezierPath, rect: CGRect) {
        path.addArc(
            withCenter: CGPoint(x: rect.minX+cornerRadius, y: rect.maxY-cornerRadius),
            radius: cornerRadius,
            startAngle: CGFloat.pi/2,
            endAngle: CGFloat.pi, clockwise: true)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY+cornerRadius))
    }
    func drawFrameRight(path: UIBezierPath, rect: CGRect) {
        path.addArc(
            withCenter: CGPoint(x: rect.maxX-cornerRadius, y: rect.minY+cornerRadius),
            radius: cornerRadius,
            startAngle: -CGFloat.pi/2,
            endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY-cornerRadius))
    }
    func drawFrameTop(path: UIBezierPath, rect: CGRect) {
        path.addArc(
            withCenter: CGPoint(x: rect.minX+cornerRadius, y: rect.minY+cornerRadius),
            radius: cornerRadius,
            startAngle: CGFloat.pi,
            endAngle: CGFloat.pi*3/2, clockwise: true)
        path.addLine(to: CGPoint(x: rect.maxX-cornerRadius, y: rect.minY))
    }
    func drawFrameBottom(path: UIBezierPath, rect: CGRect) {
        path.addArc(
            withCenter: CGPoint(x: rect.maxX-cornerRadius, y: rect.maxY-cornerRadius),
            radius: cornerRadius,
            startAngle: 0,
            endAngle: CGFloat.pi/2, clockwise: true)
        path.addLine(to: CGPoint(x: rect.minX+cornerRadius, y: rect.maxY))
    }
    
    var isHorizontal: Bool {
        arrowDirection == .top || arrowDirection == .bottom
    }
    
    var isVertical: Bool {
        arrowDirection == .left || arrowDirection == .right
    }
}


class TextTipsView: TipsView {
    private let label = UILabel(frame: .zero)
    var contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) {
        didSet { updateUI() }
    }
    var textMaxWidth: CGFloat = .greatestFiniteMagnitude {
        didSet { updateUI() }
    }
    var font: UIFont? {
        get { label.font }
        set { label.font = newValue; updateUI() }
    }
    var text: String? {
        get { label.text }
        set { label.text = newValue; updateUI() }
    }
    var textColor: UIColor? {
        get { label.textColor }
        set { label.textColor = newValue }
    }
    var textAlignment: NSTextAlignment {
        get { label.textAlignment }
        set { label.textAlignment = newValue }
    }
    
    override init(frame: CGRect, opts: [TipsViewOption]?) {
        super.init(frame: frame, opts: opts)
        addSubview(label)
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = .black
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateUI() {
        sizeToFit()
        super.updateUI()
        invalidateIntrinsicContentSize()
    }
    
    override func sizeToFit() {
        let lsize = label.sizeThatFits(CGSize(width: textMaxWidth, height: CGFloat.greatestFiniteMagnitude))
        label.frame.size = lsize
        var vsize = CGSize(width: lsize.width + contentInset.left + contentInset.right, height: lsize.height + contentInset.top + contentInset.bottom)
        switch arrowDirection {
        case .top:
            vsize.height += arrowHeight
            label.frame.origin = CGPoint(x: contentInset.left, y: contentInset.top + arrowHeight)
        case .bottom:
            vsize.height += arrowHeight
            label.frame.origin = CGPoint(x: contentInset.left, y: contentInset.top)
        case .left:
            vsize.width += arrowHeight
            label.frame.origin = CGPoint(x: contentInset.left + arrowHeight, y: contentInset.top)
        case .right:
            vsize.width += arrowHeight
            label.frame.origin = CGPoint(x: contentInset.left, y: contentInset.top)
        }
        //print(vsize)
        self.frame.size = vsize
    }
    
    override var intrinsicContentSize: CGSize { frame.size }
}
