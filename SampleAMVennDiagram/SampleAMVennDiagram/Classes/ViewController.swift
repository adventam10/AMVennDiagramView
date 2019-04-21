//
//  ViewController.swift
//  SampleAMVennDiagram
//
//  Created by am10 on 2018/02/17.
//  Copyright © 2018年 am10. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak private var vdV0: AMVennDiagramView!
    @IBOutlet weak private var vdV1: AMVennDiagramView!
    @IBOutlet weak private var vdV2: AMVennDiagramView!
    @IBOutlet weak private var vdV3: AMVennDiagramView!
    @IBOutlet weak private var vdV4: AMVennDiagramView!
    @IBOutlet weak private var vdV5: AMVennDiagramView!
    @IBOutlet weak private var vdV6: AMVennDiagramView!
    @IBOutlet weak private var vdV7: AMVennDiagramView!
    @IBOutlet weak private var vdV8: AMVennDiagramView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        vdV0.setupVennDiagram(value1: 100, value2: 5, commonValue: 0)
        vdV0.dataSource = self
        
        vdV1.setupVennDiagram(value1: 1000, value2: 900, commonValue: 100)
        vdV1.dataSource = self
        
        vdV2.setupVennDiagram(value1: 10000, value2: 7000, commonValue: 7000)
        vdV2.dataSource = self
        
        vdV3.setupVennDiagram(value1: 85, value2: 46, commonValue: 44)
        vdV3.dataSource = self
        
        vdV4.setupVennDiagram(value1: 100, value2: 100, commonValue: 100)
        vdV4.dataSource = self
        
        vdV5.setupVennDiagram(value1: 46, value2: 85, commonValue: 44)
        vdV5.dataSource = self
        
        vdV6.setupVennDiagram(value1: 300, value2: 500, commonValue: 300)
        vdV6.dataSource = self
        
        vdV7.setupVennDiagram(value1: 10000, value2: 20000, commonValue: 4000)
        vdV7.dataSource = self
        
        vdV8.setupVennDiagram(value1: 400, value2: 1000, commonValue: 0)
        vdV8.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: AMVennDiagramViewDataSource {
    func vennDiagramView(_ vennDiagramView:AMVennDiagramView, fillColorForSection section: Int) -> UIColor {
        let r = CGFloat(arc4random_uniform(255) + 1)/255.0
        let g = CGFloat(arc4random_uniform(255) + 1)/255.0
        let b = CGFloat(arc4random_uniform(255) + 1)/255.0
        
        let color = UIColor(red: r, green: g, blue: b, alpha: 0.5)
        return color
    }
    
    func vennDiagramView(_ vennDiagramView:AMVennDiagramView, strokeColorForSection section: Int) -> UIColor {
        let r = CGFloat(arc4random_uniform(255) + 1)/255.0
        let g = CGFloat(arc4random_uniform(255) + 1)/255.0
        let b = CGFloat(arc4random_uniform(255) + 1)/255.0
        
        let color = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        return color
    }
    
    func vennDiagramView(_ vennDiagramView:AMVennDiagramView, titleForSection section: Int, value: CGFloat) -> String {
        let title = section == 0 ? "A" : "B"
        let vakueText = NSString(format: "%.0f", value) as String
        return title + "\n" + vakueText
    }
    
    func titleForCommonArea(in vennDiagramView:AMVennDiagramView, value: CGFloat) -> String {
        let vakueText = NSString(format: "%.0f", value) as String
        return "Common\n" + vakueText
    }
    
    func vennDiagramView(_ vennDiagramView:AMVennDiagramView, textColorForSection section: Int) -> UIColor {
        let r = CGFloat(arc4random_uniform(255) + 1)/255.0
        let g = CGFloat(arc4random_uniform(255) + 1)/255.0
        let b = CGFloat(arc4random_uniform(255) + 1)/255.0
        
        let color = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        return color
    }
    
    func textColorForCommonArea(in vennDiagramView:AMVennDiagramView) -> UIColor {
        let r = CGFloat(arc4random_uniform(255) + 1)/255.0
        let g = CGFloat(arc4random_uniform(255) + 1)/255.0
        let b = CGFloat(arc4random_uniform(255) + 1)/255.0
        
        let color = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        return color
    }
    
    func vennDiagramView(_ vennDiagramView:AMVennDiagramView, textFontForSection section: Int) -> UIFont {
        return UIFont.systemFont(ofSize: 17)
    }
    
    func textFontForCommonArea(in vennDiagramView:AMVennDiagramView) -> UIFont {
        return UIFont.systemFont(ofSize: 17)
    }
}
