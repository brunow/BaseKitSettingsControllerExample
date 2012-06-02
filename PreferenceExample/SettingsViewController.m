//
//  SettingsViewController.m
//  PreferenceExample
//
//  Created by Bruno Wernimont on 2/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

#import "BaseKitFormModel.h"
#import "Settings.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize formModel, settings;

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.formModel = [BKFormModel formTableModelForTableView:self.tableView];
    
    [BKFormMapping mappingForClass:[Settings class] block:^(BKFormMapping *formMapping) {
        [formMapping sectiontTitle:@"User credential" identifier:@"user_credential"];
        [formMapping mapAttribute:@"username" title:@"Username" type:BKFormAttributeMappingTypeText];
        [formMapping mapAttribute:@"password" title:@"Password" type:BKFormAttributeMappingTypePassword];
        
        [formMapping sectiontTitle:@"Personnal info" identifier:@"info"];
        [formMapping mapAttribute:@"birdDate" title:@"Bird date" type:BKFormAttributeMappingTypeDatePicker dateFormat:@"yyyy-MM-dd"];
        [formMapping mapAttribute:@"isChecked" title:@"Is checked" type:BKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"integer" title:@"Integer" type:BKFormAttributeMappingTypeInteger];
        
        [self.formModel registerMapping:formMapping];
    }];
    
    self.settings = [[Settings alloc] init];
    
    [self.formModel loadFieldsWithObject:self.settings];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self.settings save];
    
    self.settings = nil;
    self.formModel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
