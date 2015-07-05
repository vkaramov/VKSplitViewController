//
//  VKSplitViewControlelrViewController.swift
//
//  Created by Viacheslav Karamov on 04.07.15.
//  Copyright (c) 2015 Viacheslav Karamov. All rights reserved.
//

import UIKit

/**
*   An easy-to use UISplitViewController replacement with the simple interface
*/
@availability(iOS, introduced=7.0)
class VKSplitViewController: UIViewController
{
    /** Assigning a new value to this property animating showing or hiding master view controller respectively. Default is true. See `showMasterViewController(show : Bool, completion : (() -> Void)?)`
    */
    var masterViewControllerVisible : Bool
    {
        set
        {
            showMasterViewController(newValue, animated:true, completion:nil);
        }
        get
        {
            return self.isMasterVisible;
        }
    }
    
    /** Width of master view controller in points. The rest of the space will be occupied by the detail controller and the separator. Default is 320pt.
    */
    var masterViewControllerWidth : CGFloat = 320.0
    {
        didSet
        {
            self.masterViewWidthConstraint?.constant = masterViewControllerWidth;
        }
    }
    
    /** Separator color. Default is UIColor.lightGrayColor()
    */
    var separatorColor : UIColor = UIColor.lightGrayColor()
    {
        didSet
        {
            separator?.backgroundColor = separatorColor;
        }
    }
    
    /** Width of the separator. Default is 1pt.
    */
    var separatorWidth : CGFloat = 1.0
    {
        didSet
        {
            separatorWidthConstraint?.constant = separatorWidth;
        }
    }
    
    /** Controller added to the left of the widget. **Read-only**. To set its value use `setViewControllers(masterController : UIViewController, detailController : UIViewController)`
    */
    var masterViewController : UIViewController?
    {
        get
        {
            return self.masterVc;
        }
    }
    
    /** Controller added to the right of the widget. **Read-only**. To set its value use `setViewControllers(masterController : UIViewController, detailController : UIViewController)`
    */
    var detailViewController : UIViewController?
    {
        get
        {
            return self.detailVc;
        }
    }
    
    /** Sets both master and detail controllers. They will be imediatelly added as a child view controllers of the widget. Also sets `masterViewController` and `detailViewController` properties.
        :param: masterController Controller added to the left of the widget.
        :param: detailController Controller added to the right of the widget.
    */
    func setViewControllers(masterController : UIViewController, detailController : UIViewController)
    {
        self._setViewControllers(masterController, detailController);
    }
    
    /** Shows or hides master view controller respectively depending of the `show` parameter value.
        :param: show        If true, shows master controller using simple animation.
        :param: animated    If true, show/hide is performed using animation.
        :param: completion: A block object to be executed when the animation sequence ends.
    */
    func showMasterViewController(show : Bool, animated: Bool, completion : (() -> Void)?)
    {
        assert(nil != self.masterVc && nil != self.detailVc, "You should call setViewControllers() before calling this method \(__FUNCTION__)");
        
        if (self.isMasterVisible != show)
        {
            self.isMasterVisible = show;
            
            self.masterViewLeadingConstraint?.constant = show  ? 0.0 : -self.masterViewControllerWidth - self.separatorWidth;
            
            self.detailVc?.view.setNeedsLayout();
            
            self.masterVc?.view.hidden = false;
            
            UIView .animateWithDuration(self.animationDuration,
                animations: { () -> Void in
                self.view.layoutIfNeeded();
                
            }, completion: { (Bool finished) -> Void in
                self.masterVc?.view.hidden = !show;
                if (nil != completion)
                {
                    completion!();
                }
            });
        }
    }
    
    /** Duration of master controller's hide/show animation. Default is 0.5
    */
    var animationDuration : NSTimeInterval = 0.5;
    
    private var separator : UIView?;
    private var masterViewLeadingConstraint : NSLayoutConstraint?;
    private var masterViewWidthConstraint : NSLayoutConstraint?;
    private var separatorWidthConstraint : NSLayoutConstraint?;
    private var masterVc : UIViewController?;
    private var detailVc : UIViewController?;
    private var isMasterVisible = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        separator = UIView(frame: CGRectZero);
        separator?.setTranslatesAutoresizingMaskIntoConstraints(false);
        separator?.backgroundColor = separatorColor;
        view.addSubview(separator!);
    }
}

private extension VKSplitViewController
{
    func _setViewControllers(masterController : UIViewController, _ detailController : UIViewController)
    {
        masterController.view.setTranslatesAutoresizingMaskIntoConstraints(false);
        detailController.view.setTranslatesAutoresizingMaskIntoConstraints(false);
        
        if (nil != self.masterVc && nil != self.detailVc)
        {
            if (self.masterVc! != masterController)
            {
                replaceExistingViewController(existingController: self.masterVc!, newController :masterController);
            }
            if (self.detailVc! != detailController)
            {
                replaceExistingViewController(existingController: self.detailVc!, newController: detailController);
            }
            
            self.masterVc = masterController;
            self.detailVc = detailController;
            
            addConstraintsTo(masterController: masterController, detailController: detailController);
        }
        else
        {
            addChildViewController(masterController);
            addChildViewController(detailController);
            view.addSubview(masterController.view);
            view.addSubview(detailController.view);
            
            addConstraintsTo(masterController: masterController, detailController: detailController);
            
            masterController.didMoveToParentViewController(self);
            detailController.didMoveToParentViewController(self);
            
            self.masterVc = masterController;
            self.detailVc = detailController;
            
            view.layoutIfNeeded();
        }
    }
    
    func replaceExistingViewController(#existingController : UIViewController, newController : UIViewController)
    {
        existingController.willMoveToParentViewController(nil);
        addChildViewController(newController);
        view.addSubview(newController.view);
        
        UIView .animateWithDuration(0.2, animations: { () -> Void in
            existingController.view.alpha = 0.0;
        }) { (finished) -> Void in
            existingController.view.removeFromSuperview();
            existingController.removeFromParentViewController();
            newController.didMoveToParentViewController(self);
        }
    }
    
    func addConstraintsTo(#masterController : UIViewController, detailController : UIViewController)
    {
        self.masterViewLeadingConstraint = NSLayoutConstraint(item: masterController.view, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 0);
        
        self.masterViewWidthConstraint = NSLayoutConstraint(item: masterController.view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: self.masterViewControllerWidth);
        
        self.separatorWidthConstraint = NSLayoutConstraint(item: self.separator!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: self.separatorWidth);
        
        self.view.addConstraint(self.masterViewLeadingConstraint!);
        self.view.addConstraint(self.masterViewWidthConstraint!);
        self.view.addConstraint(self.separatorWidthConstraint!);
        
        let views = ["master" : masterController.view,
            "separator": self.separator!,
            "detail": detailController.view];
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[master]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views));
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[separator]|", options:NSLayoutFormatOptions(0), metrics:nil, views:views));
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[detail]|", options:NSLayoutFormatOptions(0), metrics:nil, views:views));
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[master]-0-[separator]-0-[detail]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views));
    }
}
