//
//  XMLParser.m
//  Test
//
//  Created by wuyingqiang on 7/19/15.
//  Copyright (c) 2015 wuyingqiang. All rights reserved.
//

#import "XMLParser.h"

/* 
 * define the parsing mode
 *
 */
typedef NS_ENUM(NSInteger, ParseMode) {
    ParseModeByData     = 1,
    ParseModeByString   = 2,
    ParseModeByURL      = 3,
    ParseModeByXMLParser= 4
};

typedef void (^parseDoneBlock)(NSDictionary *data);

@interface XMLParser() <NSXMLParserDelegate>

/* block , which is for complete operation */
@property (nonatomic, weak) parseDoneBlock parseCompleteNow;

/* data from source */
@property (nonatomic, strong) NSData *data;
/* url of network */
@property (nonatomic, strong) NSURL *Url;

/* xml operation stack */
@property (nonatomic, strong) NSMutableArray *elementStack;

/* character of finding */
@property (nonatomic, strong) NSMutableString *textGet;

/* xml which array closed */
@property (nonatomic) BOOL close;

- (void)setURL:(NSString *)urlString;
- (void)startWithParseMode:(ParseMode)mode comcompleteBlock:(void (^)(NSDictionary *))parseCompleted dataSource:(NSObject *)source arrayClosed:(BOOL) close;

@end
@implementation XMLParser

#pragma mark - Class Method.

/* class method in no dictionary close in array mode.
 * 
 * SUCH AS:
 * <data>
 *  <current_condition>
 *      <cloudcover>16</cloudcover>
 *      <humidity>59</humidity>
 *      <observation_time>09:09 PM</observation_time>
 *      <precipMM>0.1</precipMM>
 *      <pressure>1010</pressure>
 *      <temp_C>10</temp_C>
 *      <temp_F>49</temp_F>
 *      <visibility>10</visibility>
 *      <weatherCode>113</weatherCode>
 *      <weatherDesc>
 *          <Value>Clear</Value>
 *      </weatherDesc>
 *      <weatherIconUrl>
 *          <value>
 *              http://www.worldweatheronline.com/images/wsymbols01_png_64/wsymbol_0008_clear_sky_night.png
 *          </value>
 *      </weatherIconUrl>
 *      <winddir16Point>NW</winddir16Point>
 *      <winddirDegree>316</winddirDegree>
 *      <windspeedKmph>47</windspeedKmph>
 *      <windspeedMiles>29</windspeedMiles>
 *  </current_condition>
 *
 * ----------------------------------------------------------------------------------------------------------------
 *  After `DICTIONARY IN ARRAY` parsing:
 *   
 *   data = {
 *            "current_condition" = [
 *                                   {
 *                                     cloudcover = 16;
 *                                       humidity = 59;
 *                                     "observation_time" = "09:09 PM";
 *                                     precipMM = "0.1";
 *                                     pressure = 1010;
 *                                     "temp_C" = 10;
 *                                     "temp_F" = 49;
 *                                     visibility = 10;
 *                                     weatherCode = 113;
 *                                     weatherDesc = [
 *                                                      {
 *                                                          value = Clear;
 *                                                      }
 *                                     ];
 *                                     weatherIconUrl = [
 *                                                      {
 *                                                          value = "http://www.worldweatheronline.com/images/wsymbols01_png_64/wsymbol_0008_clear_sky_night.png";
 *                                                      }
 *                                     ];
 *                                     winddir16Point = NW;
 *                                     winddirDegree = 316;
 *                                     windspeedKmph = 47;
 *                                     windspeedMiles = 29;
 *                                   }
 *                                  ];
 * 
 * ---------------------------------------------------------------------------------------------------------------
 *  Without `DICTIONARY IN ARRAY` parsing:
 *
 *
 *   data = {
 *            "current_condition" = {
 *                                     cloudcover = 16;
 *                                       humidity = 59;
 *                                     "observation_time" = "09:09 PM";
 *                                     precipMM = "0.1";
 *                                     pressure = 1010;
 *                                     "temp_C" = 10;
 *                                     "temp_F" = 49;
 *                                     visibility = 10;
 *                                     weatherCode = 113;
 *                                     weatherDesc = {
 *                                                          value = Clear;
 *                                     }
 *                                     weatherIconUrl = {
 *                                                          value = "http://www.worldweatheronline.com/images/wsymbols01_png_64/wsymbol_0008_clear_sky_night.png";
 *                                     };
 *                                     winddir16Point = NW;
 *                                     winddirDegree = 316;
 *                                     windspeedKmph = 47;
 *                                     windspeedMiles = 29;
 *                                   };
 *
 * ------------------------------------------------------------------------------------------------------------
 *
 */

