//
//  ViewController.swift
//  GradientSlider
//
//  Created by Payal U. on 20/01/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lblSliderval: UILabel!
    @IBOutlet weak var gslider: UISlider!
    
    private var pUGradientSlider = PUGradientSlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pUGradientSlider.setSlider(slider: gslider)
        
        self.view.backgroundColor = pUGradientSlider.getColor(point: CGFloat(gslider.value))
    }
   
    
    @IBAction func slidervalue_changed(_ sender: UISlider) {
        self.view.backgroundColor = pUGradientSlider.getColor(point: CGFloat(sender.value))
        self.lblSliderval.text = "\(sender.value) %"
    }
    
}

