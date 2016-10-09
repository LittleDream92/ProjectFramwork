//
//  MeiHomeMenuCell.h
//  GaiBan
//
//  Created by Meng Fan on 16/9/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeiHomeMenuCell : UITableViewCell

/**
 *  自定义初始化方法
 */
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSMutableArray *)menuArray;


@end
