//
//  ViewController.m
//  FMDB
//
//  Created by r_zhou on 16/2/26.
//  Copyright © 2016年 r_zhou. All rights reserved.
//

#import "ViewController.h"
#import "ZZQDBManager.h"
#import "GSFileManager.h"
#import "ZZQDataModel.h"

#define kKeyPathUserInfo @"userInfo"


@interface ViewController ()
@property (strong, nonatomic) YDFriendInfo *info;
// 输出拿到数据
@property (strong, nonatomic) YDFriendInfo *infos;


@end

@implementation ViewController
@synthesize info;
@synthesize infos;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    info = [[YDFriendInfo alloc] init];
    info.name = @"张三";
    info.userID = 11111;
    info.photo = @"ZhangSan";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * 文件数据存储
 */
- (IBAction)onFileStorageAction:(id)sender {
    NSLog(@"文件数据存储");
    // 用户信息存文件
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *filePath = [[GSFileManager sharedManager] pathForDomain:GSFileDirDomain_Pub appendPathName:kKeyPathUserInfo];
        [[GSFileManager sharedManager] saveObject:info atFilePath:filePath];
    });
    
    
    self.contentLabel.text = @"文件数据存储";
}

/*
 * 获取文件数据
 */
- (IBAction)onObtainFileDataAction:(id)sender {
    
    NSLog(@"获取文件数据");

    if (infos == nil)
    {
        NSString *filePath = [[GSFileManager sharedManager] pathForDomain:GSFileDirDomain_Pub appendPathName:kKeyPathUserInfo];
        
        YDFriendInfo *userInfo = [[GSFileManager sharedManager] loadObjectAtFilePath:filePath];
        if (userInfo != nil)
        {
            infos = userInfo;
            NSLog(@"%@",infos);
            self.contentLabel.text = [NSString stringWithFormat:@"获取文件数据:\n%@",info];
        }
    }
    
}


/*
 * 绑定数据库
 */
- (IBAction)onBindDBAction:(id)sender {
     NSLog(@"绑定数据库");
    [[GSFileManager sharedManager] createUserDir];
    [[ZZQDBManager shareInstance] bindDB];
    
    self.contentLabel.text = @"绑定数据库";
}


/*
 * 数据库数据存储
 */
- (IBAction)onDatabaseStorageAction:(id)sender {
    NSLog(@"数据库数据存储");
    
    [[ZZQDBManager shareInstance] insertUserToDB:info];
    
    self.contentLabel.text = [NSString stringWithFormat:@"储存信息:\n%@",info];
}

/*
 * 获取数据库数据
 */
- (IBAction)onObtainDatabaseDataAction:(id)sender {
    
    NSLog(@"获取数据库数据");
    
    YDFriendInfo *userInfo = [[ZZQDBManager shareInstance] getUserByUserId:@"11111"];
    NSLog(@"YDFriendInfo = %@",userInfo);
    
    self.contentLabel.text = [NSString stringWithFormat:@"获取数据库数据:\n%@",userInfo];
}

/**
 *  解绑数据库
 */
- (IBAction)onUnBinDBAction:(id)sender {
    NSLog(@"解绑数据库");
    
    [[ZZQDBManager shareInstance] unbindDB];
    
    self.contentLabel.text = @"解绑数据库";
}


@end
