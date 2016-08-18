//
//  AddVegetableViewController.m
//  Vegetables
//
//  Created by LLDM on 16/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import "AddVegetableViewController.h"

@interface AddVegetableViewController () {
    UIImage *photo;
}

@end

@implementation AddVegetableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.saveBtn.enabled = NO;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction) getPhoto:(id) sender {
    self.alert.hidden = YES;
    if(self.photoURL.text.length == 0) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        [self isLoading:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSURL *photoURL = [NSURL URLWithString:self.photoURL.text];
            photo = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
            if(!photo) photo = [UIImage imageNamed:@"noImg.png"];
            photo = [self imageWithImage:photo proportionalResizeWithWidth:320];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                self.previewPhoto.image = photo;
                [self isLoading:NO];
            });
        });
    }
    [self checkFields];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    photo = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.previewPhoto.image = photo;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onNameChange:(id)sender {
    self.alert.hidden = YES;
    [self checkFields];
}

-(void) checkFields {
    if(self.name.text.length > 0 && photo)
        self.saveBtn.enabled = YES;
    else
        self.saveBtn.enabled = NO;
}

- (IBAction)save:(id)sender {
    [self isLoading:YES];
    NSString *B64Photo = [UIImagePNGRepresentation(photo) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSDictionary *vegetables =@{
                                @"name":self.name.text,
                                @"photo":B64Photo
                                };
    
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:vegetables options:0 error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.214:3000/v1/vegetables"]];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = JSONData;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setValue:
     [NSString stringWithFormat:@"%lu",
      (unsigned long)[JSONData length]] forHTTPHeaderField:@"Content-Length"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *r, NSData *data, NSError *error) {
         if (!data)
             NSLog(@"No data returned from server, error ocurred: %@", error);
         else {
             NSError *deserr;
             NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&deserr];
             NSLog(@"response:\n\n\n%@\n\n\n", responseDict);
             self.alert.hidden = NO;
         }
        [self isLoading:NO];
     }];
}

-(void)isLoading:(BOOL)stillLoading {
    if(stillLoading)
        [self.loading startAnimating];
    else
        [self.loading stopAnimating];
}

- (UIImage *)imageWithImage:(UIImage *)image proportionalResizeWithWidth:(int)width {
    
    float div = 1;
    if(image.size.width > width)
        div = image.size.width/width;
    
    CGSize newSize = CGSizeMake(image.size.width/div,image.size.height/div);
    
    NSLog(@"\n\n\nwidth: %f\nheight: %f",image.size.width/div,image.size.height/div);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resizedImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
