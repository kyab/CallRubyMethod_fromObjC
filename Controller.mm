//
//  Controller.m
//  CallRubyMethod_fromObjC
//
//  Created by koji on 10/12/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#include <typeinfo>
#import "Controller.h"
#include "CoreAudio/CoreAudio.h"
#import "MacRuby/MacRuby.h"

#include <string>

//demangle function
//http://d.hatena.ne.jp/hidemon/20080731/1217488497
#include <string>
extern "C" char *__cxa_demangle (
								 const char *mangled_name,
								 char *output_buffer,
								 size_t *length,
								 int *status);

std::string demangle(const char * name) {
    size_t len = strlen(name) + 256;
    char output_buffer[len];
    int status = 0;
    return std::string(
					   __cxa_demangle(name, output_buffer, 
									  &len, &status));
}




template <typename T>
void dump_struct(const T &t){
	const std::type_info &type = typeid(t);
	std::string demangled_type_name = demangle(type.name());
	
	NSValue *v = [NSValue valueWithPointer:&t];
	NSString *typeName = [NSString stringWithCString:demangled_type_name.c_str() encoding:kCFStringEncodingUTF8 ];
	id ruby_util = [[MacRuby sharedRuntime] evaluateString:@"Util"];
	[ruby_util performRubySelector:@selector(dump_struct_withName:) withArguments:v,typeName,NULL];
}

@implementation Controller
- (IBAction)callRubyMethod:(id)sender{
	
	//simple example
	id a = [[MacRuby sharedRuntime] evaluateString:@"AudioBuffer.new"];
	[a performRubySelector:@selector(describe)];	//describe is a extention method for AudioBuffer 	
	
	
	//Dump any C struct with MacRuby(eazy way!!)
	AudioBuffer ab;
	ab.mNumberChannels = 3;
	ab.mDataByteSize = 99;
	ab.mData = NULL;
	
	id ruby_util = [[MacRuby sharedRuntime] evaluateString:@"Util"];
	NSValue *v = [NSValue valueWithPointer:&ab];
	
	//selectorの引数にはid型しか渡せないので、NSValue *にポインタを埋めこんで渡す。
	//更に型名(構造体名)も２つ目の引数に渡してやる。
	[ruby_util performRubySelector:@selector(dump_struct_withName:) withArguments:v,@"AudioBuffer",NULL];
	
	
	
	NSLog(@"------------------------\n");
	//dump_structで一発
	dump_struct(ab);
	
	
}
@end
