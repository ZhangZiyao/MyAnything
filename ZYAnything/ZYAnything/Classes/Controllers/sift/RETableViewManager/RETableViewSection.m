//
// RETableViewSection.m
// RETableViewManager
//

#import "RETableViewSection.h"
#import "RETableViewManager.h"

@implementation RETableViewSection

#pragma mark -
#pragma mark Creating and Initializing Sections

+ (instancetype)section
{
    return [[self alloc] init];
}

+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle
{
    return [[self alloc ] initWithHeaderTitle:headerTitle];
}

+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle
{
    return [[self alloc] initWithHeaderTitle:headerTitle footerTitle:footerTitle];
}

+ (instancetype)sectionWithHeaderView:(UIView *)headerView
{
    return [[self alloc] initWithHeaderView:headerView footerView:nil];
}

+ (instancetype)sectionWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView
{
    return [[self alloc] initWithHeaderView:headerView footerView:footerView];
}

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    _items = [[NSMutableArray alloc] init];
    
    return self;
}

- (id)initWithHeaderTitle:(NSString *)headerTitle
{
    return [self initWithHeaderTitle:headerTitle footerTitle:nil];
}

- (id)initWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle
{
    self = [self init];
    if (!self)
        return nil;
    
    self.headerTitle = headerTitle;
    self.footerTitle = footerTitle;
    
    return self;
}

- (id)initWithHeaderView:(UIView *)headerView
{
    return [self initWithHeaderView:headerView footerView:nil];
}

- (id)initWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView
{
    self = [self init];
    if (!self)
        return nil;
    
    self.headerView = headerView;
    self.footerView = footerView;
    
    return self;
}

#pragma mark -
#pragma mark Styling

- (RETableViewCellStyle *)style
{
    return _style ? _style : self.tableViewManager.style;
}

#pragma mark -
#pragma mark Reading information

- (NSUInteger)index
{
    RETableViewManager *tableViewManager = self.tableViewManager;
    return [tableViewManager.sections indexOfObject:self];
}

- (CGFloat)maximumTitleWidthWithFont:(UIFont *)font
{
    CGFloat width = 0;
    return width + 5.0;
}

#pragma mark -
#pragma mark Managing items

- (void)addItem:(id)item
{
    if ([item isKindOfClass:[RETableViewItem class]])
        ((RETableViewItem *)item).section = self;
    
    [_items addObject:item];
}

- (void)addItemsFromArray:(NSArray *)array
{
    for (RETableViewItem *item in array)
        if ([item isKindOfClass:[RETableViewItem class]])
            ((RETableViewItem *)item).section = self;
    
    [_items addObjectsFromArray:array];
}

- (void)insertItem:(id)item atIndex:(NSUInteger)index
{
    if ([item isKindOfClass:[RETableViewItem class]])
        ((RETableViewItem *)item).section = self;
    
    [_items insertObject:item atIndex:index];
}

- (void)insertItems:(NSArray *)items atIndexes:(NSIndexSet *)indexes
{
    for (RETableViewItem *item in items)
        if ([item isKindOfClass:[RETableViewItem class]])
            ((RETableViewItem *)item).section = self;
    
    [_items insertObjects:items atIndexes:indexes];
}

- (void)removeItem:(id)item inRange:(NSRange)range
{
    [_items removeObject:item inRange:range];
}

- (void)removeLastItem
{
    [_items removeLastObject];
}

- (void)removeItemAtIndex:(NSUInteger)index
{
    [_items removeObjectAtIndex:index];
}

- (void)removeItem:(id)item
{
    [_items removeObject:item];
}

- (void)removeAllItems
{
    [_items removeAllObjects];
}

- (void)removeItemIdenticalTo:(id)item inRange:(NSRange)range
{
    [_items removeObjectIdenticalTo:item inRange:range];
}

- (void)removeItemIdenticalTo:(id)item
{
    [_items removeObjectIdenticalTo:item];
}

- (void)removeItemsInArray:(NSArray *)otherArray
{
    [_items removeObjectsInArray:otherArray];
}

- (void)removeItemsInRange:(NSRange)range
{
    [_items removeObjectsInRange:range];
}

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes
{
    [_items removeObjectsAtIndexes:indexes];
}

- (void)replaceItemAtIndex:(NSUInteger)index withItem:(id)item
{
    if ([item isKindOfClass:[RETableViewItem class]])
        ((RETableViewItem *)item).section = self;
    
    [_items replaceObjectAtIndex:index withObject:item];
}

- (void)replaceItemsWithItemsFromArray:(NSArray *)otherArray
{
    [self removeAllItems];
    [self addItemsFromArray:otherArray];
}

- (void)replaceItemsInRange:(NSRange)range withItemsFromArray:(NSArray *)otherArray range:(NSRange)otherRange
{
    for (RETableViewItem *item in otherArray)
        if ([item isKindOfClass:[RETableViewItem class]])
            ((RETableViewItem *)item).section = self;
    
    [_items replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];
}

- (void)replaceItemsInRange:(NSRange)range withItemsFromArray:(NSArray *)otherArray
{
    for (RETableViewItem *item in otherArray)
        if ([item isKindOfClass:[RETableViewItem class]])
            ((RETableViewItem *)item).section = self;
    
    [_items replaceObjectsInRange:range withObjectsFromArray:otherArray];
}

- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)items
{
    for (RETableViewItem *item in items)
        if ([item isKindOfClass:[RETableViewItem class]])
            ((RETableViewItem *)item).section = self;
    
    [_items replaceObjectsAtIndexes:indexes withObjects:items];
}

- (void)exchangeItemAtIndex:(NSUInteger)idx1 withItemAtIndex:(NSUInteger)idx2
{
    [_items exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)sortItemsUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context
{
    [_items sortUsingFunction:compare context:context];
}

- (void)sortItemsUsingSelector:(SEL)comparator
{
    [_items sortUsingSelector:comparator];
}

#pragma mark -
#pragma mark Manipulating table view section

- (void)reloadSectionWithAnimation:(UITableViewRowAnimation)animation
{
    [self.tableViewManager.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.index] withRowAnimation:animation];
}

#pragma mark -
#pragma mark Checking for errors

- (NSArray *)errors
{
    NSMutableArray *errors;
    for (RETableViewItem *item in self.items) {
        if ([item respondsToSelector:@selector(errors)] && item.errors) {
            if (!errors) {
                errors = [[NSMutableArray alloc] init];
            }
            if (item.errors.count > 0)
                [errors addObject:item.errors[0]];
        }
    }
    return errors;
}

@end
