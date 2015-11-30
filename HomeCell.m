//
//  HomeCell.m
//  Scroll1127
//
//  Created by 劉坤昶 on 2015/11/27.
//  Copyright © 2015年 劉坤昶 Johnny. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.testImage = [[UIImageView alloc] init];
        self.testImage.contentMode = UIViewContentModeScaleAspectFill;
        self.testImage.clipsToBounds = YES;
        //[self.contentView addSubview:self.testImage];
        
        self.myLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 150, 50)];
        self.myLabel.textColor = [UIColor whiteColor];
        self.myLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.contentView addSubview:self.myLabel];
        
    }
    
    
    
    return self;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
