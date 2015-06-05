//
//  MailboxViewController.swift
//  codePath Week 3 Project_Mailbox
//
//  Created by Charles Hieger on 6/4/15.
//  Copyright (c) 2015 Charles Hieger. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var mailboxScrollView: UIScrollView!
    @IBOutlet weak var helpImageView: UIImageView!
    @IBOutlet weak var searchImageView: UIImageView!
    
    @IBOutlet weak var messegeView: UIView!
    @IBOutlet weak var messegeImageView: UIImageView!
    
    @IBOutlet weak var feedImageView: UIImageView!
    //icons
    @IBOutlet weak var archiveImageView: UIImageView!
    @IBOutlet weak var deleteImageView: UIImageView!
    @IBOutlet weak var laterImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    //options popup
    @IBOutlet weak var laterOptionsImageView: UIImageView!
    @IBOutlet weak var menuOptionsImageView: UIImageView!
    
    var initialCenter: CGPoint!
    var initialIconCenter: CGPoint!
    
    var lightGrey: UIColor!
    var green: UIColor!
    var red: UIColor!
    var yellow: UIColor!
    var peach: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lightGrey = UIColor(red: 229/255, green: 230/255, blue: 233/255, alpha: 1.0)
        green = UIColor(red: 98/255, green: 214/255, blue: 80/255, alpha: 1.0)
        red = UIColor(red: 229/255, green: 62/255, blue: 39/255, alpha: 1.0)
        yellow = UIColor(red: 233/255, green: 189/255, blue: 38/255, alpha: 1.0)
        peach = UIColor(red: 207/255, green: 150/255, blue: 99/255, alpha: 1.0)
        
        // setup scrollview
        mailboxScrollView.delegate = self
        mailboxScrollView.contentSize = CGSize(width: 320, height: helpImageView.image!.size.height + searchImageView.image!.size.height + messegeImageView.image!.size.height + feedImageView.image!.size.height)
        
        // setup option screens
        laterOptionsImageView.frame = view.bounds
        laterOptionsImageView.alpha = 0.0
        menuOptionsImageView.frame = view.bounds
        menuOptionsImageView.alpha = 0.0
        
        messegeView.hidden = false
        
        //        println(mailboxScrollView.contentSize.height)
        //        println(feedImageView.image!.size.height)
        
        //setup messegeView bounds
        //messegeView.frame = messegeImageView.bounds
        
        //add pan gesture recognizer to messegeView
        var messegePanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "didPanMessege:")
        messegeView.addGestureRecognizer(messegePanGestureRecognizer)
        
        //setup icons
        setupIcons()
        //println(view.frame.width)
        //println(messegeView.frame.height / 2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func didPanMessege(messegePanGestureRecognizer: UIPanGestureRecognizer) {
        var translation = messegePanGestureRecognizer.translationInView(messegeView)
        
        if messegePanGestureRecognizer.state == UIGestureRecognizerState.Began {
            initialCenter = messegeImageView.center
            
            
            
        } else if messegePanGestureRecognizer.state == UIGestureRecognizerState.Changed {
            messegeImageView.center.x = initialCenter.x + translation.x
            
            switch (translation.x) {
                //archive
            case 61...260:
                messegeView.backgroundColor = green
                deleteImageView.alpha = 0.0
                archiveImageView.alpha = 1.0
                archiveImageView.center.x = messegeImageView.frame.origin.x - 30
                //delete
            case 261...400:
                messegeView.backgroundColor = red
                archiveImageView.alpha = 0.0
                deleteImageView.alpha = 1.0
                deleteImageView.center.x = messegeImageView.frame.origin.x - 30
                //later
            case (-260)...(-61):
                messegeView.backgroundColor = yellow
                listImageView.alpha = 0.0
                laterImageView.alpha = 1.0
                laterImageView.center.x = messegeImageView.frame.origin.x + messegeImageView.frame.width + 30
                //list
            case (-400)...(-261):
                messegeView.backgroundColor = peach
                laterImageView.alpha = 0.0
                listImageView.alpha = 1.0
                listImageView.center.x = messegeImageView.frame.origin.x + messegeImageView.frame.width + 30
            default:
                messegeView.backgroundColor = lightGrey
                archiveImageView.alpha = translation.x / 60
                laterImageView.alpha = -(translation.x / 60)
            }
            
            
        } else if messegePanGestureRecognizer.state == UIGestureRecognizerState.Ended {
            
            switch (translation.x) {
                
                //archive
            case 61...260:
                slideOffScreenHide(500)
                //delete
            case 261...400:
                slideOffScreenHide(500)
                // reschedule
            case (-260)...(-61):
                slideOffScreenAlpha((-160), options: laterOptionsImageView)
                
                // options
            case (-400)...(-261):
                slideOffScreenAlpha((-160), options: menuOptionsImageView)
                
            default:
                UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                    self.messegeImageView.center = self.initialCenter

                }, completion: nil)
            }
        }
        
    }
    @IBAction func didTapLater(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.laterOptionsImageView.alpha = 0.0
            
            }) { (Bool) -> Void in
                self.updateMailbox()
        }
        
    }
    @IBAction func didTapMenu(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.menuOptionsImageView.alpha = 0.0
            
            }) { (Bool) -> Void in
                self.updateMailbox()
        }
        
    }
    @IBAction func resetMailbox(sender: UITapGestureRecognizer) {
        messegeImageView.frame.origin.x = 0
        setupIcons()
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.messegeView.hidden = false
            self.feedImageView.center.y += 86
            self.mailboxScrollView.contentSize.height += 86
        })
        
    }
    
    func slideOffScreenHide(endPoint: CGFloat) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.messegeImageView.center.x = endPoint
            self.archiveImageView.center.x = self.messegeImageView.frame.origin.x - 30
            self.deleteImageView.center.x = self.messegeImageView.frame.origin.x - 30
            
            }, completion: { (Bool) -> Void in
                self.messegeView.hidden = true
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.feedImageView.center.y -= 86
                    self.mailboxScrollView.contentSize.height -= 86
                })
                
        })
        
    }
    func slideOffScreenAlpha(endPoint: CGFloat, options: UIImageView) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.messegeImageView.center.x = (endPoint)
            self.laterImageView.center.x = self.messegeImageView.frame.origin.x + self.messegeImageView.frame.width + 30
            self.listImageView.center.x = self.messegeImageView.frame.origin.x + self.messegeImageView.frame.width + 30
            }) { (Bool) -> Void in
                options.alpha = 1.0
        }
        
        
    }
    func updateMailbox () {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.messegeView.hidden = true
            self.feedImageView.center.y -= 86
            self.mailboxScrollView.contentSize.height -= 86
        })
        
    }
    func setupIcons () {
        archiveImageView.alpha = 0.0
        archiveImageView.center = CGPoint(x: 30, y: messegeView.frame.height / 2)
        deleteImageView.alpha = 0.0
        deleteImageView.center.y = messegeView.frame.height / 2
        laterImageView.alpha = 0.0
        laterImageView.center = CGPoint(x: view.frame.width - 30 ,y: messegeView.frame.height / 2)
        listImageView.alpha = 0.0
        listImageView.center.y = messegeView.frame.height / 2
    }
}
