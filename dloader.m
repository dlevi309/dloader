#import <Foundation/Foundation.h>
#import <dlfcn.h>

#include <mach-o/dyld.h>

extern const char *__progname;

char dylibs_[800][800];
int count_dylibs_;

static void dloader_make_array()
{
    @autoreleasepool {
        @try {
            NSString *yourFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"dloader"];
            if (access(yourFolderPath.UTF8String, F_OK) != 0) {
            }
            NSArray *array_list = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:yourFolderPath error:nil] ?: [NSArray array] copy];
            array_list = [array_list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF ENDSWITH %@", @"dylib"]];
            array_list = [array_list sortedArrayUsingSelector:@selector(compare:)];
            count_dylibs_ = [array_list count];
            for (int i = 0; i < count_dylibs_; i++) {
                strcpy(dylibs_[i], [yourFolderPath stringByAppendingPathComponent:[array_list objectAtIndex:i] ?: @""].UTF8String);
            }
        } @catch (NSException *e) {
        }
    }
}

__attribute__((constructor)) static void dloader()
{
    dloader_make_array();
    for (int i = 0; i < count_dylibs_; i++) {
        if (access(dylibs_[i], F_OK) == 0) {
            dlopen(dylibs_[i], RTLD_LAZY | RTLD_GLOBAL);
        }
    }
}
