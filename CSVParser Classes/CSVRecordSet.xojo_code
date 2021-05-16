#tag Class
Protected Class CSVRecordSet
	#tag Method, Flags = &h0
		Function BOF() As boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Close()
		  if not (inputFile is nil) then 
		    
		    inputFile.Close
		    inputfile = nil
		    
		  end if
		  
		  redim currentRow(-1)
		  fieldBuffer = ""
		  fieldCount = 0
		  state = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(f as folderItem)
		  If Not (f Is Nil) Then
		    myFile = f
		    'inputFile = BinaryStream.Open(myFile, false)
		    InputFile = BufferedBinaryInputStream.Open(myFile, False)
		    
		    MoveNext
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(inputCSVString as string)
		  
		  'inputFile = BinaryStream.Open(myFile, false)
		  InputFile = BufferedBinaryInputStream.Open(inputCSVString, False)
		  
		  MoveNext
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteRecord()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Edit()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EOF() As boolean
		  if inputFile is nil then
		    return true
		  else
		    return inputFile.EOF and ( ubound(currentRow) < 0 )
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Field(name as string) As DatabaseField
		  #Pragma unused name
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FieldCount() As integer
		  return ubound(currentRow) + 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IdxField(index as integer) As CSVField
		  dim dbf as CSVField
		  
		  if ubound(currentRow) > -1 and index > 0 and index-1 <= ubound(currentRow) then
		    dbf = new CSVField(currentRow(index-1))
		    
		    return dbf
		  else 
		    return nil
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveFirst()
		  if inputFile is nil then
		    
		    //inputFile = BinaryStream.Open(myFile, false)
		    inputFile = BufferedBinaryInputStream.Open(myFile, false)
		  end if
		  
		  inputFile.Position = 0
		  
		  MoveNext
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveLast()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveNext()
		  dim c as integer
		  
		  redim currentRow(-1)
		  fieldBuffer = ""
		  fieldCount = 1
		  state = start_field
		  
		  if inputFile is nil then
		    Return
		  end if
		  
		  while inputFile.eof <> true
		    
		    c = inputFile.ReadUInt8
		    
		    select case state
		    case start_field
		      //if fieldCount = 1 then
		      //line = line + 1
		      //end if
		      
		      if c = ascB(",") then // got a comma when we were expecting to start a field so we just got an empty field
		        //                                   like ,, (the field between the comma's is empty)
		        newfield (fieldBuffer)
		        fieldCount = fieldCount + 1
		        fieldBuffer = ""
		        state = start_field
		      elseif c = ascB("""") then // got a quote to start a field so this is a quoted field
		        state = quoted_field
		      elseif c = 10 or c = 13 then // got a carriage return at the start so this is en empty field as well
		        //                                        in fact this is considered end of line
		        newfield (fieldBuffer)
		        fieldBuffer = ""
		        
		        // newline(line,currentRow) // we have a new line !!!!
		        Exit
		        
		        if c = 13 then // if the line ending was a CR was it a CR LF pair ?
		          if inputFile.EOF = true then exit // if we are at EOF then it wasn't and we can exit the loop
		          
		          c = inputFile.ReadUInt8 // was the next char a chr 10 ?
		          if c = 10 then
		          else
		            inputFile.Position = inputFile.position - 1 // no so push it back
		          end if
		        end if
		        fieldcount = 1
		        fieldBuffer = ""
		        state = start_field
		      else
		        fieldBuffer = fieldBuffer + chrB(c) // other wise we go a char that we just want to save and go to
		        //                                                   the collecting characters state
		        state = collect_chars
		      end if
		      
		    case collect_chars
		      if c = ascB("""") then // a quote in an unquoted field .. that's an error
		        state = error
		      elseif c = ascB(",") or c = 10 or c = 13 then // a comma CR or LF (cant have CR, LF or CRLF in an unquoted field
		        newfield (fieldBuffer)
		        fieldBuffer = ""
		        
		        if c = 10 or c = 13 then
		          // newline(line,currentRow)
		          if c = 13 then // was this a CR LF pair ?
		            if inputFile.EOF = true then exit
		            c = inputFile.ReadUInt8
		            if c = 10 then
		            else
		              inputFile.Position = inputFile.position - 1 // no LF so push this one back
		            end if
		          end if
		          
		          exit // new line !!!!
		          
		        else
		          fieldCount = fieldCount + 1
		        end if
		        
		        fieldBuffer = ""
		        state = start_field
		      else
		        fieldBuffer = fieldBuffer + chrB(c) // just add this char to the buffer
		        state = collect_chars
		      end if
		      
		      //case end_field
		      
		    case error // whoops .... an error state
		      //csvError(line,fieldCount, "An error occured reading field " + str(fieldCount) + " of line " + str(line) )
		      
		      fieldCount = fieldCount + 1
		      fieldBuffer = ""
		      state = start_field
		      
		      c = inputFile.ReadUInt8 // skip forward til we find the start of a new field or the end of line
		      while inputFile.eof <> true
		        if c = 13 or c = 10 or c = ascB(",") then exit
		        c = inputFile.ReadUInt8
		      wend
		      if c = 13 then // found a CR
		        if inputFile.EOF = true then exit
		        c = inputFile.ReadUInt8
		        if c = 10 then // was it CR LF ?
		        else
		          inputFile.Position = inputFile.position - 1 // no push back the char after the CR
		        end if
		      end if
		      
		    case quoted_field
		      if c = ascB("""") then // we're in a quoted field and got a quote
		        state = quote_in_quoted_field // now we are in a quote in a quoted field
		      else
		        fieldBuffer = fieldBuffer + chrB(c) // just add the character (note this allows embedded CR, LF, etc)
		      end if
		      
		    case quote_in_quoted_field
		      if c = ascB("""") then // we've already had one quote did we get a second ie "" ?
		        fieldBuffer = fieldBuffer + chrB(c) // add it to the buffer
		        state = quoted_field // yup ... add the second one and go back tp collecting characters in a quoted field
		      elseif c = ascB(",") or c = 10 or c = 13 then // we got a , CR or LF (folloiwing a ")
		        
		        newfield (fieldBuffer)
		        fieldBuffer = ""
		        
		        if c= 10 or c = 13 then
		          // newLine(line,currentRow)
		          
		          fieldCount = 1
		          if c = 13 then // if it was a CR did we get CR LF ?
		            if inputFile.EOF = true then exit
		            c = inputFile.ReadUInt8
		            if c = 10 then
		            else
		              inputFile.Position = inputFile.position - 1 // no push back the character so it is next to be dealt with
		            end if
		          end if
		          exit
		          
		        else
		          fieldCount = fieldCount + 1
		        end if
		        
		        fieldBuffer = ""
		        state = start_field
		      else // we got a quote followed by something OTHER than a comma , CR or LF
		        // normally this might be considered an error ... but we'll just allow it and move on
		        // could add a call to csvError here and spin forward to find the next field start
		        fieldBuffer = fieldBuffer + chrB(c) // add it to the buffer
		        state = quoted_field // yup ... add the second one and go back tp collecting characters in a quoted field
		      end if
		      
		    end select
		    
		  wend
		  
		  
		  if lenB(fieldBuffer) > 0 then // if there was w buffer in progress we got a field of some sort
		    if state = quoted_field then // if we were in a quoted field we have an unterminated quote
		      //csverror(line,fieldCount,"Unterminated quote on line " + str(line) + " field " + str(fieldCount))
		    else
		      newfield (fieldBuffer)
		      
		    end if
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MovePrevious()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub newField(value as String)
		  
		  currentRow.append value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RecordCount() As integer
		  return -1
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Update()
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected currentRow() As string
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected fieldBuffer As string
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected fieldCount As integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected InputFile As BufferedBinaryInputStream
	#tag EndProperty

	#tag Property, Flags = &h0
		myFile As folderItem
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected state As integer
	#tag EndProperty


	#tag Constant, Name = collect_chars, Type = Double, Dynamic = False, Default = \"2", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = end_field, Type = Double, Dynamic = False, Default = \"3", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = error, Type = Double, Dynamic = False, Default = \"4", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = quoted_field, Type = Double, Dynamic = False, Default = \"5", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = quote_in_quoted_field, Type = Double, Dynamic = False, Default = \"6", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = start_field, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
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
	#tag EndViewBehavior
End Class
#tag EndClass
