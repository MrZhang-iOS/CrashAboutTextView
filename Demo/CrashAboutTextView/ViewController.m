//
//  ViewController.m
//  CrashAtTextViewForArray
//
//  Created by zhangwei on 2021/9/4.
//

#import "ViewController.h"
#import "CrashInViewController.h"

/// 经测试文本内容是数字、字母、空格时不会造成Crash，但是如果包含汉字就会Crash！！！
NSString * const g_pTextContent = @"经测试文本内容是数字、字母、空格时不会Crash，但是如果包含汉字就会Crash！！！";

@interface ViewController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *tapBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 300)];
    [_label setBackgroundColor:[UIColor greenColor]];
    [_label setFont:[UIFont systemFontOfSize:24]];
    [_label setTextColor:[UIColor whiteColor]];
    [_label setText:g_pTextContent];
    [_label setNumberOfLines:0];
    [self.view addSubview:_label];
    
    _tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tapBtn setFrame:CGRectMake(10, 400, 300, 44)];
    [_tapBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_tapBtn setTitle:@"点击后Crash" forState:(UIControlStateNormal)];
    [_tapBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [_tapBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateHighlighted)];
    [_tapBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tapBtn];
}

- (void)tapAction:(UIButton *)button {
    CrashInViewController *tmpVC = [[CrashInViewController alloc] init];
    UINavigationController *tmpNav = [[UINavigationController alloc] initWithRootViewController:tmpVC];
    [self presentViewController:tmpNav animated:YES completion:nil];
}

@end
