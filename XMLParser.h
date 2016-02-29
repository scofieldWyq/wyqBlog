//
//  XMLParser.h
//  Test
//
//  Created by wuyingqiang on 7/19/15.
//  Copyright (c) 2015 wuyingqiang. All rights reserved.
//

/*
 * first, set the prepare phase.
 * second, start xml parse.
 * finally, set the block of operation when xml parse was done.
 * ------------------------------------------------------------
 *
 * <FUNCTIONALITY>: Parsing XML file into dictionary.
 * 
 * this class just give you several class method to complete your goal.
 * you don't need to set anything for this class, just use one method to deal with your problem.
 * 
 * ---------------------------------------------------------------------------------------------
 * 
 * <CLASS METHOD>:
 *      +xmlParseByData:completeBlock:
 *      +xmlParseByData:completeBlock:dictionaryCloseInArray:
 *      +xmlParseByURL:completeBlock:
 *      +xmlParseByURL:completeBlock:dictionaryCloseInArray:
 *      +xmlParseWithURLByString:completeBlock:
 *      +xmlParseWithURLByString:completeBlock:dictionaryCloseInArray:
 *      +xmlParseWithXMLParser:completeBlock:
 *      +xmlParseWithXMLParser:completeBlock:dictionaryCloseInArray:
 *
 * ---------------------------------------------------------------------------------------------
 *
 * <PARAMETER>:
 *
 *      - data: (NSData *), the data from server you have already download.
 *
 *      - url : (NSURL *), the url of xml in server.
 *
 *      - stringOfURL : (NSString *), the string of URL.
 *
 *      - parser: (NSXMLParser *), XML serializer you have download from server,and convertd. saved in NSXMLPareser.
 * 
 * ------------------------------------------------------------------------------------------------------------------
 *
 * <EXAMPLE>:
 *      
 *     [[[XMLParser alloc] init] xmlParseByData:data
 *                                completeBlock:^(NSDictionary *data) {
 *
 *                                  // yet completed the parsing, data was saved in the 
 *                                  // dictionary,which you have parsing done
 *
 *                                  }];
 *
 * -----------------------------------------------------------------------------------------------------------------
 *
 * <CONSUMMER>:
 * 
 *    - the block's data is the result of parsing.
 *
 * <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Having Fun - END >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-------------
 *
 */

#import <Foundation/Foundation.h>

@interface XMLParser : NSObject

+ (void)xmlParseByData:(NSData *)data
         completeBlock:(void (^)(NSDictionary *data)) parseCompleted;
+ (void)xmlParseByData:(NSData *)data
         completeBlock:(void (^)(NSDictionary *data)) parseCompleted dictionaryCloseInArray:(BOOL)close;
/* parsing xml use data from server
 *
 */

+ (void)xmlParseByURL:(NSURL *)url
        completeBlock:(void (^)(NSDictionary *data)) parseCompleted;
+ (void)xmlParseByURL:(NSURL *)url
        completeBlock:(void (^)(NSDictionary *data)) parseCompleted dictionaryCloseInArray:(BOOL)close;
/* parsing xml url
 *
 */

+ (void)xmlParseWithURLByString:(NSString *)stringOfURL
         completeBlock:(void (^)(NSDictionary *data)) parseCompleted;
+ (void)xmlParseWithURLByString:(NSString *)stringOfURL
                  completeBlock:(void (^)(NSDictionary *data)) parseCompleted dictionaryCloseInArray:(BOOL)close;
/* parsing xml by url string
 *
 */
+ (void)xmlParseWithXMLParser:(NSXMLParser *) parser
                completeBlock:(void (^)(NSDictionary *data)) parseCompleted;
+ (void)xmlParseWithXMLParser:(NSXMLParser *) parser
                completeBlock:(void (^)(NSDictionary *data)) parseCompleted
                   dictionaryCloseInArray:(BOOL) close;
/* parsing xml by NSXMLparser
 *
 */
@end
