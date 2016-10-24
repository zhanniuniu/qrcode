//
//  QRcodeVC.h
//  二维码
//
//  Created by dlt_zhanlijun on 16/10/22.
//  Copyright © 2016年 dlt_zhanniuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QRcodeDelegate <NSObject>

- (void)QRcodegetdata:(NSString *)datastring;

@end

@interface QRcodeVC : UIViewController
@property (nonatomic,assign)id delegate;
@end
