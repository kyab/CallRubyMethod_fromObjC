//
//  Controller.m
//  CallRubyMethod_fromObjC
//
//  Created by koji on 10/12/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#include <typeinfo>	
#include "CoreAudio/CoreAudio.h"
#import "Controller.h"
#import "MacRuby/MacRuby.h"	//for [MacRuby sharedRuntime]

#include <string>

//demangle function (gcc only)
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


//MacRubyへのブリッジ関数
template <typename T>
void dump_struct(const T &t){
	
	//型名を文字列で取得
	const std::type_info &type = typeid(t);
	std::string demangled_type_name = demangle(type.name());
	
	//NSValueにポインタを入れて、型名と共にRuby側にわたす。
	//(ポインタやid型以外を直接Rubyのメソッドの引数に渡せない
	NSValue *v = [NSValue valueWithPointer:&t];
	NSString *typeName = [NSString stringWithCString:demangled_type_name.c_str() encoding:kCFStringEncodingUTF8 ];
	id ruby_util = [[MacRuby sharedRuntime] evaluateString:@"Util"];
	[ruby_util performRubySelector:@selector(dump_struct_withName:) withArguments:v,typeName,NULL];
}

@implementation Controller

//ボタンがクリックされたときのアクション
- (IBAction)callRubyMethod:(id)sender{
	
	AudioStreamBasicDescription format;		//defined in CoreAudioTypes.h
	format.mSampleRate = 44100.0;
	format.mFormatID = kAudioFormatLinearPCM;
	format.mFormatFlags = 41;
	format.mBytesPerPacket = 4;
	format.mFramesPerPacket = 1;
	format.mBytesPerFrame = 4;
	format.mChannelsPerFrame = 2;
	format.mBitsPerChannel = 32;
	format.mReserved = 0;
	
	dump_struct(format);
	
}
@end
