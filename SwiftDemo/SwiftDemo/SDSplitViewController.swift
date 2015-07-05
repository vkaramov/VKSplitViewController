//
//  SDSplitViewController.swift
//  SwiftDemo
//
//  Created by Viacheslav Karamov on 05.07.15.
//  Copyright (c) 2015 Viacheslav Karamov. All rights reserved.
//

import UIKit

class SDSplitViewController: VKSplitViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let masterNavController = self.storyboard?.instantiateViewControllerWithIdentifier(SDMasterViewController.kNavigationStoryboardId) as? UINavigationController;
        let detailNavController = self.storyboard?.instantiateViewControllerWithIdentifier(SDDetailViewController.kNavigationStoryboardId) as? UINavigationController;
        
        if let masterNavController = masterNavController , detailNavController = detailNavController
        {
            self.setViewControllers(masterNavController, detailController: detailNavController);
        }
    }
}
