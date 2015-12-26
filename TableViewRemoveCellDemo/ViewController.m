//
//  ViewController.m
//  TableViewRemoveCellDemo
//
//  Created by wangwendong on 15/12/26.
//  Copyright © 2015年 sunricher. All rights reserved.
//

#import "ViewController.h"
#import "WMDragDeleteCellTableView.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, WMDragDeleteCellTableViewDelegate>

@property (weak, nonatomic) IBOutlet WMDragDeleteCellTableView *mTableView;

@property (strong, nonatomic) NSMutableArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.dragDeleteCellTableViewDelegate = self;
    
    _datas = [NSMutableArray arrayWithArray:@[@"a", @"b", @"c", @"d", @"e"]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = (NSString *)[_datas objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)dragDeleteCellTableView:(WMDragDeleteCellTableView *)tableView didMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)indexPath {
//    [_datas exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:indexPath.row];
}

- (void)dragDeleteCellTableView:(WMDragDeleteCellTableView *)tableView shouldDeleteRowAtIndex:(NSIndexPath *)indexPath {
    [_datas removeObjectAtIndex:indexPath.row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
