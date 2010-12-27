# ruby_ext.rb
# CallRubyMethod_fromObjC
#
# Created by koji on 10/12/27.
# Copyright 2010 __MyCompanyName__. All rights reserved.

class PureRubyClass
	def foo
		puts "PureRubyClass.foo"
	end
end


framework "CoreAudio"
class AudioBuffer
	
	def describe
		puts "AudioBuffer.describe"
		p self
	end
	
	def foo_arg1(arg1)
		puts "AudioBuffer.foo_arg1(#{arg1})"
	end
	
	def foo_arg2(arg1,arg2)
		puts "AudioBuffer.foo_arg2(#{arg1},#{arg2})"
	end
end



class Util

	#dumping c struct.
	#assume o is a NSValue and address of target struct could be obtained
	#by o.pointerValue
	def self.dump_struct_withName(o,klass_name)
		#puts "dump_struct_withName"
		#puts "args class=" + o.class.to_s
		#p o
		
		#puts "go inside"
		if (o.kind_of?(NSValue))
			pointer = o.pointerValue
			#p pointer
			#p pointer.type
			pointer.cast!(TopLevel.const_get(klass_name).type)
			#p pointer.type
			p pointer[0]
		end
		
	end

	def initialize()
		puts "in Ruby: Util.new called"
	end
end
		
