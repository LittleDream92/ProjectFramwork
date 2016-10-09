//
//  RootViewController.m
//  GaiBan
//
//  Created by Meng Fan on 16/9/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "RootViewController.h"

#import "NetworkSingleton.h"

#import "MeiHomeMenuCell.h"
#import "RushCell.h"
#import "DiscountCell.h"
#import "HotQueueCell.h"
#import "RecommendCell.h"

#import "RushDataModel.h"
#import "RushDealsModel.h"
#import "DiscountModel.h"
#import "HotQueueModel.h"
#import "RecommendModel.h"


static NSString *const meiHomeMenuCellID = @"HomeMenuCellID";
static NSString *const rushCellID = @"RushCellID";
static NSString *const discountCellID = @"DiscountCellID";
static NSString *const hotQueueCellID = @"HotQueueCellID";
static NSString *const recommendCellID = @"recommendCellID";

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_menuArray;
    NSMutableArray *_rushArray; //抢购数据
    NSMutableArray *_discountArray; //折扣数据
    HotQueueModel *_hotQueueModel;  //热门排队数据
    NSMutableArray *_recommendArray;    //推荐
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"美团";
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [self setupData];
    [self setupNav];
    [self setupViews];
    
    [self refreshData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupViews
- (void)setupData {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"menuData" ofType:@"plist"];
    _menuArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];

    _rushArray = [NSMutableArray array];
    _discountArray = [NSMutableArray array];
    _hotQueueModel = [[HotQueueModel alloc] init];
    _recommendArray = [NSMutableArray array];
}

- (void)setupNav {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    backView.backgroundColor = navigationBarColor;
    [self.view addSubview:backView];
    //城市
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.frame = CGRectMake(10, 30, 40, 25);
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cityBtn setTitle:@"北京" forState:UIControlStateNormal];
    [backView addSubview:cityBtn];
    //
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cityBtn.frame), 38, 13, 10)];
    [arrowImage setImage:[UIImage imageNamed:@"icon_homepage_downArrow"]];
    [backView addSubview:arrowImage];
    //地图
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mapBtn.frame = CGRectMake(kScreenWidth-42, 30, 42, 30);
    [mapBtn setImage:[UIImage imageNamed:@"icon_homepage_map_old"] forState:UIControlStateNormal];
    [backView addSubview:mapBtn];
    
    //搜索框
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(arrowImage.frame)+10, 30, 200, 25)];
    //    searchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_home_searchBar"]];
    searchView.backgroundColor = RGB(7, 170, 153);
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 12;
    [backView addSubview:searchView];
    
    //
    UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 15, 15)];
    [searchImage setImage:[UIImage imageNamed:@"icon_homepage_search"]];
    [searchView addSubview:searchImage];
    
    UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 150, 25)];
    placeHolderLabel.font = [UIFont boldSystemFontOfSize:13];
    //    placeHolderLabel.text = @"请输入商家、品类、商圈";
    placeHolderLabel.text = @"鲁总专享版";
    placeHolderLabel.textColor = [UIColor whiteColor];
    [searchView addSubview:placeHolderLabel];
}


