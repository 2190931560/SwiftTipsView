//
//  ViewController.swift
//  TipsViewTest
//
//  Created by dlleng on 2021/8/3.
//

import UIKit

class ViewController: UIViewController {
    
    let tipsView = TextTipsView(frame: CGRect(x: 50, y: 60, width: 0, height: 0),opts: [.borderColor(.red),.fillColor(.green)])

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(tipsView)
        tipsView.text = "dgasdgjsald;jggsadgja;sdjg;asdjg;lasdjgl;sadjgl;ajsdgl;asdjg;lasdjgsd;l;sadljgl;as"
        tipsView.textMaxWidth = 200
    }


    @IBAction func cornerRadiusChange(_ sender: UISlider) {
        tipsView.set(opts: [.cornerRadius(CGFloat(sender.value))])
    }
    
    @IBAction func sharpCornerChange(_ sender: UISlider) {
        tipsView.set(opts: [.arrowCorner(CGFloat(sender.value))])
    }
    
    @IBAction func leftPositionChange(_ sender: UISlider) {
        tipsView.set(opts: [.arrowPadding(.paddingLeft(CGFloat(sender.value)))])
    }
    
    
    @IBAction func rightPositionChange(_ sender: UISlider) {
        tipsView.set(opts: [.arrowPadding(.paddingRight(CGFloat(sender.value)))])
    }
    
    @IBAction func sharpHightChange(_ sender: UISlider) {
        tipsView.set(opts: [.arrowHeight(CGFloat(sender.value))])
    }
    
    @IBAction func sharpWidthChange(_ sender: UISlider) {
        tipsView.set(opts: [.arrowWidth(CGFloat(sender.value))])
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        var direct = TipsViewOption.Direction.top
        switch sender.selectedSegmentIndex {
        case 0: direct = .top
        case 1: direct = .bottom
        case 2: direct = .left
        default: direct = .right
        }
        tipsView.set(opts: [.arrowDirection(direct)])
    }
}

