//
//  DDQuestion.m
//  12-super-guess-image
//
//  Created by 杜东方 on 15/11/2.
//  Copyright © 2015年 private. All rights reserved.
//

#import "DDQuestion.h"

@implementation DDQuestion


- (instancetype) initWithDic:(NSDictionary*)dic{
    
    if (self = [super init]) {
//        self.answer = dic[@"answer"];
//        self.icon = dic[@"icon"];
//        self.title = dic[@"dic[@"title"]"];
//        self.options = dic[@"options"];
        
        //kvc key value coding
//        [self setValue: dic[@"answer"] forKey:@"answer"];
//        [self setValue:dic[@"icon"] forKey:@"icon"];
//        [self setValue:dic[@"title"] forKey:@"title"];
//        [self setValue:dic[@"options"] forKey:@"options"];
        
        //属性的名称必须和字典中键的值相同
        [self setValuesForKeysWithDictionary:dic];
        
        
        
    }
    
    return self;
}

+ (instancetype) questionWithDic:(NSDictionary*)dic{
    return [[self alloc] initWithDic:dic];
}

+ (NSArray*) questionList{
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"];
    
    
    for (NSDictionary *dic in [NSArray arrayWithContentsOfFile:filePath]) {
        DDQuestion *question = [DDQuestion questionWithDic:dic];
        [mutableArray addObject:question];
    }
    
    
    return mutableArray;
}
@end
