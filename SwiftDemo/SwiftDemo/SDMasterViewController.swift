//
//  ViewController.swift
//  SwiftDemo
//
//  Created by Viacheslav Karamov on 04.07.15.
//  Copyright (c) 2015 Viacheslav Karamov. All rights reserved.
//

import UIKit


class SDMasterViewController: UITableViewController
{
    static let kNavigationStoryboardId = "MasterNavigationController";
    
    static let colors = [UIColor.redColor(), UIColor.orangeColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.blueColor(), UIColor.magentaColor()];
    
    var detailController : SDDetailViewController?;
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        let splitController = UIApplication.sharedApplication().delegate?.window??.rootViewController as? VKSplitViewController;
        
        let detailNavController = splitController?.detailViewController as? UINavigationController;
        
        detailController = detailNavController?.viewControllers.first as? SDDetailViewController;

        selectRowAtIndex(0);
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        selectRowAtIndex(indexPath.row);
    }
    
    private func selectRowAtIndex(index : Int)
    {
        self.detailController?.setBackgroundColor(SDMasterViewController.colors[index]);
    }
}

