//
//  MSLabel.h
//  Miso
//
//  Created by Joshua Wu on 11/15/11.
//  Copyright (c) 2011 Miso. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MSLabelVerticalAlignTop,
    MSLabelVerticalAlignMiddle,
    MSLabelVerticalAlignBottom
} MSLabelVerticalAlign;

@interface MSLabel : UILabel 
{
    int _lineHeight;
}

@property (nonatomic, assign) int lineHeight;
@property (nonatomic, assign) MSLabelVerticalAlign verticalAlign;

@end
