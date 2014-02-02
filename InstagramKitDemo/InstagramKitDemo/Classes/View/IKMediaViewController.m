//
//    Copyright (c) 2013 Shyam Bhat
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "IKMediaViewController.h"
#import "IKMediaCell.h"
#import "UIImageView+AFNetworking.h"
#import "InstagramKit.h"

@interface IKMediaViewController ()

@end

@implementation IKMediaViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"@%@",self.media.user.username];
    [self testLoadCounts];
}

- (void)testLoadCounts
{
    [self.media.user loadCountsWithSuccess:^{
        NSLog(@"Courtesy: %@. %d media posts, follows %d users and is followed by %d users",self.media.user.username, self.media.user.mediaCount, self.media.user.followsCount, self.media.user.followedByCount);
    } failure:^{
        NSLog(@"Loading User details failed");
    }];

}

- (void)testComments
{
    [[InstagramEngine sharedEngine] getCommentsOnMedia:self.media withSuccess:^(NSArray *comments) {
        for (InstagramComment *comment in comments) {
            NSLog(@"@%@: %@",comment.user.username, comment.text);
        }
    } failure:^(NSError *error) {
        NSLog(@"Could not load comments");
    }];
}

- (void)testLikes
{
    [[InstagramEngine sharedEngine] getLikesOnMedia:self.media withSuccess:^(NSArray *likedUsers) {
        for (InstagramUser *user in likedUsers) {
            NSLog(@"Like : @%@",user.username);
        }
    } failure:^(NSError *error) {
        NSLog(@"Could not load likes");
    }];

}

#pragma mark - UITableViewDelegate, UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger retVal = 0;
    switch (indexPath.row) {
        case 0:
            retVal = 320;
            break;
            
        default:
            retVal = 50;
            break;
    }
    return retVal;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row) {
        IKMediaCell *cell = (IKMediaCell *)[tableView dequeueReusableCellWithIdentifier:@"MediaCell" forIndexPath:indexPath];
        [cell.mediaImageView setImageWithURL:self.media.thumbnailURL];
        [cell.mediaImageView setImageWithURL:self.media.standardResolutionImageURL];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        if (indexPath.row == 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"%d Likes",self.media.likesCount];
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = [NSString stringWithFormat:@"%d Comments",self.media.commentCount];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1)
    {
        [self testLikes];
    }
    else
    if (indexPath.row == 2) {
        [self testComments];
    }
}

@end
