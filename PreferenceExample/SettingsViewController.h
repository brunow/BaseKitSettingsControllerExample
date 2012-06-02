//
//  SettingsViewController.h
//  PreferenceExample
//
//  Created by Bruno Wernimont on 2/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BKFormModel;
@class Settings;

@interface SettingsViewController : UITableViewController

@property (nonatomic, strong) BKFormModel *formModel;
@property (nonatomic, strong) Settings *settings;

@end
