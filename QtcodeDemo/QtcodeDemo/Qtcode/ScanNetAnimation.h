//
//  ScanNetAnimation.h
//  二维码
//
//  Created by dlt_zhanlijun on 16/10/24.
//  Copyright © 2016年 dlt_zhanniuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanNetAnimation : UIView
/**
 *  开始扫码网格效果
 *
 *  @param animationRect 显示在parentView中得区域
 *  @param parentView    动画显示在UIView
 *  @param image     扫码线的图像
 */
- (void)startAnimatingWithRect:(CGRect)animationRect InView:(UIView*)parentView Image:(UIImage*)image;

/**
 *  停止动画
 */
- (void)stopAnimating;

@end
