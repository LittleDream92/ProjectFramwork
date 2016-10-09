//
//  ViewController.m
//  GaiBan
//
//  Created by Meng Fan on 16/9/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "ViewController.h"

#import "OPDataResponse.h"
#import "JZNetworkSingleton.h"
#import "JZHomepageModel.h"
#import "JZHomeShopModel.h"

#import "HomeMenuCell.h"
#import "JZHomeJingxuanCell.h"
#import "JZHomeNewCell.h"
#import "JZHomeShopCell.h"
#import "JZHomeBlock2Cell.h"
#import "JZAlbumCell.h"


@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//数据源
@property (nonatomic, strong) NSMutableArray *likeArray;
@property (nonatomic, strong) JZHomepageModel *homepageM;

@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) JZHometoptenModel *topenModel;
@property (nonatomic, strong) JZHomespecialModel *specialModel;

@property (nonatomic, strong) NSMutableArray *bannersArray;
@property (nonatomic, strong) NSMutableArray *recommendArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"糯米";
    [self setupData];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupViews
- (void)setupData {
    self.likeArray = [[NSMutableArray alloc] init];
    
    self.bannersArray = [[NSMutableArray alloc] init];
    self.categoryArray = [[NSMutableArray alloc] init];
    self.recommendArray = [[NSMutableArray alloc] init];}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_homepageM != nil) {
        NSInteger num = 5;
        if (_likeArray.count>0) {
            num = 1+_likeArray.count;
        }
        return num;
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *cellIndentifier = @"menucell";
        HomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[HomeMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier menuArray:_categoryArray];
        }
//        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.row == 1){
        static NSString *cellIndentifier = @"JingXuanCell";
        JZHomeJingxuanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (_topenModel) {
            [cell setListArray:_topenModel.list];
            [cell setActiveTimeArray:_topenModel.activetime];
        }
        
        return cell;
    }else if (indexPath.row == 2){
        static NSString *cellIndentifier = @"NewCell";
        JZHomeNewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (_specialModel.block_1) {
            [cell setHomeNewDataDic:_specialModel.block_1];
        }
        //赋值
        return cell;
    }else if (indexPath.row == 3){
        static NSString *cellIndentifier = @"cell3";
        JZHomeBlock2Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            if (_specialModel.block_2) {
                cell = [[JZHomeBlock2Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier array:_specialModel.block_2];
            }else{
                cell = [[JZHomeBlock2Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
        }
        
        //赋值
//        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 4){
        static NSString *cellIndentifier = @"cell4";
        JZAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[JZAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier frame:CGRectMake(0, 0, kScreenWidth, 132)];
        }
        if (_specialModel.block_3) {
            [cell setSpecialArray:_specialModel.block_3];
        }
        //赋值
//        cell.delegate = self;
        return cell;
    }else if (indexPath.row == 5){
        static NSString *cellIndentifier = @"normalCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        }
        
        cell.textLabel.text = @"猜你喜欢";
        //赋值
        return cell;
    }else{
        static NSString *cellIndentifier = @"shopCell";
        JZHomeShopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (_likeArray.count>0) {
            JZShopTuanModel *shopM = _likeArray[indexPath.row - 3];
            [cell setShopM:shopM];
        }
        //赋值
        return cell;
    }
}



#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 184;
    }else if(indexPath.row == 1){
        return 172;
    }else if (indexPath.row == 2){
        return 80;
    }else if (indexPath.row == 3){
        if (_specialModel.block_2) {
            return [JZHomeBlock2Cell tableView:tableView heightForRowAtIndexPath:indexPath withArray:_specialModel.block_2];
        }else{
            return 5;
        }
    }else if (indexPath.row == 4){
        return 132;
    }else if (indexPath.row == 5){
        return 36;
    }else{
        return 96;
    }
}



#pragma mark - network
- (void)requestData {
    [self getHotData];
    [self getRecommendData];
}

//获取数据
-(void)getHotData {
    //    url内部添加有签名加密，所以只能把url写死，不能动态的改变url
    NSString *url = @"http://app.nuomi.com/naserver/home/homepage?appid=ios&bduss=&channel=com_dot_apple&cityid=100010000&cuid=11a2e62839f7bed05437dcb826be61a0c47a515c&device=iPhone&ha=5&lbsidfa=ACAF9226-F987-417B-A708-C95D482A732D&location=39.989360%2C116.324490&logpage=Home&net=unknown&os=8.2&sheight=1334&sign=40c974d176568886ad0e72516645e23f&swidth=750&terminal_type=ios&timestamp=1442906717563&tn=ios&uuid=11a2e62839f7bed05437dcb826be61a0c47a515c&v=5.13.0";
    JZNetworkSingleton *request = [JZNetworkSingleton request];
    request.classModel = @"JZHomepageModel";
    
    __weak typeof(self) weakself = self;
    [request getDataWithURL:url params:nil success:^(OPDataResponse *responseObject) {
        NSLog(@"获取 首页 数据成功");
        if (responseObject.error) {
            NSLog(@"error:  %@",responseObject.error);
            return ;
        }
        _homepageM = responseObject.data;
        
        _bannersArray = [[NSMutableArray alloc] initWithArray:_homepageM.banners];
        _categoryArray = [[NSMutableArray alloc] initWithArray:_homepageM.category];
        _recommendArray = [[NSMutableArray alloc] initWithArray:_homepageM.recommend];
        _specialModel = _homepageM.special;
        _topenModel = _homepageM.topten;
        
        [weakself.tableView reloadData];

    } failure:^(NSError *error) {
        NSLog(@"获取 首页 数据失败");
        // 拿到当前的下拉刷新控件，结束刷新状态

    }];
}

//获取猜你喜欢数据
-(void)getRecommendData {
    
    NSString *url = @"http://app.nuomi.com/naserver/search/likeitem?appid=ios&bduss=&channel=com_dot_apple&cityid=100010000&cuid=11a2e62839f7bed05437dcb826be61a0c47a515c&device=iPhone&ha=5&lbsidfa=ACAF9226-F987-417B-A708-C95D482A732D&locate_city_id=100010000&location=39.989360%2C116.324490&logpage=Home&net=unknown&os=8.2&sheight=1334&sign=faf73b65333f52c39dbe7f9e1a3ec04c&sort_type=0&swidth=750&terminal_type=ios&timestamp=1442906717567&tn=ios&tuan_size=25&uuid=11a2e62839f7bed05437dcb826be61a0c47a515c&v=5.13.0";
    JZNetworkSingleton *request = [JZNetworkSingleton request];
    request.classModel = @"JZHomeShopModel";
    __weak typeof(self) weakself = self;
    [request getDataWithURL:url params:nil success:^(OPDataResponse *responseObject){
        NSLog(@"获取 猜你喜欢 数据成功");
        if (responseObject.error) {
            NSLog(@"error:  %@",responseObject.error);
            return ;
        }
        if (responseObject.code == 0) {
            JZHomeShopModel *homeShopM = responseObject.data;
            _likeArray = homeShopM.tuan_list;
            [weakself.tableView reloadData];
        }else{
            
        }
    } failure:^(NSError *error){
        NSLog(@"获取 猜你喜欢 数据失败");
        // 拿到当前的下拉刷新控件，结束刷新状态
    }];
}



@end
