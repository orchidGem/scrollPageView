//
//  RootViewController.swift
//  EMPageView_Playground
//
//  Created by Laura Evans on 11/18/16.
//  Copyright © 2016 Laura Evans. All rights reserved.
//

import UIKit
import EMPageViewController

class RootViewController: UIViewController, EMPageViewControllerDataSource, EMPageViewControllerDelegate {
    
    var pageViewController: EMPageViewController?
    var slideText: [String] = ["שלום", "מים", "גשר"]
    
    @IBOutlet weak var pageIndicator: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        let pageViewController = EMPageViewController()
        
        // Or, for a vertical orientation
        // let pageViewController = EMPageViewController(navigationOrientation: .Vertical)
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        // Set the initially selected view controller
        // IMPORTANT: If you are using a dataSource, make sure you set it BEFORE calling selectViewController:direction:animated:completion
        let currentViewController = self.viewController(at: 0)!
        pageViewController.selectViewController(currentViewController, direction: .forward, animated: false, completion: nil)
        
        // Add EMPageViewController to the root view controller
        self.addChildViewController(pageViewController)
        self.view.insertSubview(pageViewController.view, at: 0) // Insert the page controller view below the navigation buttons
        pageViewController.didMove(toParentViewController: self)
        
        self.pageViewController = pageViewController
        
        pageIndicator.numberOfPages = slideText.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - EMPageViewController Data Source
    
    func em_pageViewController(_ pageViewController: EMPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.index(of: viewController as! SlideViewController) {
            let beforeViewController = self.viewController(at: viewControllerIndex - 1)
            return beforeViewController
        } else {
            return nil
        }
    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.index(of: viewController as! SlideViewController) {
            let afterViewController = self.viewController(at: viewControllerIndex + 1)
            return afterViewController
        } else {
            return nil
        }
    }
    
    func viewController(at index: Int) -> SlideViewController? {
        if (self.slideText.count == 0) || (index < 0) || (index >= self.slideText.count) {
            return nil
        }
        
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "SlideViewController") as! SlideViewController
        viewController.slideText = self.slideText[index]
        //viewController.color = self.greetingColors[index]
        return viewController
    }
    
    func index(of viewController: SlideViewController) -> Int? {
        if let greeting: String = viewController.slideText {
            return self.slideText.index(of: greeting)
        } else {
            return nil
        }
    }
    
    
    // MARK: - EMPageViewController Delegate
    
    func em_pageViewController(_ pageViewController: EMPageViewController, willStartScrollingFrom startViewController: UIViewController, destinationViewController: UIViewController) {
        
        let startSlideViewController = startViewController as! SlideViewController
        let destinationSlideViewController = destinationViewController as! SlideViewController
        
        print("Will start scrolling from \(startSlideViewController.slideText) to \(destinationSlideViewController.slideText).")
    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, isScrollingFrom startViewController: UIViewController, destinationViewController: UIViewController, progress: CGFloat) {
        let startSlideViewController = startViewController as! SlideViewController
        let destinationSlideViewController = destinationViewController as! SlideViewController
        
        // Ease the labels' alphas in and out
        let absoluteProgress = fabs(progress)
        startSlideViewController.slideLabel.alpha = pow(1 - absoluteProgress, 2)
        destinationSlideViewController.slideLabel.alpha = pow(absoluteProgress, 2)
        
        print("Is scrolling from \(startSlideViewController.slideText) to \(destinationSlideViewController.slideText) with progress '\(progress)'.")
    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, didFinishScrollingFrom startViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        let startViewController = startViewController as! SlideViewController?
        let destinationViewController = destinationViewController as! SlideViewController
        
        // If the transition is successful, the new selected view controller is the destination view controller.
        // If it wasn't successful, the selected view controller is the start view controller
        if transitionSuccessful {
            
            if (self.index(of: destinationViewController) == 0) {
               // self.reverseButton.isEnabled = false
            } else {
                //self.reverseButton.isEnabled = true
            }
            
            if (self.index(of: destinationViewController) == self.slideText.count - 1) {
                //self.forwardButton.isEnabled = false
            } else {
               // self.forwardButton.isEnabled = true
            }
        }
        
        print("Finished scrolling from \(startViewController?.slideText) to \(destinationViewController.slideText). Transition successful? \(transitionSuccessful)")
        
        pageIndicator.currentPage = self.index(of: destinationViewController)!
        
    }

    
}
