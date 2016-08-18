//
//  VegetablesViewController.h
//  Vegetables
//
//  Created by LLDM on 16/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VegetablesViewController : UIViewController

@property (nonatomic, strong) NSCache *imageCache;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
