//
//  HGHomeMenuCell.m
//  GaiBan
//
//  Created by Meng Fan on 16/9/9.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "HGHomeMenuCell.h"
#import "Masonry.h"

#import "HGMenuBtn.h"

@implementation HGHomeMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //创建8个
        HGMenuBtn *btn = [[HGMenuBtn alloc] init];
        btn.backgroundColor = [UIColor cyanColor];
        [btn setImage:[UIImage imageNamed:@"ugc_photo"] forState:UIControlStateNormal];
        [btn setTitle:@"违章查询" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:btn];
        
        WEAKSELF
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf);
            make.left.mas_equalTo(weakSelf).offset(10);
            make.size.mas_equalTo(CGSizeMake(70, 90));
        }];
        
        
//        for (int i = 0; i < 8; i++) {
//            
//        }
    }
    return self;
}

#pragma mark - lazyloading


@end
