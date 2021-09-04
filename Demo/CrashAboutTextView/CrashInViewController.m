//
//  CrashInViewController.m
//  CrashAtTextViewForArray
//
//  Created by zhangwei on 2021/9/4.
//

#import "CrashInViewController.h"

UIKIT_EXTERN NSString * const g_pTextContent;

@interface CrashInViewController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation CrashInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 350, 300, 120)];
    [_label setBackgroundColor:[UIColor greenColor]];
    [_label setFont:[UIFont systemFontOfSize:20]];
    [_label setTextColor:[UIColor whiteColor]];
    [_label setText:g_pTextContent];
    [_label setNumberOfLines:0];
    [self.view addSubview:_label];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, 300, 120)];
    [_textView setBackgroundColor:[UIColor redColor]];
    [_textView setText:g_pTextContent];
    [self.view addSubview:_textView];
}

@end
