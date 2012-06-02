//
//  Settings.h
//  PreferenceExample
//
//  Created by Bruno Wernimont on 2/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKPropertyList.h"

@interface Settings : DKPropertyList

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSDate *birdDate;
@property (nonatomic, strong) NSNumber *isChecked;
@property (nonatomic, strong) NSNumber *integer;

@end
