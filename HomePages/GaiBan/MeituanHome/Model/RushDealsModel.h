//
//  RushDealsModel.h
//  GaiBan
//
//  Created by Meng Fan on 16/9/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RushDealsModel : NSObject

@property(nonatomic, assign) NSNumber *dt;
@property(nonatomic, copy) NSString *brandname;
@property(nonatomic, copy) NSString *cate;
@property(nonatomic, copy) NSString *range;
@property(nonatomic, copy) NSString *mealcount;

@property(nonatomic, assign) NSNumber *status;
@property(nonatomic, copy) NSString *mtitle;
@property(nonatomic, copy) NSString *mdcLogoUrl;
@property(nonatomic, copy) NSString *smstitle;
@property(nonatomic, strong) NSMutableArray *campaigns;

@property(nonatomic, copy) NSString *squareimgurl;
@property(nonatomic, assign) NSNumber *ctype;
@property(nonatomic, copy) NSString *mlls;
@property(nonatomic, copy) NSString *subcate;
@property(nonatomic, assign) NSNumber *id;

@property(nonatomic, strong) NSMutableArray *attrJson;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, assign) NSNumber *price;
@property(nonatomic, assign) NSNumber *festcanuse;
@property(nonatomic, assign) NSNumber *value;

@property(nonatomic, copy) NSString *coupontitle;
//没处理
//@property(nonatomic, strong) NSNumber *rate-count;
@property(nonatomic, assign) NSNumber *rating;
@property(nonatomic, copy) NSString *cateDesc;
@property(nonatomic, assign) NSNumber *nobooking;

@property(nonatomic, assign) NSNumber *campaignprice;
@property(nonatomic, copy) NSString *imgurl;

@end
