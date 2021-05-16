#tag Class
Protected Class BufferedBinaryInputStream
	#tag Method, Flags = &h0
		Sub Close()
		  mStream.Close
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Constructor(f as folderitem, readWrite as Boolean, buffersize as integer)
		  #Pragma BackgroundTasks False
		  #Pragma BoundsChecking False
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  #Pragma Unused readWrite
		  
		  // f as folderitem, readWrite as Boolean = False
		  // we're going to IGNORE READWRITE for now :)
		  
		  mStream = BinaryStream.Open(f, False)
		  
		  mBufferSize = buffersize
		  
		  mBuffer = mStream.Read( mBufferSize, Nil )
		  
		  mOffsetInBuffer = 0
		  
		  mLastFilePosition = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Constructor(inputCSVString as string, readWrite as Boolean, buffersize as integer)
		  #Pragma BackgroundTasks False
		  #Pragma BoundsChecking False
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  #Pragma Unused readWrite
		  
		  // we're going to IGNORE READWRITE for now :)
		  Dim mb As memoryblock = inputCSVString
		  
		  mStream = New BinaryStream(mb)
		  
		  mBufferSize = buffersize
		  
		  mBuffer = mStream.Read( mBufferSize, Nil )
		  
		  mOffsetInBuffer = 0
		  
		  mLastFilePosition = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Open(f as folderitem) As BufferedBinaryInputStream
		  
		  return Open(f, false)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Open(f as folderitem, readWrite as Boolean) As BufferedBinaryInputStream
		  
		  return Open(f, readwrite, kChunkSize)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Open(f as folderitem, readWrite as Boolean, bufferSize as integer) As BufferedBinaryInputStream
		  
		  return new BufferedBinaryInputStream(f, readwrite, if(buffersize<=0, kChunkSize, bufferSize))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Open(csvInputString as string) As BufferedBinaryInputStream
		  
		  return Open(csvInputString, false)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Open(csvInputString as string, readWrite as Boolean) As BufferedBinaryInputStream
		  
		  return Open(csvInputString, readwrite, kChunkSize)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Open(csvInputString as string, readWrite as Boolean, bufferSize as integer) As BufferedBinaryInputStream
		  
		  return new BufferedBinaryInputStream(csvInputString, readwrite, if(buffersize<=0, kChunkSize, bufferSize))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadUInt8() As Uint8
		  #Pragma BackgroundTasks False
		  #Pragma BoundsChecking False
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  If mOffsetInBuffer >= mBuffer.Size Then
		    
		    mLastFilePosition = mStream.Position
		    
		    mBuffer = mStream.Read( mBufferSize, Nil )
		    
		    mOffsetInBuffer = 0
		  ElseIf mOffsetInBuffer < 0 Then
		    
		    Return 0
		    
		  End If
		  
		  Dim retValue As UInt8 
		  
		  If EOF = False Then
		    retValue = mBuffer.UInt8Value( mOffsetInBuffer )
		    
		    mOffsetInBuffer = mOffsetInBuffer + 1
		  End If
		  
		  Return retValue
		  
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mLastFilePosition + mOffsetInBuffer < mStream.Length Then
			    Return False
			  Else
			    Return True
			  End If
			  
			End Get
		#tag EndGetter
		EOF As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mStream.Length
			End Get
		#tag EndGetter
		Length As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected mBuffer As memoryblock
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mBufferSize As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mLastFilePosition As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mOffsetInBuffer As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mStream As binaryStream
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mLastFilePosition + mOffsetInBuffer
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  
			  Dim adjustedbufferreadsize As Integer = mBufferSize
			  
			  If value >= mLastFilePosition And value <= mLastFilePosition + mBuffer.Size Then
			    
			    mOffsetInBuffer = value - mLastFilePosition
			    
			  Elseif value < mLastFilePosition Then
			    
			    // back up in the file itself !
			    If mLastFilePosition >= mStream.Length Then
			      
			      If mStream.Position - mBufferSize < 0 Then
			        adjustedbufferreadsize = max(value, 0)
			      End If
			      mStream.Position = max(0, mStream.Position - mBufferSize)
			      
			    Else
			      
			      If mStream.Position - mBuffer.Size - mBufferSize < 0 Then
			        adjustedbufferreadsize = max(value, 0)
			      End If
			      mStream.Position = max(0, mStream.Position - mBuffer.Size - mBufferSize)
			      
			    End If
			    
			    mLastFilePosition = mStream.Position
			    
			    mBuffer = mStream.Read( adjustedbufferreadsize, Nil )
			    
			    mOffsetInBuffer = value - mLastFilePosition
			    
			  Elseif value > mLastFilePosition + mBuffer.Size Then
			    
			    Break
			    
			  Else
			    
			    Break
			    
			  End If
			End Set
		#tag EndSetter
		position As Integer
	#tag EndComputedProperty


	#tag Constant, Name = kChunkSize, Type = Double, Dynamic = False, Default = \"131072", Scope = Protected
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="EOF"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="position"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Length"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
