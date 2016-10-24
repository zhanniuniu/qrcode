//
//  ViewController.m
//  QtcodeDemo
//
//  Created by dlt_zhanlijun on 16/10/24.
//  Copyright © 2016年 dlt_zhanniuniu. All rights reserved.
//

#import "ViewController.h"
#import "QRcodeVC.h"
@interface ViewController ()<QRcodeDelegate>
{
    UILabel *_textLabel;
    UIButton *_qtCodeBtn;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 200)];
    _textLabel.textColor = [UIColor redColor];
    _textLabel.backgroundColor = [UIColor yellowColor];
    _textLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_textLabel];
    
    _qtCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _qtCodeBtn.frame = CGRectMake(100, CGRectGetMaxY(_textLabel.frame)+20, 50, 50);
    [_qtCodeBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [_qtCodeBtn addTarget:self action:@selector(getqtcode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_qtCodeBtn];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getqtcode
{
    QRcodeVC *a = [[QRcodeVC alloc] init];
    a.delegate = self;
    [self presentViewController:a animated:YES completion:nil];
}

#pragma mark QRcodeDelegate
-(void)QRcodegetdata:(NSString *)datastring
{
    NSLog(@"返回结果%@",datastring);
    _textLabel.text = datastring;
}

@end
