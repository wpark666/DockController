//#import <Preferences/PSViewController.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#include <spawn.h>

@interface DockControllerTableCell : PSTableCell
@end

@interface PSControlTableCell : PSTableCell
- (UIControl *)control;
@end

@interface PSSwitchTableCell : PSControlTableCell
@end

@interface DockControllerSwitchTableCell : PSSwitchTableCell
@end

@interface PSListController (DockController)
-(BOOL)containsSpecifier:(id)arg1;
@end

@interface DockControllerMainPreferences : PSListController
@property (nonatomic, retain) NSMutableDictionary *savedSpecifiers;
@end

@interface DockControlleriPadDockPreferences : PSListController
@property (nonatomic, retain) NSMutableDictionary *savedSpecifiers;
@end

@implementation DockControllerTableCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)identifier specifier:(id)specifier {
	return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier specifier:specifier];
}
- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
	[super refreshCellContentsWithSpecifier:specifier];
	NSString *sublabel = [specifier propertyForKey:@"sublabel"];
	if (sublabel) {
		self.detailTextLabel.text = [sublabel description];
		self.detailTextLabel.textColor = [UIColor grayColor];
	}
}
@end

@implementation DockControllerSwitchTableCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)identifier specifier:(id)specifier {
	return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier specifier:specifier];
}
- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
	[super refreshCellContentsWithSpecifier:specifier];
	NSString *sublabel = [specifier propertyForKey:@"sublabel"];
	if (sublabel) {
		self.detailTextLabel.text = [sublabel description];
		self.detailTextLabel.textColor = [UIColor grayColor];
	}
}
@end

@implementation DockControllerMainPreferences
-(NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	return _specifiers;
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respringDevice)];
	self.navigationItem.rightBarButtonItem = applyButton;
}

-(void)respringDevice {
	UIAlertController *confirmRespringAlert = [UIAlertController alertControllerWithTitle:@"Respring Device" message:nil preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		pid_t pid;
		const char *argv[] = {"sbreload", NULL};
		posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)argv, NULL);
	}];

	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

	[confirmRespringAlert addAction:cancel];
	[confirmRespringAlert addAction:confirm];

	[self presentViewController:confirmRespringAlert animated:YES completion:nil];
}

-(void)sourceCode {
	NSURL *sourceCode = [NSURL URLWithString:@"https://github.com/tomaszpoliszuk/DockController"];
	[[UIApplication sharedApplication] openURL:sourceCode options:@{} completionHandler:nil];
}

-(void)reportIssueAtGithub {
	NSURL *reportIssueAtGithub = [NSURL URLWithString:@"https://github.com/tomaszpoliszuk/DockController/issues/new"];
	[[UIApplication sharedApplication] openURL:reportIssueAtGithub options:@{} completionHandler:nil];
}

-(void)TomaszPoliszukAtGithub {
	UIApplication *application = [UIApplication sharedApplication];
	NSString *username = @"tomaszpoliszuk";
	NSURL *githubWebsite = [NSURL URLWithString:[@"https://github.com/" stringByAppendingString:username]];
	[application openURL:githubWebsite options:@{} completionHandler:nil];
}

-(void)TomaszPoliszukAtTwitter {
	UIApplication *application = [UIApplication sharedApplication];
	NSString *username = @"tomaszpoliszuk";
	NSURL *twitterWebsite = [NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:username]];
	[application openURL:twitterWebsite options:@{} completionHandler:nil];
}
@end

@implementation DockControlleriPadDockPreferences
-(NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"iPadDock" target:self];
	}
	return _specifiers;
}
@end
