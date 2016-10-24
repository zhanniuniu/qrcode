//
//  QRcodeVC.m
//  二维码
//
//  Created by dlt_zhanlijun on 16/10/22.
//  Copyright © 2016年 dlt_zhanniuniu. All rights reserved.
//

#import "QRcodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanNetAnimation.h"
/*
 步骤如下：
 1.导入AVFoundation框架，引入<AVFoundation/AVFoundation.h>
 2.设置一个用于显示扫描的view
 3.实例化AVCaptureSession、AVCaptureVideoPreviewLayer
 */
@interface QRcodeVC ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationBarDelegate,UINavigationControllerDelegate>
{
    
    AVCaptureDeviceInput *input;
    //捕捉会话
    AVCaptureSession *_captureSession;
    //展示layer
    AVCaptureVideoPreviewLayer *_videoPreviewLayer;
    // 相框
    UIView *_viewPreview;
    //扫描框
    UIView *_boxView;
    
    //网格
    ScanNetAnimation *_anmation;
    
    //返回
    UIButton *_backBtn;
    //图片
    UIButton *_selectImageBtn;
    
    //手电筒
    UIButton *_flashlightBtn;

    
}

@end

@implementation QRcodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self getdata];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)getdata
{

    _viewPreview = [[UIView alloc] initWithFrame:self.view.frame];
    _viewPreview.backgroundColor = [UIColor clearColor];
    
    NSError *error;
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2.用captureDevice创建输入流
    input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //8.设置图层的frame
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    
    //9.将图层添加到预览view的图层上
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    //10.设置扫描范围
//    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    
    //10.1.扫描框
    _boxView = [[UIView alloc] initWithFrame:CGRectMake(_viewPreview.bounds.size.width * 0.2f, _viewPreview.bounds.size.height * 0.2f, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f,_viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f)];
    _boxView.backgroundColor = [UIColor clearColor];
    UIImageView *boximage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _boxView.frame.size.width, _boxView.frame.size.height)];
    boximage.image = [UIImage imageNamed:@"kk"];
    [_boxView addSubview:boximage];

    [_viewPreview addSubview:_boxView];
    

    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(_boxView.frame.origin.x, _boxView.frame.origin.y-50, _boxView.frame.size.width, 50)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.text = @"请将二维码放入扫描框内";
    textLabel.adjustsFontSizeToFitWidth= YES;
    [_viewPreview addSubview:textLabel];
    
    // 设置有效的扫描区域(为扫描框内的区域)
     captureMetadataOutput.rectOfInterest = CGRectMake(_boxView.frame.origin.y/_viewPreview.frame.size.height,
                                        
                                        _boxView.frame.origin.x/_viewPreview.frame.size.width,
                                        
                                        _boxView.frame.size.height/_viewPreview.frame.size.height,
                                        
                                        _boxView.frame.size.width/_viewPreview.frame.size.width);
    
    

    
    //左侧的view
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (_viewPreview.frame.size.width-_boxView.frame.size.width)/2.0, _viewPreview.frame.size.height)];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [_viewPreview addSubview:leftView];
    //右侧的view
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake((_viewPreview.frame.size.width-_boxView.frame.size.width)/2.0+_boxView.frame.size.width, 0, (_viewPreview.frame.size.width-_boxView.frame.size.width)/2.0, _viewPreview.frame.size.height)];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [_viewPreview addSubview:rightView];
    
    //最上部view
    UIImageView* upView = [[UIImageView alloc] initWithFrame:CGRectMake((_viewPreview.frame.size.width-_boxView.frame.size.width)/2.0, 0, _boxView.frame.size.width, _boxView.frame.origin.y)];
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [_viewPreview addSubview:upView];
    
    //底部view
    UIImageView * downView = [[UIImageView alloc] initWithFrame:CGRectMake((_viewPreview.frame.size.width-_boxView.frame.size.width)/2.0, CGRectGetMaxY(_boxView.frame), _boxView.frame.size.width, _viewPreview.frame.size.height-_boxView.frame.size.height-upView.frame.size.height)];
    downView.alpha = 0.5;
    downView.backgroundColor = [UIColor blackColor];
    [_viewPreview addSubview:downView];
    
    
    [self.view addSubview:_viewPreview];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame= CGRectMake(20, 30, 30, 30);
    _backBtn.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    _backBtn.layer.cornerRadius = 15;
    [_backBtn setImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backButtonProsssed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    
    
    _selectImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectImageBtn.frame= CGRectMake(20+100, 30, 30, 30);
    _selectImageBtn.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    _selectImageBtn.layer.cornerRadius = 15;
    [_selectImageBtn setImage:[UIImage imageNamed:@"imageslect1"] forState:UIControlStateNormal];
    [_selectImageBtn addTarget:self action:@selector(selectImageButtonProssed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectImageBtn];
    
    _flashlightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _flashlightBtn.frame= CGRectMake(20+100+30+30, 30, 30, 30);
    _flashlightBtn.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    _flashlightBtn.layer.cornerRadius = 15;
    [_flashlightBtn setImage:[UIImage imageNamed:@"flashlighton1"] forState:UIControlStateNormal];
    [_flashlightBtn addTarget:self action:@selector(flashlightButtonProsssed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_flashlightBtn];

    
    _anmation =  [[ScanNetAnimation alloc] init];
    
    [_anmation startAnimatingWithRect:_boxView.bounds InView:_boxView Image:[UIImage imageNamed:@"1"]];
    
    
    //10.开始扫描
    [_captureSession startRunning];
    
    return  YES;
}


- (void)flashlightButtonProsssed:(UIButton *)btn
{
    if ([btn.imageView.image isEqual:[UIImage imageNamed:@"flashlighton1"]]) {
        [btn setImage:[UIImage imageNamed:@"flashlightoff1"] forState:UIControlStateNormal];
        
        [input.device lockForConfiguration:nil];
        input.device.torchMode = AVCaptureTorchModeOn;
        [input.device unlockForConfiguration];
        
    }else
    {
     [btn setImage:[UIImage imageNamed:@"flashlighton1"] forState:UIControlStateNormal];
        
        [input.device lockForConfiguration:nil];
        input.device.torchMode = AVCaptureTorchModeOff;
        [input.device unlockForConfiguration];
    }
}

- (void)selectImageButtonProssed
{
    [self LocalPhoto];
}

- (void)backButtonProsssed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  本地相册
 */
-(void)LocalPhoto
{
    
    UIImagePickerController *photoPickerController = [[UIImagePickerController alloc] init];
    photoPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoPickerController.allowsEditing = NO;
    photoPickerController.delegate = self;
    [self presentViewController:photoPickerController animated:YES completion:nil];
    
}
#pragma Mark 识别二维码

- (NSString *)getdataFromimage:(UIImage *)image
{
//    _timer.fireDate=[NSDate distantFuture];
    

        //1.初始化扫描仪，设置设别类型和识别质量
        
        CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        
        //2.扫描获取的特征组
        
        NSArray*features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        
        if(features.count>0) {
            
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            
            NSString *scannedResult = feature.messageString;
            

            
            return scannedResult;
        }else{
            return nil;
        }
        
 

}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            
            [_captureSession stopRunning];
            _captureSession = nil;
            [_anmation stopAnimating];
            [_videoPreviewLayer removeFromSuperlayer];
            
            if (self.delegate&&[self.delegate respondsToSelector:@selector(QRcodegetdata:)]) {
                [self.delegate QRcodegetdata:metadataObj.stringValue];
            }
            [self backButtonProsssed];

        }
        
        
    }
    
    
    
}

#pragma mark - UIImagePickerCont≥rollerDelegate
/*当选择一张图片后进入*/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    
    [self dismissViewControllerAnimated:YES completion:^{
       NSString *a = [self getdataFromimage:image];
        if (a!=NULL) {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(QRcodegetdata:)]) {
                [self.delegate QRcodegetdata:a];
            }
            [self backButtonProsssed];
        }
        else
        {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"扫描失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alter show];
        }
    }];

}





@end
