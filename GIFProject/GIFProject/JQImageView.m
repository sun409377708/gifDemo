//
//  JQImageView.m
//  GIFProject
//
//  Created by maoge on 16/10/14.
//  Copyright © 2016年 maoge. All rights reserved.
//

#import "JQImageView.h"
#import <SDWebImageManager.h>
#import <NSData+ImageContentType.h>
#import <ImageIO/ImageIO.h>


@interface JQImageView ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JQImageView{
    
    //记录data数据
    NSData *_imageData;
    
    //记录帧数
    NSInteger _currentIndex;
}

- (NSTimer *)timer {
    
    if (_timer == nil) {
        
        _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)updateTime {
    
    NSLog(@"%s", __FUNCTION__);
}

- (void)jq_setImageWithURL:(NSURL *)url {
    
//    [self sd_setImageWithURL:url];
    
    //使用sd原生的方法
    [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            //判断是否是gif图
            if ([[NSData sd_contentTypeForImageData:data] isEqualToString:@"image/gif"]) {
                
                NSLog(@"gif图");
                
                //初始化遍历
                _imageData = data;
                _currentIndex = 0;
                
                self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.1];
                
                return ;
            }
            
            self.timer.fireDate = [NSDate distantFuture];
            
            self.image = image;
        });
    }];
}


//抽取代码
- (UIImage *)jq_animatedGIFWithData:(NSData *)data {
    //数据为空, 直接返回
    if (!data) {
        return nil;
    }
    
    // 1. 创建数据源CGImageRef
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    // 2. 读取图片帧数
    size_t count = CGImageSourceGetCount(source);
    
    // 3. 创建image对象
    UIImage *animatedImage;
    
    // 4. 如果图片小于一, 直接返回一张图片
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        
        // 5. 遍历图片帧数
        for (size_t i = 0; i < count; i++) {
            // 6. 创建帧数对于的图像
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!image) {
                continue;
            }
            
            UIImage *img = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
            
            //将图片添加到数组中
            [images addObject:img];
            
            CGImageRelease(image);
        }
        
        //使用数组, 创建可动画对象
        animatedImage = [UIImage animatedImageWithImages:images duration:5];
    }
    
    CFRelease(source);
    
    return animatedImage;
}

@end
