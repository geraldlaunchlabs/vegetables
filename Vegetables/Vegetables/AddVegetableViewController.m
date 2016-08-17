//
//  AddVegetableViewController.m
//  Vegetables
//
//  Created by LLDM on 16/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import "AddVegetableViewController.h"
#define appService [NSURL \
URLWithString:@"http://192.168.1.214:3000/v1/vegetables"]

@interface AddVegetableViewController ()

@end

@implementation AddVegetableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create a simple dictionary with numbers.
    NSDictionary *vegetables =@{
                                @"name":@"Oddish",
                                @"photo":@{
                                        @"url":@"http://cdn.bulbagarden.net/upload/thumb/4/43/043Oddish.png/250px-043Oddish.png"
                                        }
                                };
    
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:vegetables
                                                       options:0
                                                         error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:appService];
    
    // Set method, body & content-type
    request.HTTPMethod = @"POST";
    request.HTTPBody = JSONData;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setValue:
     [NSString stringWithFormat:@"%lu",
      (unsigned long)[JSONData length]] forHTTPHeaderField:@"Content-Length"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *r, NSData *data, NSError *error)
     {
         
         if (!data)
         {
             NSLog(@"No data returned from server, error ocurred: %@", error);
             NSString *userErrorText = [NSString stringWithFormat:@"Error communicating with server: %@", error.localizedDescription];
             return;
         }
         
         NSLog(@"got the NSData fine. here it is...\n%@\n", data);
         NSLog(@"next step, deserialising");
         
         NSError *deserr;
         NSDictionary *responseDict = [NSJSONSerialization
                                       JSONObjectWithData:data
                                       options:kNilOptions
                                       error:&deserr];
         
         NSLog(@"so, here's the responseDict\n\n\n%@\n\n\n", responseDict);
         
         // LOOK at that output on your console to learn how to parse it.
         // to get individual values example blah = responseDict[@"fieldName"];
     }];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
