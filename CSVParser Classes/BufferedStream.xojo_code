#tag Class
Protected Class BufferedStream
	#tag Method, Flags = &h0
		Sub Close()
		  mStream.Close
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(f as folderitem, readWrite as Boolean = False)
		  #Pragma BackgroundTasks False
		  #Pragma BoundsChecking False
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  #Pragma Unused readWrite
		  
		  // f as folderitem, readWrite as Boolean = False
		  // we're going to IGNORE READWRITE for now :)
		  
		  mStream = BinaryStream.Open(f, False)
		  
		  mBuffer = mStream.Read( kChunkSize, Nil )
		  
		  mOffsetInBuffer = 0
		  
		  mLastFilePosition = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Open(f as folderitem, readWrite as Boolean = False) As BufferedStream
		  
		  return new BufferedStream(f, readwrite)
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
		    
		    mBuffer = mStream.Read( kChunkSize, Nil )
		    
		    mOffsetInBuffer = 0
		    
		  Else
		    
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

	#tag Property, Flags = &h1
		Protected mBuffer As memoryblock
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
			  
			  If mOffsetInBuffer > 0 Then
			    mOffsetInBuffer = mOffsetInBuffer - 1
			  Else
			    // back up in the file itself !
			    break
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
			Name="mStream"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
