# ruby_ext.rb
# CallRubyMethod_fromObjC
#
# Created by koji on 10/12/27.
# Copyright 2010 __MyCompanyName__. All rights reserved.


class Util

	#dump c struct.
	#assume o is a NSValue and o.pointerValue returns address to target struct
	def self.dump_struct_withName(o,klass_name)
		if (o.kind_of?(NSValue))
			pointer = o.pointerValue
			#p pointer.class	#=>Pointer
			
			pointer.cast!(TopLevel.const_get(klass_name).type)
			struct = pointer[0]
			
			return unless struct.class.respond_to?(:fields)
			
			puts "dumping struct #{struct.class}"
			struct.class.fields.each do |field_name|
				puts "\t#{field_name.to_s} = #{struct.__send__(field_name)}"
			end
		end
	end

end
		
