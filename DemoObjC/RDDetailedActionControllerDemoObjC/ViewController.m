//
//  ViewController.m
//  RDDetailedActionControllerDemoObjC
//
//  Created by Firstiar Noorwinanto on 7/23/18.
//  Copyright © 2018 Radical Dreamers. All rights reserved.
//

#import "ViewController.h"
#import <RDDetailedActionController/RDDetailedActionController-Swift.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Pick one of these examples";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Title Only";
            cell.detailTextLabel.text = @"Show an actionsheet with title only item";
            break;
        case 1:
            cell.textLabel.text = @"Icon and Title";
            cell.detailTextLabel.text = @"Show an actionsheet with icon and title";
            break;
        case 2:
            cell.textLabel.text = @"Icon, Title, and Subtitle";
            cell.detailTextLabel.text = @"Show an actionsheet with icon, title, and subtitle";
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RDDetailedActionController *detailedActionController = [[RDDetailedActionController alloc] initWithTitle:@"Select Action"
                                                                                                    subtitle:@"for selected item"
                                                                                                        font:nil
                                                                                                  titleColor:nil];
    
    switch (indexPath.row) {
        case 0:
            [detailedActionController addActionWithTitle:@"Item #1" subtitle:nil icon:nil action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #1 clicked");
            }];
            [detailedActionController addActionWithTitle:@"Item #2" subtitle:nil icon:nil action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #2 clicked");
            }];
            [detailedActionController addActionWithTitle:@"Item #3" subtitle:nil icon:nil action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #3 clicked");
            }];
            [detailedActionController addActionWithTitle:@"Item #4" subtitle:nil icon:nil action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #4 clicked");
            }];
            break;
        case 1:
            [detailedActionController addActionWithTitle:@"Item #1" subtitle:nil icon:[UIImage imageNamed:@"Image-1"] action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #1 clicked");
            }];
            [detailedActionController addActionWithTitle:@"Item #2" subtitle:nil icon:[UIImage imageNamed:@"Image-2"] action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #2 clicked");
            }];
            [detailedActionController addActionWithTitle:@"Item #3" subtitle:nil icon:[UIImage imageNamed:@"Image-3"] action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #3 clicked");
            }];
            [detailedActionController addActionWithTitle:@"Item #4" subtitle:nil icon:[UIImage imageNamed:@"Image-4"] action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #4 clicked");
            }];
            break;
        case 2:
            [detailedActionController addActionWithTitle:@"Item #1" subtitle:@"A simple action for that item" icon:[UIImage imageNamed:@"Image-1"] action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #1 clicked");
            }];
            [detailedActionController addActionWithTitle:@"Item #2" subtitle:@"A more detailed action for that item" icon:[UIImage imageNamed:@"Image-2"] action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #2 clicked");
            }];
            [detailedActionController addActionWithTitle:@"Item #3" subtitle:@"A detailed action with extra steps" icon:[UIImage imageNamed:@"Image-3"] action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #3 clicked");
            }];
            [detailedActionController addActionWithTitle:@"Item #4" subtitle:@"A super detailed action with complete extra steps" icon:[UIImage imageNamed:@"Image-4"] action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #4 clicked");
            }];
            break;
        default:
            break;
    }
    
    [detailedActionController show];
}

@end
