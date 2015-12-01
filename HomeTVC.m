//
//  HomeTVC.m
//  Scroll1127
//
//  Created by 劉坤昶 on 2015/11/27.
//  Copyright © 2015年 劉坤昶 Johnny. All rights reserved.
//

#import "HomeTVC.h"
#import "HomeCell.h"
#import "OneVC.h"


#import <Parse/Parse.h>
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"


#import "QuartzCore/CALayer.h"



@interface HomeTVC () <UIScrollViewDelegate>
{
    NSMutableArray *locoDataArray;
    
    NSMutableDictionary *getDataDic;
    
    
    
    NSArray *newArray;
    
}

@property (strong , nonatomic) UIImageView *basicImage;
@property (strong , nonatomic) UIView *effectView;
@property (strong , nonatomic) UIScrollView *myScrollView;

@property (strong , nonatomic) UIButton *oneButton;
@property (strong , nonatomic) UIButton *twoButton;
@property (strong , nonatomic) UIButton *threeButton;
@property (strong , nonatomic) UIButton *fourButton;
@property (strong , nonatomic) UIButton *fiveButton;




@end

@implementation HomeTVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerClass:[HomeCell class] forCellReuseIdentifier:@"HomeCell"];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.basicImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aaa"]];
    self.basicImage.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
    self.basicImage.contentMode = UIViewContentModeScaleAspectFill;
    self.basicImage.clipsToBounds= YES;
    self.tableView.backgroundView = self.basicImage;
    
    [self parseDownload];
    
   //做一個漸層的view
    self.effectView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.tableView.frame.size.width, 150)] ;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.effectView.bounds;
    gradient.colors =
    [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    [self.effectView.layer insertSublayer:gradient atIndex:0];
    [self.tableView addSubview:self.effectView];
    
    
    
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.effectView.transform = CGAffineTransformMakeTranslation(0,scrollView.contentOffset.y);
}




-(void)parseDownload
{
    
    locoDataArray = [[NSMutableArray alloc] init];
    getDataDic = [[NSMutableDictionary alloc] init];

    
    PFQuery *query = [PFQuery queryWithClassName:@"allData"];

    //[query orderByDescending:@"order"];

    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
       

        
        for (PFObject *allObjects in objects) {
            
            PFObject *title = allObjects[@"title"];
            PFFile *image = allObjects[@"image"];
            PFObject *order = allObjects[@"order"];
            
            [image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                
                
                if (error == nil) {

                
                UIImage *image = [[UIImage alloc] initWithData:data];
                    
                    getDataDic = [@{@"title":title , @"image":image , @"order":order}mutableCopy];
                
                    [locoDataArray addObject:getDataDic];
                    
                    NSSortDescriptor *mySorter = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
                    [locoDataArray sortUsingDescriptors:[NSArray arrayWithObject:mySorter]];
                    
                    newArray = [[NSArray alloc] initWithArray:locoDataArray];
                    
                    
                    NSLog(@"%@" , locoDataArray[0][@"image"]);
                
                }
                
                [self.tableView reloadData];

            }];
            
        }
    
        NSLog(@"成功下載");
    }];
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight;
    
    if (indexPath.row == 0) {
        
        rowHeight = 250;
    
    }else if (indexPath.row == 6){
        
        rowHeight = 1000;
        
    }else{
        
        rowHeight = 70;

    }
    return rowHeight;
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
    
    HomeCell *cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeCell"];
    
    
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    //客制分隔線
    UIView* separatorLineView = [[UIView alloc] init];
    separatorLineView.backgroundColor = [UIColor whiteColor];
    separatorLineView.alpha = 0.2;
    [cell.contentView addSubview:separatorLineView];
    
   //我要在第一個cell加scrollview
    self.myScrollView = [[UIScrollView alloc] init];
    self.myScrollView.contentSize = CGSizeMake(1500, 0);
    self.myScrollView.backgroundColor = [UIColor clearColor];
    self.myScrollView.showsHorizontalScrollIndicator = NO;//不出現底下拖曳線
    [cell.contentView addSubview:self.myScrollView];
    
    //scroll裡的button

    int x = 0 ;
    for (int i = 0 ; i !=locoDataArray.count ; i++) {
        
        UIButton *scrollButton = [[UIButton alloc] initWithFrame:CGRectMake(x+15, 0, 150, 150)];
        [scrollButton setBackgroundImage:locoDataArray[i][@"image"] forState:normal];
        [scrollButton addTarget:self action:@selector(toOneVC:) forControlEvents:UIControlEventTouchUpInside];
        [self.myScrollView addSubview:scrollButton];
        
        x  += scrollButton.frame.size.width+15;
        

    }
    
    
    

    
    
    switch (indexPath.row) {
        case 0:
            self.myScrollView.frame= CGRectMake(0, 100, self.tableView.frame.size.width, 150);
            break;
            
        case 1:
            separatorLineView.frame = CGRectMake(30, 69, self.tableView.frame.size.width-60, 1);

            break;
        
        
        
        case 2:
            cell.myLabel.text = @"排行榜";
            separatorLineView.frame = CGRectMake(30, 69, self.tableView.frame.size.width-60, 1);

            break;
            
        case 3:
            cell.myLabel.text = @"最新發行";
            separatorLineView.frame = CGRectMake(30, 69, self.tableView.frame.size.width-60, 1);

            break;
            
        case 4:
            cell.myLabel.text = @"發掘";
            separatorLineView.frame = CGRectMake(30, 69, self.tableView.frame.size.width-60, 1);
            break;
            
        case 5:
            cell.myLabel.text = @"演唱會捷徑";
            separatorLineView.frame = CGRectMake(30, 69, self.tableView.frame.size.width-60, 1);

            break;
            
        case 6:
            cell.leftImage.frame = CGRectMake(10, 15, 145 , 140);
            cell.leftImage.image = [UIImage imageNamed:@"002"];
            
            
            cell.rightImage.frame = CGRectMake(165, 15, 145, 140);
            cell.rightImage.image = [UIImage imageNamed:@"004"];
            
            

            
        default:
            break;
    }
    
    
   return cell;
}







-(void)toOneVC:(UIButton*)sender
{
    OneVC *controller = [[OneVC alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    
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
