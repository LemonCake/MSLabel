//
//  MSLabel.h
//  Miso
//
//  Created by Joshua Wu on 11/15/11.
//  Copyright (c) 2011 Miso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSLabel : UILabel {
    int _lineHeight;
    BOOL _anchorBottom;
}

@property (nonatomic, assign) int lineHeight;
@property (nonatomic, assign) BOOL anchorBottom;
@end
