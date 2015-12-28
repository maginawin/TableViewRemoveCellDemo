//
//  WMDragDeleteCellTableView.h
//  TableViewRemoveCellDemo
//
//  Created by wangwendong on 15/12/26.
//  Copyright © 2015年 sunricher. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMDragDeleteCellTableView;

@protocol WMDragDeleteCellTableViewDelegate <NSObject>

@optional

- (void)dragDeleteCellTableView:(WMDragDeleteCellTableView *)tableView didMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)indexPath;

- (void)dragDeleteCellTableView:(WMDragDeleteCellTableView *)tableView shouldDeleteRowAtIndex:(NSIndexPath *)indexPath;

@end

@interface WMDragDeleteCellTableView : UITableView

@property (weak, nonatomic) id<WMDragDeleteCellTableViewDelegate> dragDeleteCellTableViewDelegate;

@end
