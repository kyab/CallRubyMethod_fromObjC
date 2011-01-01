# ruby_ext.rb
# CallRubyMethod_fromObjC
#
# Created by koji on 10/12/27.
# Copyright 2010 __MyCompanyName__. All rights reserved.


class Util

	#dump c struct.
	#assume o is a NSValue and o.pointerValue returns address to target struct
	def self.dump_struct_withName(o,klass_name)

		#puts "go inside"
		if (o.kind_of?(NSValue))
			pointer = o.pointerValue
			puts pointer.class 		#=>Pointer
			
			pointer.cast!(TopLevel.const_get(klass_name).type)
			
			#ポインタから実体を取り出して、pする。あとはRuby側のObject.inspectが頑張る。
			p pointer[0]
		end
		
	end

end
		
