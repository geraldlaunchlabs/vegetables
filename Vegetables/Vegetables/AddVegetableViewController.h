//
//  AddVegetableViewController.h
//  Vegetables
//
//  Created by LLDM on 16/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddVegetableViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *previewPhoto;
@property (strong, nonatomic) IBOutlet UITextField *photoURL;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (strong, nonatomic) IBOutlet UILabel *alert;

@end
