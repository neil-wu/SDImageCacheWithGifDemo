SDImageCacheWithGifDemo
==============

A small app shows how to use [FLAnimatedImage](https://github.com/Flipboard/FLAnimatedImage) for animated GIF with [SDWebImage](https://github.com/rs/SDWebImage) .

As SDWebImage discussed here: [Drop our GIF support and integrate a 3rd party solution](https://github.com/rs/SDWebImage/issues/945)
This project modify two little parts of SDWebImage's source code.
1. 
I disable SDWebImage's gif code. ( just modify UIImage+MultiFormat.m 's line 22-26 )
```swift

+ (UIImage *)sd_imageWithData:(NSData *)data {
    UIImage *image;
    /*
    NSString *imageContentType = [NSData sd_contentTypeForImageData:data];
    if ([imageContentType isEqualToString:@"image/gif"]) {
        image = [UIImage sd_animatedGIFWithData:data];
    }*/
    if (0) {
    }
#ifdef SD_WEBP
```

2.
SDImageCache.h , add this function to public, so I can get the cached NSData
```swift
- (NSData *)diskImageDataBySearchingAllPathsForKey:(NSString *)key;
```
-----------------
The trick that I used to use FLAnimatedImage to animated gif is like this:
```swift
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
```
For more details, just download the project. :]