// generation mode
+ (void)xmlParseByData:(NSData *)data
         completeBlock:(void (^)(NSDictionary *))parseCompleted {
    
    [[[XMLParser alloc] init] startWithParseMode:ParseModeByData
                                comcompleteBlock:parseCompleted
                                      dataSource:data
                                     arrayClosed:NO];
}
+ (void)xmlParseByURL:(NSURL *)url
        completeBlock:(void (^)(NSDictionary *))parseCompleted {
 
    [[[XMLParser alloc] init] startWithParseMode:ParseModeByURL
                                comcompleteBlock:parseCompleted
                                      dataSource:url
                                     arrayClosed:NO];
}
+ (void)xmlParseWithURLByString:(NSString *)stringOfURL
                  completeBlock:(void (^)(NSDictionary *))parseCompleted {
    
    NSURL *url = [NSURL URLWithString:stringOfURL];
    
    [XMLParser xmlParseByURL:url
               completeBlock:parseCompleted];
    
}
+ (void)xmlParseWithXMLParser:(NSXMLParser *)parser
                completeBlock:(void (^)(NSDictionary *))parseCompleted {
    [[[XMLParser alloc] init] startWithParseMode:ParseModeByXMLParser
                                comcompleteBlock:parseCompleted
                                      dataSource:parser
                                     arrayClosed:NO];
}

// `dictionary in array` mode
+ (void)xmlParseByData:(NSData *)data completeBlock:(void (^)(NSDictionary *))parseCompleted dictionaryCloseInArray:(BOOL)close {
    [[[XMLParser alloc] init] startWithParseMode:ParseModeByData
                                comcompleteBlock:parseCompleted
                                      dataSource:data
                                     arrayClosed:close];
}
+ (void)xmlParseByURL:(NSURL *)url completeBlock:(void (^)(NSDictionary *))parseCompleted dictionaryCloseInArray:(BOOL)close {
    
    [[[XMLParser alloc] init] startWithParseMode:ParseModeByURL
                                comcompleteBlock:parseCompleted
                                      dataSource:url
                                     arrayClosed:close];
}
+ (void)xmlParseWithURLByString:(NSString *)stringOfURL completeBlock:(void (^)(NSDictionary *))parseCompleted dictionaryCloseInArray:(BOOL)close {
    
    NSURL *url = [NSURL URLWithString:stringOfURL];
    
    [XMLParser xmlParseByURL:url
               completeBlock:parseCompleted dictionaryCloseInArray:close];
    
}
+ (void)xmlParseWithXMLParser:(NSXMLParser *)parser
                completeBlock:(void (^)(NSDictionary *))parseCompleted
                   dictionaryCloseInArray:(BOOL)close {
    
    [[[XMLParser alloc] init] startWithParseMode:ParseModeByXMLParser
                                comcompleteBlock:parseCompleted
                                      dataSource:parser
                                     arrayClosed:close];
}

#pragma mark - Private Method.
- (void)setURL:(NSString *)urlString
/*
 * set the URL 
 *
 */
{
    
    [self setUrl:[NSURL URLWithString:urlString]];
}

