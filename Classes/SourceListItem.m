//
//  SourceListItem.m
//  PXSourceList
//
//  Created by Alex Rozanski on 08/01/2010.
//  Copyright 2010 Alex Rozanski http://perspx.com
//
//  NSCoder Additions by Colin Wheeler
//

#import "SourceListItem.h"


@implementation SourceListItem

@synthesize title;
@synthesize identifier;
@synthesize icon;
@synthesize badgeValue;
@synthesize children;

static NSString * const kTitleKey =      @"title";
static NSString * const kIdentifierKey = @"identifier";
static NSString * const kIconKey =       @"icon";
static NSString * const kBadgeValueKey = @"badgeValue";
static NSString * const kChildrenKey =   @"children";

#pragma mark -
#pragma mark Init/Dealloc

- (id)init
{
	if(self=[super init])
	{
		badgeValue = -1;	//We don't want a badge value by default
	}
	
	return self;
}


+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier
{	
	SourceListItem *item = [SourceListItem itemWithTitle:aTitle identifier:anIdentifier icon:nil];
	
	return item;
}


+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier icon:(NSImage*)anIcon
{
	SourceListItem *item = [[[SourceListItem alloc] init] autorelease];
	
	[item setTitle:aTitle];
	[item setIdentifier:anIdentifier];
	[item setIcon:anIcon];
	
	return item;
}


- (void)dealloc
{
	[title release];
	[identifier release];
	[icon release];
	[children release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Custom Accessors

- (BOOL)hasBadge
{
	return badgeValue!=-1;
}

- (BOOL)hasChildren
{
	return [children count]>0;
}

- (BOOL)hasIcon
{
	return icon!=nil;
}

#pragma mark -
#pragma mark Description

- (NSString *)description
{
	return [NSString stringWithFormat:@"SourceListItem Title:%@ Identifier:%@ BadgeValue: %d",
			self.title,
			self.identifier,
			self.badgeValue];
}

#pragma mark -
#pragma mark NSCoder Methods

- (id)initWithCoder:(NSCoder *)coder
{
	if(self = [super init]){
		
		if ([coder isKindOfClass:[NSKeyedUnarchiver class]]) {
			
			title = [[coder decodeObjectForKey:kTitleKey] retain];
			identifier = [[coder decodeObjectForKey:kIdentifierKey] retain];
			icon = [[NSImage alloc] initWithData:[coder decodeObjectForKey:kIconKey]];
			badgeValue = [coder decodeIntegerForKey:kBadgeValueKey];
			children = [[coder decodeObjectForKey:kChildrenKey] copy];
		}
		else {
			[NSException raise:NSInvalidArchiveOperationException
						format:@"Only supports NSKeyedUnarchiver coders"];
		}
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	if ([coder isKindOfClass:[NSKeyedArchiver class]]) {
		
		[coder encodeObject:title forKey:kTitleKey];
		[coder encodeObject:identifier forKey:kIdentifierKey];
		[coder encodeObject:[icon TIFFRepresentation] forKey:kIconKey];
		[coder encodeInteger:badgeValue forKey:kBadgeValueKey];
		[coder encodeObject:children forKey:kChildrenKey];
		
    }
    else {
        [NSException raise:NSInvalidArchiveOperationException
                    format:@"Only supports NSKeyedArchiver coders"];
    }
}


@end
