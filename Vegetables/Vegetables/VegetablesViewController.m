//
//  VegetablesViewController.m
//  Vegetables
//
//  Created by LLDM on 16/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import "VegetablesViewController.h"

@interface VegetablesViewController (){
    NSDictionary *vegetables;
    UIImage *imageLoaded[100];
}

@end

@implementation VegetablesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageCache = [[NSCache alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://192.168.1.214:3000/v1/vegetables/"]];
        [request setHTTPMethod:@"GET"];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error == nil) {
                vegetables = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                //NSLog(@"requestReply: %@",vegetables[@"vegetables"]);
                [self.tableView reloadData];
            }
            else {
                
            }
        }] resume];
        
    });
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"\n\n\nasdadadadasdad\n\n\n");
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (int)[vegetables[@"vegetables"]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"reuseIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        //cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageLoaded[indexPath.row] = nil;
    }
    
    cell.textLabel.text = vegetables[@"vegetables"][(int)indexPath.row][@"name"];
    
    if(imageLoaded[indexPath.row] != nil)
        cell.imageView.image = imageLoaded[indexPath.row];
    else {
        cell.imageView.image = [UIImage imageNamed:@"noImg.png"];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            UIImage *photo = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:vegetables[@"vegetables"][(int)indexPath.row][@"photo"][@"url"]]]];
            if(photo != nil)
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                if(photo != nil) {
                    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                    if (cell)
                        cell.imageView.image = photo;
                } else cell.imageView.image = [UIImage imageNamed:@"noImg.png"];
                imageLoaded[indexPath.row] = cell.imageView.image;
            });
        });
    }
    float w = cell.frame.size.height*1.5/cell.imageView.image.size.width;
    float h = cell.frame.size.height/cell.imageView.image.size.height;
    cell.imageView.transform=CGAffineTransformMakeScale(w,h);
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
