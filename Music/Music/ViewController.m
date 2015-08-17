//
//  ViewController.m
//  Music
//
//  Created by qianfeng on 15/7/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LyricModel.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_lyricArr;
    AVAudioPlayer  *_player;
    int _row;
    
    
}
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *pregressSlider;
@property (weak, nonatomic) IBOutlet UITableView *tabview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _lyricArr = [NSMutableArray arrayWithCapacity:0];
    [self initAVPlayer];
    [self parseLyric];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(playerTimer) userInfo:nil repeats:YES];
}

-(void)playTimer{
    
    
    
    
    
    
    
}



-(void)parseLyric{
    NSString * lyricContentStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"情非得已" ofType:@"lrc" ] encoding:NSUTF8StringEncoding error:nil] ;
    NSArray * rowArr = [lyricContentStr componentsSeparatedByString:@"["];
    for (int i = 3; i < rowArr.count; i ++) {
        NSArray  * time_contentArr = [rowArr[i] componentsSeparatedByString:@"]"];
        double time = 0;
        if (time_contentArr.count > 0) {
            NSArray * min_secArr = [time_contentArr[0] componentsSeparatedByString:@":"];
            time = [min_secArr[0] doubleValue] * 60 + [min_secArr[1] doubleValue];
            
            
        }
        
        LyricModel * model = [[LyricModel alloc]init];
        model.startTime = time;
        model.content = time_contentArr[1];
        [_lyricArr addObject:model];
        
    }
    
    
    
    
    
    
}

-(void)initAVPlayer{
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"情非得已" withExtension:@"mp3"] error:nil];
    
    [_player prepareToPlay];
    _player.numberOfLoops = -1;
    _player.volume = 0.5;
    
    _tabview.delegate = self;
    _tabview.dataSource = self;
    _tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_pregressSlider setThumbImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
    CGFloat duration = _player.duration;
    _totalTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)duration / 60,(int)duration % 60];
    
    
}


- (IBAction)changePregressSlider:(UISlider *)sender {
    
    _player.currentTime = sender.value * _player.duration;
 
}

- (IBAction)changePlay:(UIButton *)sender {
    if (_player.isPlaying) {
        
        [_player pause];
        [sender setTitle:@"播放" forState:UIControlStateNormal];
        
    }else{
        [_player play];
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
        
        
    }
    
    
    
    
}
- (IBAction)volumeChange:(UISlider *)sender {
    
    _player.volume = sender.value;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _lyricArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * ID = @"ID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [_lyricArr[indexPath.row] content];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    if (_row == indexPath.row) {
        cell.textLabel.textColor = [UIColor yellowColor];
        cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
    }else{
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:17.0f];
        
    }
    
    
    return cell;
    
}



















@end
