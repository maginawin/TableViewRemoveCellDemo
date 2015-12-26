//
//  WMDragDeleteCellTableView.m
//  TableViewRemoveCellDemo
//
//  Created by wangwendong on 15/12/26.
//  Copyright © 2015年 sunricher. All rights reserved.
//

#import "WMDragDeleteCellTableView.h"

@implementation WMDragDeleteCellTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDidInit];
    }
    return self;
}

- (void)awakeFromNib {
    [self setupDidInit];
}

#pragma mark - ------- Private -------

- (void)setupDidInit {
    // Add Long press gesture recognizer
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlLongPressGestureRecognizer:)];
    longPress.minimumPressDuration = 0.8f;
    [self addGestureRecognizer:longPress];
    
}

- (void)handlLongPressGestureRecognizer:(UILongPressGestureRecognizer *)gesture {
    CGPoint locationPoint = [gesture locationInView:self];
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:locationPoint];
    
    static UIView *snapshot = nil;
    static NSIndexPath *sourceIndexPath = nil;
    static NSIndexPath *selectedIndexPath = nil;

    NSInteger rowsCount = [self numberOfRowsInSection:indexPath.section];
    NSLog(@"rows count %d，index row %d", rowsCount, indexPath.row);
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                selectedIndexPath = indexPath;
                
                UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
                snapshot = [self customSnapshotFromView:cell];
                
                __block CGPoint center = cell.center;
                
                snapshot.center = center;
                snapshot.alpha = 0;
                
                [self addSubview:snapshot];
                [UIView animateWithDuration:0.25f animations:^ {
                    center.y = locationPoint.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.02f, 1.02f);
                    snapshot.alpha = 0.9f;
                    cell.alpha = 0.f;
                } completion:^ (BOOL finished) {
                    cell.hidden = YES;
                }];
            }
        
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = locationPoint.y;
            snapshot.center = center;
            
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                if ([_dragDeleteCellTableViewDelegate respondsToSelector:@selector(dragDeleteCellTableView:didMoveRowAtIndexPath:toIndexPath:)]) {
                    [_dragDeleteCellTableViewDelegate dragDeleteCellTableView:self didMoveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                }
                
                [self moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
            }
            
            sourceIndexPath = indexPath;
            
            break;
        }
            
        default: {
            // Clean up
            UITableViewCell *cell = [self cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.f;
            
            [UIView animateWithDuration:0.25f animations:^ {
//                snapshot.center = cell.center;
//                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0;
                cell.alpha = 1;
            } completion:^(BOOL finished) {
                CGFloat deleteHeigt = CGRectGetHeight(self.bounds) - 22.f;
                NSLog(@"%.2f", deleteHeigt);
                
                if (snapshot.center.y >= deleteHeigt) {
                    NSLog(@"delete it");
                    if ([_dragDeleteCellTableViewDelegate respondsToSelector:@selector(dragDeleteCellTableView:shouldDeleteRowAtIndex:)]) {
                        [_dragDeleteCellTableViewDelegate dragDeleteCellTableView:self shouldDeleteRowAtIndex:selectedIndexPath];
                    }
                }
                
                [snapshot removeFromSuperview];
                
                snapshot = nil;
                sourceIndexPath = nil;
                selectedIndexPath = nil;
                
                [self reloadData];
            }];
        
            break;
        }
    }
}

- (UIView *)customSnapshotFromView:(UIView *)inputView {
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.f;
    snapshot.layer.shadowColor = [UIColor blackColor].CGColor;
    snapshot.layer.shadowOffset = CGSizeMake(4.f, 4.f);
    snapshot.layer.shadowOpacity = .5f;
    snapshot.layer.shadowRadius = 4.f;
    
    return snapshot;
}

@end
