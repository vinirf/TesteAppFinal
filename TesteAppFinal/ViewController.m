//
//  ViewController.m
//  TesteAppFinal
//
//  Created by VINICIUS RESENDE FIALHO on 09/05/14.
//  Copyright (c) 2014 VINICIUS RESENDE FIALHO. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
   
	feeds = [[NSMutableArray alloc] init];
   // NSURL *url = [NSURL URLWithString:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"];
   
    NSString *thePath=[[NSBundle mainBundle] pathForResource:@"Chant" ofType:@"xml"];
    NSURL *url=[NSURL fileURLWithPath:thePath];
   
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}




- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
   
    element = elementName;
    
    if ([element isEqualToString:@"part"]) {
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        
    }
   
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
  
   
    if ([element isEqualToString:@"sign"]) {
        [title appendString:string];
    }
   
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
   
   
    if ([elementName isEqualToString:@"part"]) {
        
        [item setObject:title forKey:@"sign"];
        [feeds addObject:[item copy]];
        
    }
   
    
}



- (void)parserDidEndDocument:(NSXMLParser *)parser {
 
    for(int i=0;i<feeds.count;i++){
        NSLog(@"tit = %@",[[feeds objectAtIndex:i] objectForKey: @"sign"]);
   
        NSLog(@"\n");
    }
   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
