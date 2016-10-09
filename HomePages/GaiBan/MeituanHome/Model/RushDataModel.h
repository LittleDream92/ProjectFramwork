//
//  RushDataModel.h
//  GaiBan
//
//  Created by Meng Fan on 16/9/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface RushDataModel : NSObject

@property(nonatomic, assign) NSNumber *id;
@property(nonatomic, strong) NSMutableArray *share;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, assign) NSNumber *start;
@property(nonatomic, assign) NSNumber *listJumpToTouch;

@property(nonatomic, assign) NSNumber *type;
@property(nonatomic, copy) NSString *descBefore;
@property(nonatomic, strong) NSMutableArray *deals;
@property(nonatomic, assign) NSNumber *end;
@property(nonatomic, copy) NSString *touchUrlForList;

@property(nonatomic, copy) NSString *descIn;
@property(nonatomic, copy) NSString *descAfter;

@end
