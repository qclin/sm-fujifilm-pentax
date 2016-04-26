//
//  DetailViewController.swift
//  pro1-imageSelector
//
//  Created by Qiao Lin on 4/6/16.
//  Copyright © 2016 Qiao Lin. All rights reserved.
//

import UIKit
import Social


class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let imageView = self.detailImageView {
                var name = detail as! String
                imageView.image = UIImage(named: name)
                navigationItem.title = name
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "backTapped")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareTapped")
        
    }
    
    func backTapped(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func shareTapped(){
        
        let vc = UIActivityViewController(activityItems: [MyStringItemSource(), detailImageView.image!], applicationActivities: [])
//        vc.excludedActivityTypes = [UIActivityTypePostToFacebook]
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        presentViewController(vc, animated: true, completion: nil)

        
////        / share on Facebook
//        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//        vc.setInitialText("hoge hoge")
//        vc.addImage(detailImageView.image!)
//        vc.addURL(NSURL(string: "http://www.getupdraft.io"))
//        presentViewController(vc, animated: true, completion: nil)
    }

    func toSNS(){
        performSegueWithIdentifier("toWebView", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


class MyStringItemSource: NSObject, UIActivityItemSource {
    @objc func activityViewControllerPlaceholderItem(activityViewController: UIActivityViewController) -> AnyObject {
        return ""
    }
    
    @objc func activityViewController(activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
        if activityType == UIActivityTypeMessage {
            return "Hoge hoge message"
        } else if activityType == UIActivityTypeMail {
            return "String for mail"
        } else if activityType == UIActivityTypePostToTwitter {
            return "Hoge hoge twitter"
        } else if activityType == UIActivityTypePostToFacebook {
            return "Hoge hoge facebook"
        }
        return nil
    }
    
    func activityViewController(activityViewController: UIActivityViewController, subjectForActivityType activityType: String?) -> String {
        if activityType == UIActivityTypeMessage {
            return "message title"
        } else if activityType == UIActivityTypeMail {
            return "mail title"
        } else if activityType == UIActivityTypePostToTwitter {
            return "twitter title"
        } else if activityType == UIActivityTypePostToFacebook {
            return "facebook title"
        }
        return ""
    }
    
//    func activityViewController(activityViewController: UIActivityViewController, thumbnailImageForActivityType activityType: String!, suggestedSize size: CGSize) -> UIImage! {
//        if activityType == UIActivityTypeMessage {
//            return UIImage(named: "thumbnail-for-message")
//        } else if activityType == UIActivityTypeMail {
//            return UIImage(named: "thumbnail-for-mail")
//        } else if activityType == UIActivityTypePostToTwitter {
//            return UIImage(named: "thumbnail-for-twitter")
//        } else if activityType == UIActivityTypePostToFacebook {
//            return UIImage(named: "thumbnail-for-facebook")
//        }
//        return UIImage(named: "some-default-thumbnail")
//    }
}
