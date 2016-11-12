//
//  FVCofigOptionViewController.m
//  FVCustomTransition
//
//  Created by iforvert on 2016/11/11.
//  Copyright © 2016年 iforvert. All rights reserved.
//

#import "FVCofigOptionViewController.h"
#import "FVConfigOption.h"

typedef NS_ENUM(NSInteger, Tag) {
    // 转场时间
    TagDurationField        = 10,
    // 阻尼系数
    TagDampingRatioField    = 20,
    // 弹动速度
    TagSpringVelocityField  = 30,
    // 弹动时长
    TagSpringDurationField  = 40
};

@interface FVCofigOptionViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *pushTransitionSwitch;
@property (weak, nonatomic) IBOutlet UITextField *durationField;
@property (weak, nonatomic) IBOutlet UILabel *fromEdgeLabel;
@property (weak, nonatomic) IBOutlet UITextField *dampingRatioField;
@property (weak, nonatomic) IBOutlet UITextField *springVelocityField;
@property (weak, nonatomic) IBOutlet UITextField *springDurationField;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@end

@implementation FVCofigOptionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configEssentialInfo];
    
    self.numberFormatter = ({
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMinimumFractionDigits:2];
        [formatter setMaximumFractionDigits:2];
        [formatter setAlwaysShowsDecimalSeparator:YES];
        formatter;
    });
    
    FVConfigOption *options = [FVConfigOption sharedConfigOptions];
    self.pushTransitionSwitch.on = options.pushTransition;
    self.durationField.text = [self.numberFormatter stringFromNumber:@(options.duration)];
    self.dampingRatioField.text = [self.numberFormatter stringFromNumber:@(options.dampingRatio)];
    self.springVelocityField.text = [self.numberFormatter stringFromNumber:@(options.velocity)];
    self.springDurationField.text = [self.numberFormatter stringFromNumber:@(options.springDuration)];
    
}

- (void)configEssentialInfo
{
    self.durationField.delegate = self;
    self.dampingRatioField.delegate = self;
    self.springVelocityField.delegate = self;
    self.springDurationField.delegate = self;
    
    self.durationField.tag = TagDurationField;
    self.dampingRatioField.tag = TagDampingRatioField;
    self.springVelocityField.tag = TagSpringVelocityField;
    self.springDurationField.tag = TagSpringDurationField;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    FVConfigOption *option = [FVConfigOption sharedConfigOptions];
    self.fromEdgeLabel.text = [FVSlideTransitionAnimator edgeDisplayName][@(option.edge)];
}

#pragma mark - custom actions

- (IBAction)switchChange:(UISwitch *)sender
{
    FVConfigOption *option = [FVConfigOption sharedConfigOptions];
    option.pushTransition = sender.isOn;
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSNumber *value = [self.numberFormatter numberFromString:textField.text];
    value = value? : @0;
    textField.text = [self.numberFormatter stringFromNumber:value];
    
    FVConfigOption *option = [FVConfigOption sharedConfigOptions];
    
    switch (textField.tag) {
        case TagDurationField: {
            option.duration = [value doubleValue];
            break;
        }
        case TagDampingRatioField: {
            option.dampingRatio = [value doubleValue];
            break;
        }
        case TagSpringVelocityField: {
            option.velocity = [value doubleValue];
            break;
        }
        case TagSpringDurationField: {
            option.springDuration = [value doubleValue];
            break;
        }
        default:
            break;
    }
}



@end
