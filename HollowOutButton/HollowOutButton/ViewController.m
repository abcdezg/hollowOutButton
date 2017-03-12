//
//  ViewController.m
//  HollowOutButton
//
//  Created by 小鱼闯江湖 on 2017/3/12.
//  Copyright © 2017年 小鱼闯江湖. All rights reserved.
//

#import "ViewController.h"
#import "HollowOutButton.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonClick:(HollowOutButton *)sender {
    NSLog(@"Touch Up Inside");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
