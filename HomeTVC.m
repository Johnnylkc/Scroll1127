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
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (PFObject *allObjects in objects) {
            
            PFObject *title = allObjects[@"title"];
            PFFile *image = allObjects[@"image"];
            
            [image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                
                if (error == nil) {
                    
                
                UIImage *image = [[UIImage alloc] initWithData:data];
                    
                    getDataDic = [@{@"title":title , @"image":image}mutableCopy];
                
                    [locoDataArray addObject:getDataDic[@"image"]];
                    
                    NSLog(@"%@" , locoDataArray);
                    
                   

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
    return 15;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight;
    
    if (indexPath.row == 0) {
        
        rowHeight = 250;
    
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
    self.myScrollView.contentSize = CGSizeMake(1000, 0);
    self.myScrollView.backgroundColor = [UIColor clearColor];
    self.myScrollView.showsHorizontalScrollIndicator = NO;//不出現底下拖曳線
    [cell.contentView addSubview:self.myScrollView];
    
    //scroll裡的button
    
    for (int i = 0 ; i != locoDataArray.count ; i++ ) {
        
        UIButton *scrollButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [scrollButton addTarget:self action:@selector(toOneVC:) forControlEvents:UIControlEventTouchUpOutside];
        
        [scrollButton setBackgroundImage:locoDataArray[i] forState:normal];
        
        scrollButton.frame = CGRectMake(self.tableView.frame.size.width/2.4 * i +10 , 0, 150, 150);
        
        [self.myScrollView addSubview:scrollButton];
        
    }
    
    
    
//    self.oneButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 150, 150)];
//    [self.oneButton setBackgroundImage:[UIImage imageNamed:@"002"]  forState:normal];
//    [self.oneButton addTarget:self action:@selector(toOneVC:) forControlEvents:UIControlEventTouchUpInside];
//    [self.myScrollView addSubview:self.oneButton];
//
//    self.twoButton = [[UIButton alloc] initWithFrame:CGRectMake(170, 0, 150, 150)];
//    [self.twoButton setBackgroundImage:[UIImage imageNamed:@"003"] forState:normal];
//    [self.twoButton addTarget:self action:@selector(toOneVC:) forControlEvents:UIControlEventTouchUpInside];
//    [self.myScrollView addSubview:self.twoButton];
//    
//    self.threeButton = [[UIButton alloc] initWithFrame:CGRectMake(330, 0, 150, 150)];
//    [self.threeButton setBackgroundImage:[UIImage imageNamed:@"004"] forState:normal];
//    [self.threeButton addTarget:self action:@selector(toOneVC:) forControlEvents:UIControlEventTouchUpInside];
//    [self.myScrollView addSubview:self.threeButton];
//    
//    self.fourButton = [[UIButton alloc] initWithFrame:CGRectMake(490, 0, 150, 150)];
//    [self.fourButton setBackgroundImage:[UIImage imageNamed:@"005"] forState:normal];
//    [self.fourButton addTarget:self action:@selector(toOneVC:) forControlEvents:UIControlEventTouchUpInside];
//    [self.myScrollView addSubview:self.fourButton];
//    
//    self.fiveButton = [[UIButton alloc] initWithFrame:CGRectMake(650, 0, 150, 150)];
//    [self.fiveButton setBackgroundImage:[UIImage imageNamed:@"006"] forState:normal];
//    [self.fiveButton addTarget:self action:@selector(toOneVC:) forControlEvents:UIControlEventTouchUpInside];
//    [self.myScrollView addSubview:self.self.fiveButton];
    
    
    
    if (indexPath.row == 0) {
        
        //separatorLineView.frame = CGRectMake(30, 249, self.tableView.frame.size.width-60, 1);
    
        self.myScrollView.frame= CGRectMake(0, 100, self.tableView.frame.size.width, 150);
        
    
    }else if(indexPath.row == 14){
    
        separatorLineView = nil;
        cell.myLabel.text = @"要被吃掉囉";
        

    }else{
        
        
        separatorLineView.frame = CGRectMake(30, 69, self.tableView.frame.size.width-60, 1);

        
        cell.myLabel.text = @"要被吃掉囉";

        
    }
    
   return cell;
}




//scrollview裡button要執行的method
-(void)toOneVC:(UIButton*)button
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
