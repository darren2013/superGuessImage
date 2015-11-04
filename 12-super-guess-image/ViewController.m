//
//  ViewController.m
//  12-super-guess-image
//
//  Created by 杜东方 on 15/11/1.
//  Copyright © 2015年 private. All rights reserved.
//

#import "ViewController.h"
#import "DDQuestion.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *countView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UIButton *coinView;

@property (weak, nonatomic) IBOutlet UIButton *iconView;

//记录图片的原始位置
@property(nonatomic,assign) CGRect oldFrame;

@property(nonatomic,weak)UIButton *coverView;

@property(nonatomic,strong)NSArray *questions;

@property(nonatomic,assign)int index;

@property (weak, nonatomic) IBOutlet UIButton *nextClickView;

@property (weak, nonatomic) IBOutlet UIView *answersView;

@property (weak, nonatomic) IBOutlet UIView *optionsView;


- (IBAction)tipClick;

- (IBAction)helpClick;

- (IBAction)bigImageClick;

- (IBAction)nextClick;
- (IBAction)iconClick;

@end

@implementation ViewController

//隐藏状态栏
//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

//显示状态栏
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   // NSLog(@"%@",NSHomeDirectory());
    
//    self.countView.text = [NSString stringWithFormat:@"1/%zd",self.questions.count];
//    
//    if (self.questions.count > 0) {
//        [self showQuestion:self.questions[0]];
//    }
    
    self.index--;
    [self nextClick];
}


//懒加载数据
- (NSArray *)questions{
    if (_questions == nil) {
        _questions = [DDQuestion questionList];
    }
    
    return _questions;
}

- (IBAction)tipClick {
}

- (IBAction)helpClick {
}

- (IBAction)bigImageClick {
    //记录icon最初的位置
    self.oldFrame = self.iconView.frame;
    
    CGFloat iconW = self.view.frame.size.width;
    CGFloat iconH = iconW;
    CGFloat iconX = 0;
    CGFloat iconY = (self.view.frame.size.height - iconH) / 2;
    
    //生成遮盖层
    UIButton *coverView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:coverView];
    self.coverView = coverView;
    coverView.frame = self.view.bounds;
    coverView.backgroundColor = [UIColor blackColor];
    //通过控制透明度，来产生动画
    coverView.alpha = 0;
    
    
    [self.view bringSubviewToFront:self.iconView];
    
    [UIView animateWithDuration:1 animations:^{
        coverView.alpha = 0.5;
        self.iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    }];
    
    
    [coverView addTarget:self action:@selector(clickToSmallImage) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)clickToSmallImage{
    [UIView animateWithDuration:1 animations:^{
        self.iconView.frame = self.oldFrame;
        self.coverView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.coverView removeFromSuperview];
        }
    }];
}

- (IBAction)nextClick {
    [self.optionsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.index ++;
    DDQuestion *question = self.questions[self.index];
    [self showQuestion:question];
    self.nextClickView.enabled = !(self.index == self.questions.count - 1);
    
    [self addAnswerButton:question];
    
    [self addOptionButtons:question];
}


- (void) addAnswerButton:(DDQuestion*)question{
    //生成答案按钮
    
    //生成新的按钮之前要把上次创建的按钮给清空掉
    [self.answersView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat answerW = 35;
    CGFloat answerH = 35;
    CGFloat answerY = 0;
    NSInteger count = question.answer.length;
    CGFloat margin = 10;
    CGFloat marginLeft = (self.view.frame.size.width - count*answerW - (count-1)*margin) / 2;
    
    for (int i=0; i < count; i++) {
        UIButton *answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.answersView addSubview:answerBtn];
        CGFloat answerX = marginLeft + i*(answerW + margin);
        
        answerBtn.frame = CGRectMake(answerX, answerY, answerW, answerH);
        [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[answerBtn setBackgroundColor:[UIColor whiteColor]];
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        
        [answerBtn addTarget:self action:@selector(answerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }

}

//通过tag进行按钮查找
- (void) answerBtnClick:(UIButton*)answerBtn{
    
    if(answerBtn.currentTitle == nil){
        return;
    }
    
    [self changeAnswerBtnColor:[UIColor blackColor]];
    
    for (UIButton *optionBtn in self.optionsView.subviews) {
        if (answerBtn.tag == optionBtn.tag) {
            optionBtn.hidden = NO;
            break;
        }
    }
    
    [answerBtn setTitle:nil forState:UIControlStateNormal];
}

- (void) addOptionButtons:(DDQuestion*)question{
    
    
    CGFloat optionW = 35;
    CGFloat optionH = 35;
    int totalColumn = 7;
    CGFloat marginY = 15;
    
    CGFloat marginLeft = (self.optionsView.frame.size.width - totalColumn*optionW) / (totalColumn + 1);
    
    for (int i=0; i < question.options.count; i++) {
        int row = i / totalColumn;
        int columnIndex = i % totalColumn;
        
        CGFloat optionX = marginLeft + columnIndex*(optionW+marginLeft);
        CGFloat optionY = row * (optionH + marginY);
        
        UIButton *optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.optionsView addSubview:optionBtn];
        optionBtn.frame = CGRectMake(optionX, optionY, optionW, optionH);
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
        [optionBtn setTitle:question.options[i] forState:UIControlStateNormal];
        [optionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        optionBtn.tag = i;
        [optionBtn addTarget:self action:@selector(optionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (void) optionBtnClick:(UIButton*)sender{
    
    
    for (UIButton *answerBtn in self.answersView.subviews) {
        //获取按钮的文字
        //NSString *title = [answerBtn titleForState:UIControlStateNormal];
        if ([answerBtn currentTitle] == nil) {
            [answerBtn setTitle:sender.currentTitle forState:UIControlStateNormal];
            answerBtn.tag = sender.tag;
            sender.hidden = YES;
            break;
        }
    }
    
    BOOL isFull = YES;
    NSMutableString *inputAnswers = [NSMutableString string];
    
    for (UIButton *answerBtn in self.answersView.subviews) {
        
        if (answerBtn.currentTitle == nil) {
            isFull = NO;
            break;
        }
        
        [inputAnswers appendString:answerBtn.currentTitle];
    }
    
    if (isFull) {
        DDQuestion *currentQuestion = self.questions[self.index];
        
        if ([currentQuestion.answer isEqualToString:inputAnswers]) {
            [self changeAnswerBtnColor:[UIColor blueColor]];
        }else{
            [self changeAnswerBtnColor:[UIColor redColor]];
        }
    }
    
    
}


- (void) changeAnswerBtnColor:(UIColor*)color{
    
    for (UIButton* answerBtn in self.answersView.subviews) {
        [answerBtn setTitleColor:color forState:UIControlStateNormal];
    }
}

- (void) showQuestion:(DDQuestion*)question{
    self.countView.text = [NSString stringWithFormat:@"%d/%lu",self.index + 1,self.questions.count];
    self.titleView.text = question.title;
    [self.iconView setImage:[UIImage imageNamed:question.icon] forState:UIControlStateNormal];
}

- (IBAction)iconClick {
    if (self.coverView) {
        [self clickToSmallImage];
    }else{
        [self bigImageClick];
    }
    
}
@end
