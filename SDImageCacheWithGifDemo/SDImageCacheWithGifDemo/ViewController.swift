//
//  ViewController.swift
//  SDImageCacheWithGifDemo
//
//  Created by appdev on 15/7/7.
//  Copyright (c) 2015年 neilwu. All rights reserved.
//

import UIKit
import SDWebImage
import FLAnimatedImage

class ViewController: UIViewController {

    
    @IBOutlet weak var baseview: UIView!
    @IBOutlet weak var doLoadBtn: UIButton!
    @IBOutlet weak var tipTxt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doLoadImage(sender: AnyObject) {
        let imgurlstring = "https://raw.githubusercontent.com/Flipboard/FLAnimatedImage/master/images/flanimatedimage-demo-player.gif"
        //let imgurlstring = "https://assets-cdn.github.com/images/modules/contact/heartocat.png"
        let imgurl = NSURL(string: imgurlstring)
        
        let isExistInCache = SDWebImageManager.sharedManager().cachedImageExistsForURL(imgurl)
        
        if isExistInCache {
            self.tipTxt.text = "load from cache"
        } else {
            self.tipTxt.text = "load from net"
        }
        //download image
        SDWebImageManager.sharedManager().downloadImageWithURL(imgurl!,
            options: SDWebImageOptions.ProgressiveDownload,
            progress: { (recvSize, totalSize) in
                //
                if recvSize < totalSize {
                    var val = Int( CGFloat(recvSize) * 100.0 / CGFloat(totalSize) )
                    self.tipTxt.text = "\(val)%"
                } else if recvSize == totalSize {
                    self.tipTxt.text = "load from net done"
                }
                
            }, completed: { (image, error, cacheType, finished, imgURL)  in
                //on image loaded
                if finished {
                    if imgurlstring.hasSuffix(".gif") {
                        //we use NSData from the cache
                        var data = SDWebImageManager.sharedManager().imageCache.diskImageDataBySearchingAllPathsForKey(imgurlstring)
                        var img = FLAnimatedImage(animatedGIFData: data!)
                        var imgview = FLAnimatedImageView(frame: CGRectMake(0, 0, self.baseview.frame.width, self.baseview.frame.height))
                        imgview.animatedImage = img
                        imgview.contentMode = UIViewContentMode.ScaleAspectFit
                        self.baseview.addSubview(imgview)
                    } else {
                        var pngview = UIImageView(image: image)
                        pngview.frame = CGRectMake(0, 0, self.baseview.frame.width, self.baseview.frame.height)
                        pngview.contentMode = UIViewContentMode.ScaleAspectFit
                        self.baseview.addSubview(pngview)
                    }
                    
                }
                
        })

    }

    
}

