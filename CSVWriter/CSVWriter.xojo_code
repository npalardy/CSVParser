#tag Class
Protected Class CSVWriter
	#tag Method, Flags = &h0
		Sub Close()
		  mIsClosed = True
		  mOutStream.Close
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  // the no param constructor is really ONLY so you can drop one on a layout
		  
		  mwasZeroParamConstructed = true
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(f as FolderItem)
		  // #Pragma BackgroundTasks False
		  // #Pragma BoundsChecking False
		  // #Pragma NilObjectChecking False
		  // #Pragma StackOverflowChecking false
		  If f Is Nil Then
		    Raise New UnsupportedOperationException("Cant write a csv into a nil item")
		  End If
		  
		  If f.IsFolder then
		    Raise New UnsupportedOperationException("Cant write a csv into a directory")
		  End If
		  
		  If f.exists = True Then
		    Raise New UnsupportedOperationException("Cant write a csv into an existing file using this method. Open the file as a text outoput stream and append to it using the other constructor.")
		  End If
		  
		  mOutFile = f
		  
		  // note this could raise an exception like an IOException that is out of our control
		  
		  mOutStream = TextOutputStream.Create(f)
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(outputStream as textoutputstream)
		  // #Pragma BackgroundTasks False
		  // #Pragma BoundsChecking False
		  // #Pragma NilObjectChecking False
		  // #Pragma StackOverflowChecking false
		  
		  mOutStream = outputStream
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub SetEOL()
		  If mHasWritten Then
		    Return
		  End If
		  
		  Select Case meolStyle
		    
		  Case EOLStyles.Default
		    mEOL = EndOfLine
		    
		  Case EOLStyles.MacOS
		    mEOL = EndOfLine.macOS
		    
		  Case EOLStyles.Windows
		    mEOL = EndOfLine.Windows
		    
		  Case EOLStyles.Linux
		    mEOL = EndOfLine.UNIX
		    
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Write(rs as recordset)
		  If rs Is Nil Then 
		    Return
		  End If
		  
		  If mIsClosed Then
		    Raise New UnsupportedOperationException("Writer is closed")
		  End If
		  
		  SetEOL
		  
		  mHasWritten = True
		  
		  If mWasZeroParamConstructed And mOutStream Is Nil Then
		    mOutStream = RaiseEvent Setup
		  End If
		  
		  If mOutStream Is Nil Then
		    Raise New UnsupportedOperationException("Unable to write to nil output stream")
		  End If
		  
		  While rs.eof <> True
		    
		    For i As Integer = 1 To rs.FieldCount
		      
		      If i > 1 Then
		        WriteComma
		      End If
		      
		      Writefield(rs.IdxField(i))
		      
		    Next
		    
		    WriteEndOfLine
		    
		    rs.MoveNext
		    
		  Wend
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub WriteComma()
		  mOutStream.Write ","
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub WriteEndOfLine()
		  #Pragma BackgroundTasks False
		  #Pragma BoundsChecking False
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  mOutStream.write mEOL
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub WriteField(value as variant)
		  #Pragma BackgroundTasks False
		  #Pragma BoundsChecking False
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim tmp As String = value.StringValue
		  Dim shouldQuoteField As Boolean
		  
		  Select Case value.Type
		    
		  Case Variant.TypeBoolean
		    If IsEventImplemented("ReformatBoolean") Then
		      tmp = RaiseEvent ReformatBoolean(value.BooleanValue)
		    End If
		    
		  Case Variant.TypeColor
		    If IsEventImplemented("ReformatColor") Then
		      tmp = RaiseEvent ReformatColor(value.ColorValue)
		    End If
		    
		  Case Variant.TypeCurrency
		    If IsEventImplemented("ReformatCurrency") Then
		      tmp = RaiseEvent ReformatCurrency(value.CurrencyValue)
		    End If
		    
		  Case Variant.TypeDate
		    If IsEventImplemented("ReformatDate") Then
		      tmp = RaiseEvent ReformatDate(value.DateValue)
		    End If
		    
		  Case Variant.TypeDateTime
		    If IsEventImplemented("ReformatDateTime") Then
		      tmp = RaiseEvent ReformatDateTime(value.DateTimeValue)
		    End If
		    
		  Case Variant.TypeDouble
		    If IsEventImplemented("ReformatDouble") Then
		      tmp = RaiseEvent ReformatDouble(value.DoubleValue)
		    End If
		    
		  Case Variant.TypeInt32
		    If IsEventImplemented("ReformatInt32") Then
		      tmp = RaiseEvent ReformatInt32(value.Int32Value)
		    End If
		    
		  Case Variant.TypeInt64
		    If IsEventImplemented("ReformatInt64") Then
		      tmp = RaiseEvent ReformatInt64(value.Int64Value)
		    End If
		    
		  Case Variant.TypeNil
		    If IsEventImplemented("ReformatNil") Then
		      tmp = RaiseEvent ReformatNil(Nil)
		    End If
		    
		  Case Variant.TypeSingle
		    If IsEventImplemented("ReformatSingle") Then
		      tmp = RaiseEvent ReformatSingle(value.SingleValue)
		    End If
		    
		  Case Variant.TypeString
		    shouldQuoteField = True
		    If IsEventImplemented("ReformatString") Then
		      tmp = RaiseEvent ReformatString(value.StringValue)
		    End if
		    
		  Else
		    If IsEventImplemented("ReformatValue") Then
		      tmp = RaiseEvent ReformatValue(value)
		    End If
		    
		  End Select
		  
		  
		  // ok now
		  // 
		  // we use " as the field quote character
		  // 
		  // fields that contain " get surrounded with " And the ones In the field get doubled up
		  // fields that contain ' get surrounded with quotes
		  // fields that contain CR, LF Or CRLF get quoted And quotes In them get doubled up
		  
		  If InStr(tmp,"""") > 0 Then
		    shouldQuoteField = True
		    tmp = ReplaceAll(tmp, """", """""")
		  End If
		  If InStr(tmp,"'") > 0 Then
		    shouldQuoteField = True
		  End If
		  If InStr(tmp,&u10) > 0 Then
		    shouldQuoteField = True
		  End If
		  If InStr(tmp,&u0D) > 0 Then
		    shouldQuoteField = True
		  End If
		  
		  If shouldQuoteField Then
		    mOutStream.write """"
		  End If
		  mOutStream.Write tmp
		  If shouldQuoteField Then
		    mOutStream.write """"
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteLine(ParamArray values as Variant)
		  #Pragma BackgroundTasks False
		  #Pragma BoundsChecking False
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  If mIsClosed Then
		    Raise New UnsupportedOperationException("Writer is closed")
		  End If
		  
		  SetEOL
		  
		  mHasWritten = True
		  
		  If mWasZeroParamConstructed And mOutStream Is Nil Then
		    mOutStream = RaiseEvent Setup
		  End If
		  
		  If mOutStream Is Nil Then
		    Raise New UnsupportedOperationException("Unable to write to nil output stream")
		  End If
		  
		  For i As Integer = 0 To values.ubound
		    
		    If i > 0 Then
		      WriteComma
		    End If
		    
		    Writefield(values(i))
		    
		  Next
		  
		  WriteEndOfLine
		  
		  
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event ReformatBoolean(value as boolean) As string
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReformatColor(value as color) As string
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReformatCurrency(value as Currency) As string
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReformatDate(value as date) As string
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReformatDateTime(value as DateTime) As string
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReformatDouble(value as double) As string
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReformatInt32(value as int32) As string
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReformatInt64(value as int64) As string
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReformatNil(value as variant) As string
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReformatSingle(value as Single) As string
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReformatString(value as String) As string
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReformatValue(value as Variant) As string
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Setup() As TextOutputStream
	#tag EndHook


	#tag Note, Name = About EOL Style
		
		You can set this ight up until you FIRST write
		Once you have wriotten data you cannot chnage the EOL Style
		
		the styles are 
		  Default - uses the EOL style for the platform the code is running on
		  macOS - uses macOS end of line
		  Windows - uses Windows end of line
		  Linux - uses linux style end of line
		
	#tag EndNote

	#tag Note, Name = About the output format
		
		we use " as the field quote character
		
		fields that contain " get surrounded with " and the ones in the field get doubled up
		fields that contain ' get surrounded with quotes
		fields that contain CR, LF or CRLF get quoted and quotes in them get doubled up
		
		
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return meolStyle
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If mHasWritten = True Then
			    Return
			  End If
			  
			  meolStyle = value
			End Set
		#tag EndSetter
		EOLStyle As EOLStyles
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected mEOL As string
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mEOLStyle As EOLStyles
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mHasWritten As boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mIsClosed As boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mOutFile As folderitem
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mOutStream As TextOutputstream
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mWasZeroParamConstructed As boolean
	#tag EndProperty


	#tag Enum, Name = EOLStyles, Type = Integer, Flags = &h0
		Default
		  MacOS
		  Windows
		Linux
	#tag EndEnum


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
			Name="EOLStyle"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="EOLStyles"
			EditorType="Enum"
			#tag EnumValues
				"0 - Default"
				"1 - MacOS"
				"2 - Windows"
				"3 - Linux"
			#tag EndEnumValues
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
