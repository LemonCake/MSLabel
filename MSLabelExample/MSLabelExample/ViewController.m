//
//  ViewController.m
//  MSLabelExample
//
//  Created by Joshua Wu on 11/10/12.
//  Copyright (c) 2012 Joshua Wu. All rights reserved.
//

#import "ViewController.h"
#import "MSLabel.h"

@interface ViewController ()

@property (nonatomic, retain) IBOutlet MSLabel *exampleLabel1;
@property (nonatomic, retain) IBOutlet MSLabel *exampleLabel2;
@property (nonatomic, retain) IBOutlet MSLabel *exampleLabel3;
@property (nonatomic, retain) IBOutlet MSLabel *exampleLabel4;

@end

@implementation ViewController

@synthesize exampleLabel1;
@synthesize exampleLabel2;
@synthesize exampleLabel3;
@synthesize exampleLabel4;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *exampleString = @"some really long string that will fill up this label's dimensions and stuff :) :) :) :) :)";
    
    exampleLabel1.lineHeight = 20;
    exampleLabel1.verticalAlignment = MSLabelVerticalAlignmentTop;
    exampleLabel1.text = exampleString;
    
    exampleLabel2.lineHeight = 15;
    exampleLabel2.verticalAlignment = MSLabelVerticalAlignmentMiddle;
    exampleLabel2.text = exampleString;
    
    exampleLabel3.lineHeight = 30;
    exampleLabel3.verticalAlignment = MSLabelVerticalAlignmentBottom;
    exampleLabel3.text = exampleString;
    
    exampleLabel4.text = exampleString;
    exampleLabel4.numberOfLines = 3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
