//
//  SEJSONViewController.m
//  SEJSONViewController
//
//  Created by Sérgio Estêvão on 04/09/2013.
//  Copyright (c) 2013 Sérgio Estêvão. All rights reserved.
//

#import "SEJSONViewController.h"

static const CGFloat Padding = 20;

@interface SEJSONViewController () {
    id _data;
    UITableViewCell * _textViewCell;
    UILabel * _label;
}

@end

@implementation SEJSONViewController

- initWithData:(id) data {
    return [self initWithStyle:UITableViewStylePlain data:data];
}

- (id)initWithStyle:(UITableViewStyle)style data:(id) data
{
    self = [super initWithStyle:style];
    if (!self) return nil;
    // Custom initialization
    _data = data;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ( !([_data isKindOfClass:[NSDictionary class]] || [_data isKindOfClass:[NSArray class]])) {
        [self setupForLeaf:_data];
    };
}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setData:(id)data {
    _data = data;
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_data == nil) return 0;
    // Return the number of sections.
    if ([_data isKindOfClass:[NSDictionary class]]){
        return 1;
    }
    
    if ([_data isKindOfClass:[NSArray class]]){
        return [_data count];
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([_data isKindOfClass:[NSDictionary class]]){
        return [_data count];
    }
    
    if ([_data isKindOfClass:[NSArray class]]){
        id obj = _data[section];
        if ([obj isKindOfClass:[NSDictionary class]]){
            return [[obj allKeys] count];
        }
        return 1;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( !([_data isKindOfClass:[NSDictionary class]] || [_data isKindOfClass:[NSArray class]])) {
        return _textViewCell;
    };
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    id obj = _data;
    if ([_data isKindOfClass:[NSArray class]]){
        obj = _data[indexPath.section];
    }
    if ([obj isKindOfClass:[NSDictionary class]]){
        cell.textLabel.text = [obj allKeys][indexPath.row];
        id subObj = obj[cell.textLabel.text];
        if ([[subObj class] isSubclassOfClass:[NSDictionary class]] ||
            [[subObj class] isSubclassOfClass:[NSArray class]]
            )
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = @"";
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailTextLabel.text = [subObj description];
        }
    } else if ([obj isKindOfClass:[NSArray class]]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%li",(long)indexPath.row];
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.textLabel.text = [obj description];
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[_data class] isSubclassOfClass:[NSArray class]]){
        return [NSString stringWithFormat:@"%li",(long)section];
    }
    //check if leaf node
    if ( !([_data isKindOfClass:[NSDictionary class]] || [_data isKindOfClass:[NSArray class]])) {
        return @"";
    };
    return @"Attributes";
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //check if leaf node
    if ( !([_data isKindOfClass:[NSDictionary class]] || [_data isKindOfClass:[NSArray class]])) {
        return;
    };
//  Navigation logic may go here. Create and push another view controller.
    NSString * title = self.title;
    id obj = _data;
    id selectedObjet = nil;
    if ([_data isKindOfClass:[NSArray class]]){
        obj = _data[indexPath.section];
    }
    selectedObjet = obj;
    if ([obj isKindOfClass:[NSDictionary class]]){
        NSString * key = [obj allKeys][indexPath.row];
        selectedObjet = obj[key];
        title = key;
    }  else if ([obj isKindOfClass:[NSArray class]]) {
        selectedObjet = obj[indexPath.row];
        title = [NSString stringWithFormat:@"%@-%li",self.title, (long)indexPath.row];
    }
    
    SEJSONViewController *detailViewController = [[SEJSONViewController alloc] initWithStyle:self.tableView.style];
    [detailViewController setData:selectedObjet];
    detailViewController.title = title;
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( !([_data isKindOfClass:[NSDictionary class]] || [_data isKindOfClass:[NSArray class]])) {
        CGSize size = [_label  sizeThatFits:CGSizeMake(self.tableView.frame.size.width-(2*Padding),  	CGFLOAT_MAX)];
        CGRect frame = _label.frame;
        frame.size = size;
        _label.frame = frame;
        return size.height+Padding;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (void) setupForLeaf:(id) data{
    
    NSString * text = [data description];
    _textViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Leaf"];
    _label = [[UILabel alloc] initWithFrame:CGRectMake(Padding, Padding, 320-Padding, 44)];
    [_textViewCell.contentView addSubview:_label];
    _label.font = [UIFont systemFontOfSize:20];
    _label.numberOfLines = 0;
    _label.text = text;
    _label.contentMode = UIViewContentModeRedraw;
    _label.lineBreakMode = NSLineBreakByClipping;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _textViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

@end
