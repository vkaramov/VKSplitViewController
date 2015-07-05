//
//  SDDetailViewController.swift
//  SwiftDemo
//
//  Created by Viacheslav Karamov on 05.07.15.
//  Copyright (c) 2015 Viacheslav Karamov. All rights reserved.
//

import UIKit

class SDDetailViewController: UIViewController
{
    static let kNavigationStoryboardId = "DetailNavigationController";
    
    private var splitController : VKSplitViewController?;
    @IBOutlet private var colorView : UIView?;
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        splitController = UIApplication.sharedApplication().delegate?.window??.rootViewController as? VKSplitViewController;
    }
    
    func setBackgroundColor(color : UIColor)
    {
        colorView?.backgroundColor = color;
    }
    
    @IBAction func menuBarTapped(sender : UIBarButtonItem?)
    {
        if let splitController = splitController
        {
            let visible = splitController.masterViewControllerVisible;
            self.navigationItem.leftBarButtonItem?.title? = visible ? "Show" : "Hide";
            splitController.masterViewControllerVisible = !visible;
        }
    }
}
