/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComAtypicalHtmlToPDFModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@interface UIPrintPageRenderer (PDF)

- (NSData*) printToPDF;

@end

@implementation UIPrintPageRenderer (PDF)

- (NSData*) printToPDF
{
    NSMutableData *pdfData = [NSMutableData data];
    
    UIGraphicsBeginPDFContextToData( pdfData, CGRectZero, nil );
    
    [self prepareForDrawingPages: NSMakeRange(0, self.numberOfPages)];
    
    CGRect bounds = UIGraphicsGetPDFContextBounds();
    
    for ( int i = 0 ; i < self.numberOfPages ; i++ )
    {
        UIGraphicsBeginPDFPage();
        
        [self drawPageAtIndex: i inRect: bounds];
    }
    
    UIGraphicsEndPDFContext();
    
    return pdfData;
}
@end



@implementation ComAtypicalHtmlToPDFModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"52d4ed3d-a173-4db7-8dcc-b5b3b1137715";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.atypical.htmlToPDF";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}




- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"[INFO] didFailLoadWithError called");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"[INFO] shouldStartLoadWithRequest called");
    return TRUE;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"[INFO] webViewDidStartLoad called");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"[INFO] webViewDidFinishLoad called");
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
        
        [render addPrintFormatter:webView.viewPrintFormatter startingAtPageAtIndex:0];
        
        CGRect printableRect = CGRectMake(36,
                                          72,
                                          540,
                                          684);
        
        CGRect paperRect = CGRectMake(0, 0, 612, 792);
        
        [render setValue:[NSValue valueWithCGRect:paperRect] forKey:@"paperRect"];
        [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
        
        NSData *pdfData = [render printToPDF];
		
        NSArray *dirPaths;
        NSString *path;
        
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
        
        path = [NSString stringWithFormat:@"%@/%@",[dirPaths objectAtIndex:0], @"temp_file_name.pdf"];
        TiBlob* pdfBlob = [[[TiBlob alloc] initWithData:pdfData
											   mimetype:@"application/octet-stream"] autorelease];
        NSLog(@"[INFO] writing blob to: %@", path)
        [pdfBlob writeTo: path error:NULL];
        
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:path, @"pdf", nil];
        NSLog(@"[INFO] firing 'pdfready' event");
        
        [self fireEvent:@"pdfready" withObject:event];
        NSLog(@"[INFO] webViewDidFinishLoad done");
    });
}











#pragma Public APIs
- (void) setHtmlString:(NSString*)html {
    NSLog(@"[INFO] setHtmlString called");
    dispatch_async(dispatch_get_main_queue(), ^{
        webview = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, 1, 1)];
        [webview setDelegate: self];
        [webview loadHTMLString:html baseURL: nil];
        NSLog(@"[INFO] setHtmlString done");
    });
}



@end
