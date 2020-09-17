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
    return 4;
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
        case 3:
            cell.textLabel.text = @"With custom title view";
            cell.detailTextLabel.text = @"Show an actionsheet with custom title view";
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RDDetailedActionController.defaultTitleFont = [UIFont fontWithName:@"HelveticaNeue" size:14];
    RDDetailedActionController.defaultTitleColor = [UIColor blueColor];
    RDDetailedActionController.defaultTitleSeparatorWidth = 3;
    
    RDDetailedActionView.defaultTitleColor = [UIColor darkGrayColor];
    RDDetailedActionView.defaultSubtitleColor = [UIColor grayColor];

    __block RDDetailedActionController *detailedActionController = nil;
    UIView *titleView = nil;
    UILabel *titleLabel = nil;
    
    switch (indexPath.row) {
        case 0:
            detailedActionController = [[RDDetailedActionController alloc] initWithTitle:@"Select Action"
                                                                                subtitle:@"for selected item"];
            
            [detailedActionController addActionWithTitle:@"Item #1" subtitle:nil icon:nil action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #1 clicked");
            }];
            [detailedActionController addActionWithTitle:@"Item #2" subtitle:nil icon:nil action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #2 clicked");
            }];
            [detailedActionController addActionWithTitle:@"Item #3" subtitle:nil icon:nil action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #3 clicked");
            }];
            [detailedActionController addActionWithTitle:@"Item #4" subtitle:nil icon:nil titleColor:[UIColor redColor] subtitleColor:nil action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #4 clicked");
            }];
            break;
        case 1:
            detailedActionController = [[RDDetailedActionController alloc] initWithTitle:@"Select Action"
                                                                                subtitle:@"for selected item"];
            
            [detailedActionController addActionWithTitle:@"Item #1" subtitle:nil icon:[UIImage imageNamed:@"Image-1"] action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #1 clicked");
            }];
            [detailedActionController addActionWithTitle:@"Item #2" subtitle:nil icon:[UIImage imageNamed:@"Image-2"] action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #2 clicked");
            }];
            [detailedActionController addActionWithTitle:@"Item #3" subtitle:nil icon:[UIImage imageNamed:@"Image-3"] action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #3 clicked");
            }];
            [detailedActionController addActionWithTitle:@"Item #4" subtitle:nil icon:[UIImage imageNamed:@"Image-4"] titleColor:[UIColor redColor] subtitleColor:nil action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #4 clicked");
            }];
            break;
        case 2:
            detailedActionController = [[RDDetailedActionController alloc] initWithTitle:@"Select Action"
                                                                                subtitle:@"for selected item"];
            
            [detailedActionController addActionWithTitle:@"Item #1" subtitle:@"A simple action for that item" icon:[UIImage imageNamed:@"Image-1"] action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #1 clicked");
            }];
            [detailedActionController addActionWithTitle:@"Item #2" subtitle:@"A more detailed action for that item" icon:[UIImage imageNamed:@"Image-2"] action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #2 clicked");
            }];
            [detailedActionController addActionWithTitle:@"Item #3" subtitle:@"A detailed action with extra steps" icon:[UIImage imageNamed:@"Image-3"] action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #3 clicked");
            }];
            [detailedActionController addActionWithTitle:@"Item #4" subtitle:@"A super detailed action with complete extra steps" icon:[UIImage imageNamed:@"Image-4"] titleColor:[UIColor redColor] subtitleColor:[UIColor colorWithRed:1 green:0.4 blue:0.4 alpha:1] action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #4 clicked");
            }];
            break;
        case 3:{
            titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)];
            titleView.backgroundColor = [UIColor lightGrayColor];

            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, titleView.bounds.size.width - 24, 50)];
            titleLabel.font = [UIFont boldSystemFontOfSize:20];
            titleLabel.numberOfLines = 2;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.backgroundColor = [UIColor grayColor];
            titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
            titleLabel.text = @"This is an action controller utilizing custom title view.";
            [titleView addSubview:titleLabel];
            
            detailedActionController = [[RDDetailedActionController alloc] initWithTitleView:titleView sidePadding:[NSNumber numberWithInt:12]];
            
            [detailedActionController addActionWithTitle:@"Item #1" subtitle:@"A simple action for that item" icon:[UIImage imageNamed:@"Image-1"] action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #1 clicked");
            }];
            [detailedActionController addActionWithTitle:@"Item #2" subtitle:@"A more detailed action for that item" icon:[UIImage imageNamed:@"Image-2"] action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #2 clicked");
            }];
            
            RDDetailedActionView *child1 = [[RDDetailedActionView alloc] initWithTitle:@"Sub Item #1" subtitle:@"Sub A detailed action with extra steps 1" icon:[UIImage imageNamed:@"Image-3"]  disabled:true action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #3 clicked");
            }];
            
            RDDetailedActionView *child2 = [[RDDetailedActionView alloc] initWithTitle:@"Sub Item #2" subtitle:@"Sub A detailed action with extra steps 2" icon:[UIImage imageNamed:@"Image-3"]  disabled:false action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #3 clicked");
            }];
            NSMutableArray *acts = [NSMutableArray arrayWithObjects:child1, child2, nil];
            [detailedActionController addActionWithTitle:@"Item #3" subtitle:@"A detailed action with extra steps" icon:[UIImage imageNamed:@"Image-3"] children:acts action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #3 clicked");
            }];
            [detailedActionController addActionWithTitle:@"Item #4" subtitle:@"A super detailed action with complete extra steps" icon:[UIImage imageNamed:@"Image-4"] titleColor:[UIColor redColor] subtitleColor:[UIColor colorWithRed:1 green:0.4 blue:0.4 alpha:1] action:^(RDDetailedActionView *actionView) {
                NSLog(@"Item #4 clicked");
            }];
            break;
        }
        default:
            break;
    }
    
    [detailedActionController show];
}

@end
