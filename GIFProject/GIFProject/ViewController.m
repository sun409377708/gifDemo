//
//  ViewController.m
//  GIFProject
//
//  Created by maoge on 16/10/14.
//  Copyright © 2016年 maoge. All rights reserved.
//

#import "ViewController.h"
#import "JQImageView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet JQImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"source.gif" withExtension:nil];
    
    [self.imageView jq_setImageWithURL:url];}

@end
