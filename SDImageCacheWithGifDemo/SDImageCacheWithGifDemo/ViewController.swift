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

    func setImageView(imgurlstring: String, imgdata: NSData, image: UIImage) {
        if imgurlstring.hasSuffix(".gif") || imgurlstring.hasSuffix(".GIF")  {
            
            var img = FLAnimatedImage(animatedGIFData: imgdata)
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
    @IBAction func doLoadImage(sender: AnyObject) {
        let imgurlstring = "https://raw.githubusercontent.com/Flipboard/FLAnimatedImage/master/images/flanimatedimage-demo-player.gif"
        //let imgurlstring = "https://assets-cdn.github.com/images/modules/contact/heartocat.png"
        let imgurl = NSURL(string: imgurlstring)
        
        let isExistInCache = SDWebImageManager.sharedManager().cachedImageExistsForURL(imgurl)
        
        
        println("before download, isExistInCache=\(isExistInCache)")
        
        if isExistInCache {
            
            var imgdata = SDWebImageManager.sharedManager().imageCache.diskImageDataBySearchingAllPathsForKey(imgurlstring)
            if nil != imgdata {
                println("get file data from cache")
                var image: UIImage? = UIImage(data: imgdata)
                self.setImageView(imgurlstring, imgdata: imgdata, image: image!)
                return
            }
        }
        println("get file from net...")
        SDWebImageDownloader.sharedDownloader().downloadImageWithURL(imgurl!,
            options: SDWebImageDownloaderOptions.ProgressiveDownload,
            progress: { (recvSize, totalSize) -> Void in
                //
                if recvSize < totalSize {
                    var val = Int( CGFloat(recvSize) * 100.0 / CGFloat(totalSize) )
                    self.tipTxt.text = "\(val)%"
                } else if recvSize == totalSize {
                    self.tipTxt.text = "load from net done"
                }
                
        }) { (image, imgdata, error, finished) -> Void in
            //on image loaded
            if finished {
                //store image
                var memImg = SDWebImageManager.sharedManager().imageCache.imageFromMemoryCacheForKey(imgurlstring)
                if nil == memImg {
                    SDWebImageManager.sharedManager().imageCache.storeImage(image, recalculateFromImage: false,
                        imageData: imgdata, forKey: imgurlstring, toDisk: true)
                    println("--put img into cache")
                } else {
                    println("--already in cache")
                }
                self.setImageView(imgurlstring, imgdata: imgdata, image: image)
                
            }
            
        }
        
        /*
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
                    var isInDisk = SDWebImageManager.sharedManager().diskImageExistsForURL(imgurl!)
                    //var isInMem = SDWebImageManager.sharedManager().
                    println("cacheType=\(cacheType.rawValue), isInDisk=\(isInDisk)")
                    
                    if imgurlstring.hasSuffix(".gif") || imgurlstring.hasSuffix(".GIF")  {
                        //we use NSData from the cache
                        var data = SDWebImageManager.sharedManager().imageCache.diskImageDataBySearchingAllPathsForKey(imgurlstring)
                        if nil == data {
                            println("---fail to get data")
                            return
                        }
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
        */
    }

    @IBAction func onTapCleanBtn(sender: AnyObject) {
        SDWebImageManager.sharedManager().imageCache.clearDisk()
        SDWebImageManager.sharedManager().imageCache.clearMemory()
        //reset the imageview
        for view in self.baseview.subviews {
            if let view = view as? UIView {
                view.removeFromSuperview()
            }
        }
        
        var size = SDWebImageManager.sharedManager().imageCache.getSize()
        println("after clean,size=\(size)")
        println("")
    }
    
}

