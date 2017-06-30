#import "Document.h"
//#import <objc/runtime.h>

void objc_release(id object);

static NSInteger nExtraReleases = 3;

@interface Document ()

@end

@implementation Document

- (instancetype)init {
    self = [super init];

    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

+ (BOOL)autosavesInPlace {
    return YES;
}


- (void)makeWindowControllers {
    // Override to return the Storyboard file name of the document.
    [self addWindowController:[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"Document Window Controller"]];
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    return [NSData data];
}


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    return YES;
}

- (void)dealloc {
    NSLog(@"Dealloc doc %p", self) ;
}

- (NSError*)willPresentError:(NSError *)error {
    if (
        [[error domain] isEqualToString:NSCocoaErrorDomain]
        &&
        ([error code] == 67001)
        ) {

        NSLog(@"Doing %ld extra releases to %p", nExtraReleases, self) ;
        for (NSInteger i=0; i<nExtraReleases; i++) {
            objc_release(self);
        }

        nExtraReleases++;
    }

    return [super willPresentError:error];
}


@end
