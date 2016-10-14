//
//  JQImageView.m
//  GIFProject
//
//  Created by maoge on 16/10/14.
//  Copyright © 2016年 maoge. All rights reserved.
//

#import "JQImageView.h"
//#import <UIImageView+WebCache.h>
#import <SDWebImageManager.h>

@implementation JQImageView

- (void)jq_setImageWithURL:(NSURL *)url {
    
//    [self sd_setImageWithURL:url];
    
    //使用sd原生的方法
    [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            self.image = image;
        });
    }];
}

@end