- (void)setupViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-49-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
//    [self setUpTableView];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 4) {
        return _recommendArray.count+1;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MeiHomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:meiHomeMenuCellID];
        if (cell == nil) {
            cell = [[MeiHomeMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:meiHomeMenuCellID menuArray:_menuArray];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.section == 1) {
        if (_rushArray.count == 0) {
            static NSString *cellIndentifier = @"nullCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }else {
            RushCell *cell = [tableView dequeueReusableCellWithIdentifier:rushCellID];
            if (cell == nil) {
                cell = [[RushCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rushCellID];
            }
            if (_rushArray.count!=0) {
                [cell setRushData:_rushArray];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if (indexPath.section == 2) {
        if (_discountArray.count == 0) {
            static NSString *cellIndentifier = @"nullCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            DiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:discountCellID];
            if (cell == nil) {
                cell = [[DiscountCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:discountCellID];
            }
            
            if (_discountArray.count != 0) {
                [cell setDiscountArray:_discountArray];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if (indexPath.section == 3) {
        if (_hotQueueModel ==nil) {
            static NSString *cellIndentifier = @"nullCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            HotQueueCell *cell = [tableView dequeueReusableCellWithIdentifier:hotQueueCellID];
            if (cell == nil) {
                cell = [[HotQueueCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:hotQueueCellID];
            }
            
            if (_hotQueueModel != nil) {
                [cell setHotQueue:_hotQueueModel];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else {
        if(indexPath.row == 0){
            static NSString *cellIndentifier = @"morecell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            
            cell.textLabel.text = @"猜你喜欢";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else{
            RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendCellID];
            if (cell == nil) {
                cell = [[RecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recommendCellID];
            }
            
            if(_recommendArray.count!=0){
                RecommendModel *recommend = _recommendArray[indexPath.row-1];
                [cell setRecommendData:recommend];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }

}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 180;
    }else if(indexPath.section == 1){
        if (_rushArray.count!=0) {
            return 120;
        }else{
            return 0.0;
        }
    }else if (indexPath.section == 2){
        if (_discountArray.count == 0) {
            return 0.0;
        }else{
            return 160.0;
        }
    }else if (indexPath.section == 3){
        if (_hotQueueModel.title == nil) {
            return 0.0;
        }else{
            return 50.0;
        }
    }else if(indexPath.section == 4){
        if (indexPath.row == 0) {
            return 35.0;
        }else{
            return 100.0;
        }
    }else{
        return 70.0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headerView.backgroundColor = RGB(239, 239, 244);
//    headerView.backgroundColor = [UIColor redColor];
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    footerView.backgroundColor = RGB(239, 239, 244);
//    footerView.backgroundColor = [UIColor yellowColor];
    return footerView;
}

#pragma mark - network
- (void)refreshData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getRushData];
        [self getDiscountData];
        [self getHotQueueData];
        [self getRecommendData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //主线程刷新UI
        });
    });
}

//抢购数据
- (void)getRushData {
    NSString *url = @"http://api.meituan.com/group/v1/deal/activity/1?__skck=40aaaf01c2fc4801b9c059efcd7aa146&__skcy=NF9S7jqv3TVBAoEURoapWJ5VBdQ%3D&__skno=FB6346F3-98FF-4B26-9C36-DC9022236CC3&__skts=1434530933.316028&__skua=bd6b6e8eadfad15571a15c3b9ef9199a&__vhost=api.mobile.meituan.com&ci=1&client=iphone&movieBundleVersion=100&msid=48E2B810-805D-4821-9CDD-D5C9E01BC98A2015-06-17-14-50363&ptId=iphone_5.7&userid=10086&utm_campaign=AgroupBgroupD100Fab_chunceshishuju__a__a___b1junglehomepagecatesort__b__leftflow___ab_gxhceshi__nostrategy__leftflow___ab_gxhceshi0202__b__a___ab_pindaochangsha__a__leftflow___ab_xinkeceshi__b__leftflow___ab_gxtest__gd__leftflow___ab_gxh_82__nostrategy__leftflow___ab_pindaoshenyang__a__leftflow___i_group_5_2_deallist_poitype__d__d___ab_b_food_57_purepoilist_extinfo__a__a___ab_trip_yidizhoubianyou__b__leftflow___ab_i_group_5_3_poidetaildeallist__a__b___ab_waimaizhanshi__b__b1___a20141120nanning__m1__leftflow___ab_pindaoquxincelue__a__leftflow___ab_i_group_5_5_onsite__b__b___ab_i_group_5_6_searchkuang__a__leftflow&utm_content=4B8C0B46F5B0527D55EA292904FD7E12E48FB7BEA8DF50BFE7828AF7F20BB08D&utm_medium=iphone&utm_source=AppStore&utm_term=5.7&uuid=4B8C0B46F5B0527D55EA292904FD7E12E48FB7BEA8DF50BFE7828AF7F20BB08D&version_name=5.7";
    
    __weak __typeof(self) weakself = self;
    [[NetworkSingleton sharedManager] getRushBuyResult:nil url:url successBlock:^(id responseBody) {
        if (weakself) {
            NSLog(@"抢购请求成功:%@", responseBody);
            NSDictionary *dataDic = [responseBody objectForKey:@"data"];
            RushDataModel *rushDataM = [RushDataModel objectWithKeyValues:dataDic];
            [_rushArray removeAllObjects];
            for (int i = 0; i < rushDataM.deals.count; i++) {
                RushDealsModel *deals = [RushDealsModel objectWithKeyValues:rushDataM.deals[i]];
                [_rushArray addObject:deals];
            }
            [weakself.tableView reloadData];
        
        }
    } failureBlock:^(NSString *error) {
        if (weakself) {
            NSLog(@"%@",error);
        }
    }];
    
}

//获取折扣数据
-(void)getDiscountData{
    NSString *urlStr = @"http://api.meituan.com/group/v1/deal/topic/discount/city/1?ci=1&client=iphone&movieBundleVersion=100&msid=48E2B810-805D-4821-9CDD-D5C9E01BC98A2015-06-17-14-50363&userid=10086&utm_campaign=AgroupBgroupD100Fab_chunceshishuju__a__a___b1junglehomepagecatesort__b__leftflow___ab_gxhceshi__nostrategy__leftflow___ab_gxhceshi0202__b__a___ab_pindaochangsha__a__leftflow___ab_xinkeceshi__b__leftflow___ab_gxtest__gd__leftflow___ab_gxh_82__nostrategy__leftflow___ab_pindaoshenyang__a__leftflow___i_group_5_2_deallist_poitype__d__d___ab_b_food_57_purepoilist_extinfo__a__a___ab_trip_yidizhoubianyou__b__leftflow___ab_i_group_5_3_poidetaildeallist__a__b___ab_waimaizhanshi__b__b1___a20141120nanning__m1__leftflow___ab_pindaoquxincelue__a__leftflow___ab_i_group_5_5_onsite__b__b___ab_i_group_5_6_searchkuang__a__leftflow&utm_content=4B8C0B46F5B0527D55EA292904FD7E12E48FB7BEA8DF50BFE7828AF7F20BB08D&utm_medium=iphone&utm_source=AppStore&utm_term=5.7&uuid=4B8C0B46F5B0527D55EA292904FD7E12E48FB7BEA8DF50BFE7828AF7F20BB08D&version_name=5.7";
    __weak __typeof(self) weakself = self;
    [[NetworkSingleton sharedManager] getDiscountResult:nil url:urlStr successBlock:^(id responseBody){
        NSLog(@"获取折扣数据成功");
        
        NSMutableArray *dataDic = [responseBody objectForKey:@"data"];
        [_discountArray removeAllObjects];
        for (int i = 0; i < dataDic.count; i++) {
            DiscountModel *discount = [DiscountModel objectWithKeyValues:dataDic[i]];
            [_discountArray addObject:discount];
        }
        
        [weakself.tableView reloadData];
        
    } failureBlock:^(NSString *error){
        NSLog(@"获取折扣数据失败：%@",error);
    }];
}

//请求热门排队数据
-(void)getHotQueueData{
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    NSString *urlStr = [NSString stringWithFormat:@"http://api.meituan.com/group/v1/itemportal/position/%f,%f?__skck=40aaaf01c2fc4801b9c059efcd7aa146&__skcy=x6Fyq0RW3Z7ZtUXKPpRXPbYUGRE%3D&__skno=348FAC89-38E1-4880-A550-E992DB9AE44E&__skts=1434530933.451634&__skua=bd6b6e8eadfad15571a15c3b9ef9199a&__vhost=api.mobile.meituan.com&ci=1&cityId=1&client=iphone&movieBundleVersion=100&msid=48E2B810-805D-4821-9CDD-D5C9E01BC98A2015-06-17-14-50363&userid=10086&utm_campaign=AgroupBgroupD100Fab_chunceshishuju__a__a___b1junglehomepagecatesort__b__leftflow___ab_gxhceshi__nostrategy__leftflow___ab_gxhceshi0202__b__a___ab_pindaochangsha__a__leftflow___ab_xinkeceshi__b__leftflow___ab_gxtest__gd__leftflow___ab_gxh_82__nostrategy__leftflow___ab_pindaoshenyang__a__leftflow___i_group_5_2_deallist_poitype__d__d___ab_b_food_57_purepoilist_extinfo__a__a___ab_trip_yidizhoubianyou__b__leftflow___ab_i_group_5_3_poidetaildeallist__a__b___ab_waimaizhanshi__b__b1___a20141120nanning__m1__leftflow___ab_pindaoquxincelue__a__leftflow___ab_i_group_5_5_onsite__b__b___ab_i_group_5_6_searchkuang__a__leftflow&utm_content=4B8C0B46F5B0527D55EA292904FD7E12E48FB7BEA8DF50BFE7828AF7F20BB08D&utm_medium=iphone&utm_source=AppStore&utm_term=5.7&uuid=4B8C0B46F5B0527D55EA292904FD7E12E48FB7BEA8DF50BFE7828AF7F20BB08D&version_name=5.7",delegate.latitude,delegate.longitude];
    //    NSLog(@"热门排队urlstr:    %@",urlStr);
    __weak __typeof(self) weakself = self;
    NSLog(@"最新的经纬度：%f,%f",delegate.latitude,delegate.longitude);
    
    [[NetworkSingleton sharedManager] getHotQueueResult:nil url:urlStr successBlock:^(id responseBody){
        NSLog(@"热门排队：成功");
        NSDictionary *dataDic = [responseBody objectForKey:@"data"];
        _hotQueueModel = [HotQueueModel objectWithKeyValues:dataDic];
        
        [weakself.tableView reloadData];
    } failureBlock:^(NSString *error){
        NSLog(@"热门排队：%@",error);
    }];
}

//推荐数据
-(void)getRecommendData{
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *urlStr = [NSString stringWithFormat:@"http://api.meituan.com/group/v1/recommend/homepage/city/1?__skck=40aaaf01c2fc4801b9c059efcd7aa146&__skcy=mrUZYo7999nH8WgTicdfzaGjaSQ=&__skno=51156DC4-B59A-4108-8812-AD05BF227A47&__skts=1434530933.303717&__skua=bd6b6e8eadfad15571a15c3b9ef9199a&__vhost=api.mobile.meituan.com&ci=1&client=iphone&limit=40&movieBundleVersion=100&msid=48E2B810-805D-4821-9CDD-D5C9E01BC98A2015-06-17-14-50363&offset=0&position=%f,%f&userId=10086&userid=10086&utm_campaign=AgroupBgroupD100Fab_chunceshishuju__a__a___b1junglehomepagecatesort__b__leftflow___ab_gxhceshi__nostrategy__leftflow___ab_gxhceshi0202__b__a___ab_pindaochangsha__a__leftflow___ab_xinkeceshi__b__leftflow___ab_gxtest__gd__leftflow___ab_gxh_82__nostrategy__leftflow___ab_pindaoshenyang__a__leftflow___i_group_5_2_deallist_poitype__d__d___ab_b_food_57_purepoilist_extinfo__a__a___ab_trip_yidizhoubianyou__b__leftflow___ab_i_group_5_3_poidetaildeallist__a__b___ab_waimaizhanshi__b__b1___a20141120nanning__m1__leftflow___ab_pind",delegate.latitude,delegate.longitude];
    //    NSLog(@"推荐数据url：%@",urlStr);
    NSLog(@"最新的经纬度：%f,%f",delegate.latitude,delegate.longitude);
    
    
    __weak __typeof(self) weakself = self;
    [[NetworkSingleton sharedManager] getRecommendResult:nil url:urlStr successBlock:^(id responseBody){
        NSLog(@"推荐：成功");
        NSMutableArray *dataDic = [responseBody objectForKey:@"data"];
        [_recommendArray removeAllObjects];
        for (int i = 0; i < dataDic.count; i++) {
            RecommendModel *recommend = [RecommendModel objectWithKeyValues:dataDic[i]];
            [_recommendArray addObject:recommend];
        }
        
        [weakself.tableView reloadData];
        
    } failureBlock:^(NSString *error){
        NSLog(@"推荐：%@",error);
    }];
}

@end
