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

#import "BKFormModel.h"

#import "BKFormMapping.h"
#import "BKFormMapper.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetDatePicker.h"
#import "BKSaveButtonField.h"
#import "BaseKitFormField.h"
#import "UIView+BaseKit.h"
#import "NSObject+BKFormAttributeMapping.h"
#import "BKMacrosDefinitions.h"
#import "BKOperationHelper.h"
#import "UINavigationController+BaseKit.h"

#import "BWLongTextViewController.h"


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BKFormModel ()

@property (nonatomic, retain) BKFormMapping *formMapping;
@property (nonatomic, retain) BKFormMapper *formMapper;

- (void)showTextViewControllerWithAttributeMapping:(BKFormAttributeMapping *)attributeMapping;

- (void)showSelectPickerWithAttributeMapping:(BKFormAttributeMapping *)attributeMapping;

- (void)showDatePickerWithAttributeMapping:(BKFormAttributeMapping *)attributeMapping;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BKFormModel

@synthesize tableView = _tableView;
@synthesize formMapping = _formMapping;
@synthesize object = _object;
@synthesize formMapper = _formMapper;
@synthesize navigationController = _navigationController;


////////////////////////////////////////////////////////////////////////////////////////////////////
#if !BK_HAS_ARC
- (void)dealloc {
    self.tableView = nil;
    self.formMapping = nil;
    self.object = nil;
    self.navigationController = nil;
    
    [super dealloc];
}
#endif


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)formTableModelForTableView:(UITableView *)tableView {
    return [self formTableModelForTableView:tableView navigationController:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)formTableModelForTableView:(UITableView *)tableView
            navigationController:(UINavigationController *)navigationController {
    
    return BK_AUTORELEASE([[self alloc] initWithTableView:tableView
                                     navigationController:navigationController]);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTableView:(UITableView *)tableView
   navigationController:(UINavigationController *)navigationController {
    
    self = [self init];
    if (self) {
        self.tableView = tableView;
        self.navigationController = navigationController;
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSections {
    return [self.formMapper numberOfSections];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return [self.formMapper numberOfRowsInSection:section];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)titleForHeaderInSection:(NSInteger)section {
    return [self.formMapper titleForHeaderInSection:section];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.formMapper cellForRowAtIndexPath:indexPath];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self.tableView findFirstResponder] resignFirstResponder];
    
    BKFormAttributeMapping *attributeMapping = [self.formMapper attributeMappingAtIndexPath:indexPath];
    
    if (nil != attributeMapping.selectValuesBlock) {
        [self showSelectPickerWithAttributeMapping:attributeMapping];
        
    } else if (nil != attributeMapping.saveBtnHandler) {
        attributeMapping.saveBtnHandler();
        
    } else if (nil != attributeMapping.btnHandler) {
        attributeMapping.btnHandler(self.object);
        
    } else if (BKFormAttributeMappingTypeBigText == attributeMapping.type) {
        [self showTextViewControllerWithAttributeMapping:attributeMapping];

    } else if (BKFormAttributeMappingTypeText == attributeMapping.type) {
        BKTextField *textFieldCell = (BKTextField *)[self cellForRowAtIndexPath:indexPath];
        [textFieldCell.textField becomeFirstResponder];
        
    } else if (BKFormAttributeMappingTypeDateTimePicker == attributeMapping.type ||
               BKFormAttributeMappingTypeTimePicker == attributeMapping.type ||
               BKFormAttributeMappingTypeDatePicker == attributeMapping.type) {
        
        [self showDatePickerWithAttributeMapping:attributeMapping];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)registerMapping:(BKFormMapping *)formMapping {
    self.formMapping = formMapping;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadFieldsWithObject:(id)object {
    self.object = object;
    
    self.formMapper = BK_AUTORELEASE([[BKFormMapper alloc] initWithFormMapping:self.formMapping
                                                                     tabelView:self.tableView
                                                                        object:self.object
                                                                     formModel:self]);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reloadRowWithAttributeMapping:(BKFormAttributeMapping *)attributeMapping {
    __block NSIndexPath *indexPath = nil;
    [BKOperationHelper performBlockInBackground:^{
        indexPath = [self.formMapper indexPathOfAttributeMapping:attributeMapping];
        BK_RETAIN_WITHOUT_RETURN(indexPath);
    } completion:^{
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Getters and setters


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTableView:(UITableView *)tableView {
    if (_tableView != tableView) {
        BK_RELEASE(_tableView);
        _tableView = BK_RETAIN(tableView);
    }
    
    tableView.dataSource = self;
    tableView.delegate = self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
    if (object != _object) {
        BK_RELEASE(_object);
        _object = BK_RETAIN(object);
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDataSource


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRowsInSection:section];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellForRowAtIndexPath:indexPath];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self titleForHeaderInSection:section];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDelegate


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self didSelectRowAtIndexPath:indexPath];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIScrollViewDelegate


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_canHideKeyBoard) {
        [[self.tableView findFirstResponder] resignFirstResponder];
        _canHideKeyBoard = NO;
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _canHideKeyBoard = YES;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showTextViewControllerWithAttributeMapping:(BKFormAttributeMapping *)attributeMapping {
    BK_WEAK_IVAR BKFormModel *weakRef = self;
    [self.navigationController pushViewControllerWithBlock:^UIViewController *{
        NSString *value = [self.formMapper valueForAttriteMapping:attributeMapping];
        BWLongTextViewController *vc = [[BWLongTextViewController alloc] initWithText:value];
        vc.title = attributeMapping.title;
        vc.textView.delegate = weakRef.formMapper;
        vc.textView.formAttributeMapping = attributeMapping;
        return BK_AUTORELEASE(vc);
    } animated:YES];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showSelectPickerWithAttributeMapping:(BKFormAttributeMapping *)attributeMapping {
    BK_WEAK_IVAR BKFormModel *weakRef = self;
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        BKFormAttributeMapping *formAttributeMapping = picker.formAttributeMapping;
        id value = formAttributeMapping.selectDidSelectValueBlock(selectedValue, self.object, selectedIndex);
        [weakRef.formMapper setValue:value forAttributeMapping:formAttributeMapping];
        [weakRef reloadRowWithAttributeMapping:formAttributeMapping];
    };
    
    NSInteger selectedIndex = 0;
    ActionSheetStringPicker *picker;
    picker = [ActionSheetStringPicker showPickerWithTitle:attributeMapping.title
                                                     rows:attributeMapping.selectValuesBlock(nil, self.object, &selectedIndex)
                                         initialSelection:selectedIndex
                                                doneBlock:done
                                              cancelBlock:nil
                                                   origin:self.tableView];
    
    picker.formAttributeMapping = attributeMapping;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showDatePickerWithAttributeMapping:(BKFormAttributeMapping *)attributeMapping {
    ActionSheetDatePicker *actionSheetPicker;
    UIDatePickerMode datePickerMode = UIDatePickerModeDate;
    
    if (BKFormAttributeMappingTypeTimePicker == attributeMapping.type) {
        datePickerMode = UIDatePickerModeTime;
    } else if (BKFormAttributeMappingTypeDateTimePicker == attributeMapping.type) {
        datePickerMode = UIDatePickerModeDateAndTime;
    }
    
    BK_WEAK_IVAR BKFormModel *weakRef = self;
    actionSheetPicker = [ActionSheetDatePicker showPickerWithTitle:attributeMapping.title
                                                    datePickerMode:datePickerMode
                                                      selectedDate:[NSDate date]
                                                         doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
                                                             BKFormAttributeMapping *formAttributeMapping = picker.formAttributeMapping;
                                                             [weakRef.formMapper setValue:selectedDate forAttributeMapping:formAttributeMapping];
                                                             [weakRef reloadRowWithAttributeMapping:formAttributeMapping];
                                                         }
                                                       cancelBlock:nil
                                                            origin:self.tableView];
    
    actionSheetPicker.formAttributeMapping = attributeMapping;
}



@end
