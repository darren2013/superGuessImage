//
//  DDQuestion.h
//  12-super-guess-image
//
//  Created by 杜东方 on 15/11/2.
//  Copyright © 2015年 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQuestion : NSObject

@property (nonatomic,copy)NSString *answer;

@property (nonatomic,copy)NSString *icon;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,strong)NSArray *options;

+ (NSArray*) questionList;

+ (instancetype) questionWithDic:(NSDictionary*)dic;


@end
