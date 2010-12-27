//
//  main.m
//  CallRubyMethod_fromObjC
//
//  Created by koji on 10/12/27.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
