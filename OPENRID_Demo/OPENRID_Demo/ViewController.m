//
//  ViewController.m
//  OPENRID_Demo
//
//  Created by gaodun on 16/1/6.
//  Copyright © 2016年 idea. All rights reserved.
//

#import "ViewController.h"
#import "OPENRID.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *uniqueID;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.uniqueID.text = [OPENRID uniqueID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
