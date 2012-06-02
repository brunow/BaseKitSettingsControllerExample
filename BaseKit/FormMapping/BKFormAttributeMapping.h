//
// Created by Bruno Wernimont on 2012
// Copyright 2012 BaseKit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Foundation/Foundation.h>

#import "BKFormMappingBlocks.h"
#import "BKBlocks.h"

typedef enum {
    BKFormAttributeMappingTypeDefault = 0,
    BKFormAttributeMappingTypeTimePicker = 1,
    BKFormAttributeMappingTypeDatePicker = 2,
    BKFormAttributeMappingTypePassword = 3,
    BKFormAttributeMappingTypeLabel = 4,
    BKFormAttributeMappingTypeBoolean = 5,
    BKFormAttributeMappingTypeText = 6,
    BKFormAttributeMappingTypeFloat = 7,
    BKFormAttributeMappingTypeInteger = 8,
    BKFormAttributeMappingTypeDateTimePicker = 9,
    BKFormAttributeMappingTypeSaveButton = 10,
    BKFormAttributeMappingTypeBigText = 11,
    BKFormAttributeMappingTypeImage = 12,
    BKFormAttributeMappingTypeButton = 13,
    BKFormAttributeMappingTypeSelect = 14
} BKFormAttributeMappingType;

@interface BKFormAttributeMapping : NSObject

@property (nonatomic, assign) BKFormAttributeMappingType mappingType;
@property (nonatomic, copy) NSString *attribute;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BKFormAttributeMappingType type;
@property (nonatomic, copy) BKFormMappingSelectValueBlock selectValuesBlock;
@property (nonatomic, copy) BKFormMappingValueWithSelectValueBlock selectDidSelectValueBlock;
@property (nonatomic, copy) NSString *placeholderText;
@property (nonatomic, copy) BKBasicBlock saveBtnHandler;
@property (nonatomic, copy) BKFormMappingButtonHandlerBlock btnHandler;
@property (nonatomic, assign) UITableViewCellAccessoryType accesoryType;
@property (nonatomic, copy) NSString *dateFormat;
@property (nonatomic, copy) BKFormMappingDateFormatBlock dateFormatBlock;

/*
 * Convenient method to get an attributeMapping
 */
+ (id)attributeMapping;

@end
