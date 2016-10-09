//
//  ViewController.m
//  CommonSettingDemo
//
//  Created by Meng Fan on 16/9/5.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
#pragma 6.快速求总和 最大值 最小值 和 平均值
//    NSArray 快速求总和 最大值 最小值 和 平均值
    NSArray *array = [NSArray arrayWithObjects:@"2.0", @"2.3", @"3.0", @"4.0", @"10", nil];
    CGFloat sum = [[array valueForKeyPath:@"@sum.floatValue"] floatValue];
    CGFloat avg = [[array valueForKeyPath:@"@avg.floatValue"] floatValue];
    CGFloat max =[[array valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat min =[[array valueForKeyPath:@"@min.floatValue"] floatValue];
    NSLog(@"%f\n%f\n%f\n%f",sum,avg,max,min);
    
#pragma 7.修改Label中不同文字颜色
    [self editStringColor:self.label.text editStr:@"我是" color:[UIColor blueColor]];
    
#pragma 10.iOS 开发中一些相关的路径
  /*  模拟器的位置:
    /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs
    
    文档安装位置:
    /Applications/Xcode.app/Contents/Developer/Documentation/DocSets
    
    插件保存路径:
    ~/Library/ApplicationSupport/Developer/Shared/Xcode/Plug-ins
    
    自定义代码段的保存路径:
    ~/Library/Developer/Xcode/UserData/CodeSnippets/
    如果找不到CodeSnippets文件夹，可以自己新建一个CodeSnippets文件夹。
    
    证书路径
    ~/Library/MobileDevice/Provisioning Profiles
    获取 iOS 路径的方法
    获取家目录路径的函数
    NSString *homeDir = NSHomeDirectory(); */
    
    //获取Documents目录路径的方法
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths1 objectAtIndex:0];
    
    //获取Documents目录路径的方法
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths2 objectAtIndex:0];
    
//    获取tmp目录路径的方法：
    NSString *tmpDir = NSTemporaryDirectory();
    
#pragma 12.自动处理键盘事件，实现输入框防遮挡的插件
//    IQKeyboardManager
//https://github.com/hackiftekhar/IQKeyboardManager
}

#pragma 7.修改Label中不同文字颜色
- (void)editStringColor:(NSString *)string editStr:(NSString *)editStr color:(UIColor *)color {
    // string为整体字符串, editStr为需要修改的字符串
    NSRange range = [string rangeOfString:editStr];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    // 设置属性修改字体颜色UIColor与大小UIFont
    [attribute addAttributes:@{NSForegroundColorAttributeName:color} range:range];
    self.label.attributedText = attribute;
    
#pragma mark -在应用中打电话
//     UIApplication.sharedApplication().openURL(NSURL(string :"tel://18205254911")!)
#pragma mark -在应用中发短信
//     UIApplication.sharedApplication().openURL(NSURL(string :"sms://18205254911")!)
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 19.去掉UITableView的section的粘性，使其不会悬停
////有时候使用UITableView所实现的列表，会使用到section，但是又不希望它粘在最顶上而是跟随滚动而消失或者出现
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == _tableView) {
//        CGFloat sectionHeaderHeight = 36;
//        
//        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        }
//    }
//}

@end