- (void)startWithParseMode:(ParseMode)mode comcompleteBlock:(void (^)(NSDictionary *))parseCompleted dataSource:(NSObject *)source arrayClosed:(BOOL) close
/*
 * start to parsing ...
 *
 */
{
    
    
    NSXMLParser *parse;
    _close = close;
    
    /* block */
    _parseCompleteNow = parseCompleted;
    
    /* set the parse mode */
    switch (mode) {
        case ParseModeByData:
        {
            NSData *data = (NSData *)source;
            parse = [[NSXMLParser alloc] initWithData:data];
        }
            break;
        case ParseModeByURL:
        {
            NSURL *url = (NSURL *)source;
            parse = [[NSXMLParser alloc] initWithContentsOfURL:url];
            
        }
        case ParseModeByXMLParser: {
            
            parse = (NSXMLParser *)source;
        }
            break;
        default:
            break;
    }
    
    [self startWithParseInstance:parse];
    
}
- (void)startWithParseInstance:(NSXMLParser *)parse {
    
    parse.delegate = self;
    [parse parse];
}


#pragma mark - XML parse Delegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    /* get the parent dictionary */
    NSMutableDictionary *parentDict = [_elementStack lastObject];
    NSObject *elementFound = [parentDict objectForKey:elementName];
    
    /* if not exist */
    if(!elementFound) {
        
        NSMutableDictionary *childDict = [NSMutableDictionary new];
        [parentDict setObject:childDict forKey:elementName];
        
        [_elementStack addObject:childDict];
        
    } else  {/* exist this key, means this is array, not dictionary */
        
        /* start from array */
        if( [elementFound isKindOfClass:[NSMutableDictionary class]]) {
            
            NSMutableArray *childs = [NSMutableArray new];
            [childs addObject:elementFound];
            
            [parentDict setObject:childs forKey:elementName];
            
            [childs addObject:[NSMutableDictionary new]];
            [_elementStack addObject:[childs lastObject]];
        }
        
        else {
            
            /* continue from array */
            NSMutableDictionary *childDict = [NSMutableDictionary new];
            NSMutableArray *items = (NSMutableArray *)elementFound;
        
            [items addObject:childDict];
            
            [_elementStack addObject:childDict];
        
        }
    }
    
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

    /* has found the text */
    if( [self.textGet length] > 0) {
        
        [_elementStack removeLastObject];
        NSMutableDictionary *item = [_elementStack lastObject];
        
        [item setObject:_textGet forKey:elementName];
        _textGet = [NSMutableString new];
        
    } else {
    
        [_elementStack removeLastObject];
        
        if (_close) { // when open the <close in Array> mode
            
            id value = [[_elementStack lastObject] valueForKey:elementName];
            if ([value isKindOfClass:[NSDictionary class]]) {
            
                NSMutableArray *arrayClose = [NSMutableArray array];
                [arrayClose addObject:value];
            
                [[_elementStack lastObject] setValue:arrayClose forKey:elementName];
            }
        }
        
        
    }
    
    
    
    
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if([string hasPrefix:@"\n"])
        return ;
    
    [_textGet appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    /* something error */
    NSLog(@"%@", parseError);
}
- (void)parserDidStartDocument:(NSXMLParser *)parser
/* start to parse */
{
    
    _elementStack = [NSMutableArray new];
    _textGet = [NSMutableString new];
    
    [_elementStack addObject:[NSMutableDictionary new]];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    /* parse done */
    NSLog(@"fater parse:\n %@", [_elementStack lastObject]);
    
    NSDictionary *compeltedData = [_elementStack lastObject];
    
    /* second dealing */
    compeltedData = [self settingArrayClosed:compeltedData];
    
    self.parseCompleteNow(compeltedData);
}

#pragma mark - Class Dead
- (void)dealloc {
    NSLog(@"xml class dead");
}

#pragma mark - setting array closed
- (NSDictionary *)settingArrayClosed:(NSDictionary *)result {
    
    /* first, find the main key */
    NSString *key = [result allKeys][0];
    
    /* second, start to close */
    NSDictionary *start = @{ key : [result valueForKey:key][0] };
    
    return start;
}

@end
