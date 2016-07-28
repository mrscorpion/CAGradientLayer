//
//  ViewController.m
//  CAGradientLayer
//
//  Created by 清风 on 16/7/28.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import "ViewController.h"
#import "PathView.h"
#import "RYGradientAnimation.h"

@interface ViewController ()
{
    CAShapeLayer * _trackLayer;
}
@property (strong, nonatomic) UIView *circleView;
@property (nonatomic, strong) UIView *bar;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpGradientBar];
    
    [self setUpGradientLabel];
    
    [self setUpGradientCircle];
}
- (void)setUpGradientBar
{
    self.bar = [[UIView alloc] initWithFrame:CGRectMake(100, 120, 20, 100)];
    self.bar.backgroundColor = [UIColor clearColor];//[UIColor blueColor];
    [self.view addSubview:self.bar];
    
    //  初始化渐变图层
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.bar.bounds;
    [self.bar.layer addSublayer:layer];
    
    //  设置渐变图层的颜色数组
    layer.colors = @[(id)[UIColor colorWithRed:1 green:0 blue:0 alpha:1].CGColor,
                     (id)[UIColor colorWithRed:0 green:1 blue:0 alpha:1].CGColor,
                     (id)[UIColor colorWithRed:0 green:0 blue:1 alpha:1].CGColor
                     ];
//    layer.colors = @[(id)[self randomColor].CGColor, (id)[self randomColor].CGColor,(id)[self randomColor].CGColor]; //@[(id)[UIColor redColor].CGColor,
//                     (id)[UIColor orangeColor].CGColor,
//                     (id)[UIColor yellowColor].CGColor,
//                     (id)[UIColor greenColor].CGColor,
//                     (id)[UIColor cyanColor].CGColor,
//                     (id)[UIColor blueColor].CGColor,
//                     (id)[UIColor purpleColor].CGColor];
    //  设置透明度
//    layer.opacity = 0.7;
//    //  设置起始点
    layer.startPoint = CGPointMake(0.5, 0);
    layer.endPoint = CGPointMake(0.5, 1);
    //  设置颜色渐变的百分比数组
//    layer.locations = @[@0.5, @0.5]; //@[@0.2, @0.2,@0.1, @0.1,@0.1, @0.2,@0.1];
}



- (void)setUpGradientLabel
{
    // 创建UILabel
    UILabel *label = [[UILabel alloc] init];
    label.text = @"致给远方的大海 / 只言片语";
    [label sizeToFit];
    label.center = CGPointMake(200, 300);
    
    // 疑问：label只是用来做文字裁剪，能否不添加到view上。
    // 必须要把Label添加到view上，如果不添加到view上，label的图层就不会调用drawRect方法绘制文字，也就没有文字裁剪了。
    // 如何验证，自定义Label,重写drawRect方法，看是否调用,发现不添加上去，就不会调用
    [self.view addSubview:label];
    
    // 创建渐变层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = label.frame;
    // 设置渐变层的颜色，随机颜色渐变
    gradientLayer.colors = @[(id)[self randomColor].CGColor, (id)[self randomColor].CGColor,(id)[self randomColor].CGColor];
    
    // 疑问:渐变层能不能加在label上
    // 不能，mask原理：默认会显示mask层底部的内容，如果渐变层放在mask层上，就不会显示了
    // 添加渐变层到控制器的view图层上
    [self.view.layer addSublayer:gradientLayer];
    
    // mask层工作原理:按照透明度裁剪，只保留非透明部分，文字就是非透明的，因此除了文字，其他都被裁剪掉，这样就只会显示文字下面渐变层的内容，相当于留了文字的区域，让渐变层去填充文字的颜色。
    // 设置渐变层的裁剪层
    gradientLayer.mask = label.layer;
    
    // 注意:一旦把label层设置为mask层，label层就不能显示了,会直接从父层中移除，然后作为渐变层的mask层，且label层的父层会指向渐变层，这样做的目的：以渐变层为坐标系，方便计算裁剪区域，如果以其他层为坐标系，还需要做点的转换，需要把别的坐标系上的点，转换成自己坐标系上点，判断当前点在不在裁剪范围内，比较麻烦。
    // 父层改了，坐标系也就改了，需要重新设置label的位置，才能正确的设置裁剪区域。
    label.frame = gradientLayer.bounds;
    // 利用定时器，快速的切换渐变颜色，就有文字颜色变化效果
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(textColorChange)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}
// 随机颜色方法
- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}
// 定时器触发方法
- (void)textColorChange
{
    _gradientLayer.colors = @[(id)[self randomColor].CGColor,
                              (id)[self randomColor].CGColor,
                              (id)[self randomColor].CGColor,
                              (id)[self randomColor].CGColor,
                              (id)[self randomColor].CGColor];
}


- (void)setUpGradientCircle
{
//    self.circleView = [[UIView alloc] initWithFrame:CGRectMake(200, 500, 100, 100)];
//    [self.view addSubview:self.circleView];
////    NSLog(@"-xxxx-%f=====%@",self.circleView.bounds.size.height,self.circleView.constraints);
//    CGSize size =    [self.circleView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
//    
//    CAGradientLayer *colorLayer = [CAGradientLayer layer];
//    colorLayer.frame    = (CGRect){CGPointZero, CGSizeMake(200, 200)};
//    colorLayer.position = self.view.center;
//    [self.view.layer addSublayer:colorLayer];
//    
//        // 颜色分配
//        colorLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,
//                              (__bridge id)[UIColor greenColor].CGColor
//                            ];
//        [CATransaction  setDisableActions:NO];
//    
//        // 颜色分割线
//        colorLayer.locations  = @[@(0.25)];
//    
//        // 起始点
//        colorLayer.startPoint = CGPointMake(0, 0);
//    
//        // 结束点
//        colorLayer.endPoint   = CGPointMake(0.3, 0.3);
    
    
PathView * path = [[PathView alloc]initWithFrame:CGRectMake(50, 50, 200, 200)];
    path.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:path];
    
////    4 带有圆弧的矩形
//        [[UIColor redColor] setStroke];
//        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:(CGRect){5,50,100,60} cornerRadius:20.0f];
//        path.lineWidth = 2.0;
//        path.lineCapStyle = kCGLineCapRound;
//        path.lineJoinStyle = kCGLineCapRound;
//        [path stroke];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
