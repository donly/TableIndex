//
//  FirstViewController.m
//  TableIndex
//
//  Created by Dong on 15/8/11.
//  Copyright (c) 2015年 Dong. All rights reserved.
//

#import "FirstViewController.h"
#import "WordModel.h"

static NSString * const CellIdentifier = @"CellIdentifier";

@interface FirstViewController ()
{
    UILocalizedIndexedCollation *collation;
}

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *sampleString = @"大家看到的是发布时的瞩目和荣耀，却没有看到项目本身质量不高、错误频出。"
    "这并不是翻译者和校对者的问题，他们已经付出了足够的努力。";
    
    NSMutableOrderedSet *sequencerSet = [NSMutableOrderedSet orderedSet];
    for (NSInteger index = 0; index < sampleString.length; index++) {
        NSString *ichar  = [sampleString substringWithRange:NSMakeRange(index, 1)];
        [sequencerSet addObject:ichar];
    }
    
    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:sequencerSet.count];
    
    for (NSString *word in sequencerSet.objectEnumerator.allObjects) {
        WordModel *model = [WordModel new];
        model.name = word;
        [marr addObject:model];
    }
    
    self.dataArray = [NSArray arrayWithArray:marr];
    
    collation = [UILocalizedIndexedCollation currentCollation];
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];

    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    
    for (WordModel *p in self.dataArray) {
        NSInteger sectionNumber = [collation sectionForObject:p collationStringSelector:@selector(name)];

        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:p];
    }
    
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *personArrayForSection = newSectionsArray[index];
        NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:personArrayForSection
                                                       collationStringSelector:@selector(name)];

        newSectionsArray[index] = sortedPersonArrayForSection;
    }
    
    NSMutableArray *lastArr = newSectionsArray.lastObject;
    [newSectionsArray removeLastObject];
    [newSectionsArray insertObject:lastArr atIndex:0];
    self.dataArray = [newSectionsArray copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[collation sectionTitles] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *modelsInSection = (self.dataArray)[section];
    return [modelsInSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSArray *modelsInSection = self.dataArray[indexPath.section];
    WordModel *model = modelsInSection[indexPath.row];
    cell.textLabel.text = model.name;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *titles = [collation sectionTitles];
    if (section == 0) {
        return [collation sectionTitles][titles.count-1];
    }
    
    return titles[section-1];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSArray *titles = [collation sectionIndexTitles];
    NSMutableArray *mTitles = [NSMutableArray arrayWithArray:titles];
    [mTitles removeLastObject];
    [mTitles insertObject:@"#" atIndex:0];
    return [mTitles copy];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [collation sectionForSectionIndexTitleAtIndex:index];
}

@end
