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


@implementation JQImageView

- (void)jq_setImageWithURL:(NSURL *)url {
    
//    [self sd_setImageWithURL:url];
    
    //使用sd原生的方法
    [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            //判断是否是gif图
            if ([[NSData sd_contentTypeForImageData:data] isEqualToString:@"image/gif"]) {
                
                NSLog(@"gif图");
                return ;
            }
            
            
            self.image = image;
        });
    }];
}

@end
