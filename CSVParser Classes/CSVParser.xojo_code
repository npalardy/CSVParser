#tag Class
Protected Class CSVParser
	#tag Method, Flags = &h1
		Protected Sub handleLine(lineNumber as integer, values() as string)
		  #Pragma BackgroundTasks False
		  #Pragma BoundsChecking False
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  If treatFirstLineAsHeaders And lineNumber = 1 Then
		    headers(lineNumber, values)
		  else
		    newLine(lineNumber, values)
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub newField(value as String)
		  #Pragma BackgroundTasks False
		  #Pragma BoundsChecking False
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim tmp As String
		  
		  if FieldsEscapedBy <> "" then
		    tmp = value 
		    tmp = replaceAll(tmp,FieldsEscapedBy +FieldsEscapedBy,chrB(0)+chrb(1)+chrb(0))
		    tmp = replaceAll(tmp,FieldsEscapedBy, "")
		    tmp = replaceAll(tmp,chrB(0)+chrb(1)+chrb(0), FieldsEscapedBy)
		    
		    currentRow.append tmp
		  else
		    
		    currentRow.append value
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub parse(f as folderitem)
		  #Pragma BackgroundTasks False
		  #Pragma BoundsChecking False
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking false
		  
		  
		  
		  Dim b As BufferedBinaryInputStream
		  Dim c As Integer
		  Dim fieldCount As Integer
		  Dim fieldBuffer As String
		  Dim state As Integer
		  Dim line As Integer
		  
		  Const start_field = 1
		  Const collect_chars = 2
		  Const end_field = 3 // generally this is a "processing state" and not used
		  Const error = 4
		  const quoted_field = 5
		  const quote_in_quoted_field = 6
		  
		  Redim currentRow(-1)
		  fieldCount = 1
		  state = start_field
		  
		  b = BufferedBinaryInputStream.open(f, False)
		  
		  while b.EOF <> true
		    
		    c = b.ReadUInt8
		    
		    select case state
		    case start_field
		      if fieldCount = 1 then 
		        line = line + 1
		      end if
		      
		      if c = ascB(fieldseparator) then // got a separator when we were expecting to start a field so we just got an empty field
		        // like ,, in a CSV (the field between the comma's is empty)
		        newfield (fieldBuffer)
		        fieldCount = fieldCount + 1
		        fieldBuffer = ""
		        state = start_field
		      elseif c = ascB(fieldenclosure) then // got an field enclosing item (a " in a CSV) to start a field so this is a quoted field
		        state = quoted_field
		      elseif c = 10 or c = 13 then // got a carriage return at the start so this is en empty field as well
		        //                                        in fact this is considered end of line
		        newfield (fieldBuffer)
		        handleLine(line,currentRow)
		        redim currentRow(-1)
		        
		        if c = 13 then // if the line ending was a CR was it a CR LF pair ?
		          if b.EOF = true then exit // if we are at EOF then it wasn't and we can exit the loop
		          
		          c = b.ReadUInt8 // was the next char a chr 10 ?
		          if c = 10 then 
		          else
		            b.Position = b.position - 1 // no so push it back
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
		      if c = ascB(fieldenclosure) then // a quote in an unquoted field .. that's an error
		        state = error
		      elseif c = ascB(fieldseparator) or c = 10 or c = 13 then // a comma CR or LF (cant have CR, LF or CRLF in an unquoted field
		        newfield (fieldBuffer)
		        if c = 10 or c = 13 then 
		          handleLine(line,currentRow)
		          redim currentRow(-1)
		          fieldcount = 1
		          if c = 13 then // was this a CR LF pair ?
		            if b.EOF = true then exit
		            c = b.ReadUInt8
		            if c = 10 then
		            else
		              b.Position = b.position - 1 // no LF so push this one back
		            end if
		          end if
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
		      csvError(line,fieldCount, "An error occured reading field " + str(fieldCount) + " of line " + str(line) )
		      
		      fieldCount = fieldCount + 1
		      fieldBuffer = ""
		      state = start_field
		      
		      c = b.ReadUInt8 // skip forward til we find the start of a new field or the end of line
		      while b.eof <> true 
		        if c = 13 or c = 10 or c = ascB(fieldseparator) then exit
		        c = b.ReadUInt8
		      wend 
		      if c = 13 then // found a CR
		        if b.EOF = true then exit
		        c = b.ReadUInt8
		        if c = 10 then // was it CR LF ?
		        else
		          b.Position = b.position - 1 // no push back the char after the CR
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
		      elseif c = ascB(fieldseparator) or c = 10 or c = 13 then // we got a , CR or LF (folloiwing a ")
		        
		        newfield (fieldBuffer)
		        if c= 10 or c = 13 then 
		          handleLine(line,currentRow)
		          redim currentRow(-1)
		          fieldCount = 1
		          if c = 13 then // if it was a CR did we get CR LF ?
		            if b.EOF = true then exit
		            c = b.ReadUInt8
		            if c = 10 then
		            else
		              b.Position = b.position - 1 // no push back the character so it is next to be dealt with
		            end if
		          end if
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
		      csverror(line,fieldCount,"Unterminated quote on line " + str(line) + " field " + str(fieldCount))
		    else
		      newfield (fieldBuffer)
		      handleLine(line,currentRow)
		      redim currentRow(-1)
		      
		      fieldCount = fieldCount + 1
		    end if
		  end if
		  
		  b.close
		  
		  raiseEvent Finished
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub parse(inputCSVString as string)
		  #Pragma BackgroundTasks False
		  #Pragma BoundsChecking False
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking false
		  
		  
		  
		  Dim b As BufferedBinaryInputStream
		  Dim c As Integer
		  Dim fieldCount As Integer
		  Dim fieldBuffer As String
		  Dim state As Integer
		  Dim line As Integer
		  
		  Const start_field = 1
		  Const collect_chars = 2
		  Const end_field = 3 // generally this is a "processing state" and not used
		  Const error = 4
		  const quoted_field = 5
		  const quote_in_quoted_field = 6
		  
		  Redim currentRow(-1)
		  fieldCount = 1
		  state = start_field
		  
		  b = BufferedBinaryInputStream.open(inputCSVString, False)
		  
		  while b.EOF <> true
		    
		    c = b.ReadUInt8
		    
		    select case state
		    case start_field
		      if fieldCount = 1 then 
		        line = line + 1
		      end if
		      
		      if c = ascB(fieldseparator) then // got a separator when we were expecting to start a field so we just got an empty field
		        // like ,, in a CSV (the field between the comma's is empty)
		        newfield (fieldBuffer)
		        fieldCount = fieldCount + 1
		        fieldBuffer = ""
		        state = start_field
		      elseif c = ascB(fieldenclosure) then // got an field enclosing item (a " in a CSV) to start a field so this is a quoted field
		        state = quoted_field
		      elseif c = 10 or c = 13 then // got a carriage return at the start so this is en empty field as well
		        //                                        in fact this is considered end of line
		        newfield (fieldBuffer)
		        handleLine(line,currentRow)
		        redim currentRow(-1)
		        
		        if c = 13 then // if the line ending was a CR was it a CR LF pair ?
		          if b.EOF = true then exit // if we are at EOF then it wasn't and we can exit the loop
		          
		          c = b.ReadUInt8 // was the next char a chr 10 ?
		          if c = 10 then 
		          else
		            b.Position = b.position - 1 // no so push it back
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
		      if c = ascB(fieldenclosure) then // a quote in an unquoted field .. that's an error
		        state = error
		      elseif c = ascB(fieldseparator) or c = 10 or c = 13 then // a comma CR or LF (cant have CR, LF or CRLF in an unquoted field
		        newfield (fieldBuffer)
		        if c = 10 or c = 13 then 
		          handleLine(line,currentRow)
		          redim currentRow(-1)
		          fieldcount = 1
		          if c = 13 then // was this a CR LF pair ?
		            if b.EOF = true then exit
		            c = b.ReadUInt8
		            if c = 10 then
		            else
		              b.Position = b.position - 1 // no LF so push this one back
		            end if
		          end if
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
		      csvError(line,fieldCount, "An error occured reading field " + str(fieldCount) + " of line " + str(line) )
		      
		      fieldCount = fieldCount + 1
		      fieldBuffer = ""
		      state = start_field
		      
		      c = b.ReadUInt8 // skip forward til we find the start of a new field or the end of line
		      while b.eof <> true 
		        if c = 13 or c = 10 or c = ascB(fieldseparator) then exit
		        c = b.ReadUInt8
		      wend 
		      if c = 13 then // found a CR
		        if b.EOF = true then exit
		        c = b.ReadUInt8
		        if c = 10 then // was it CR LF ?
		        else
		          b.Position = b.position - 1 // no push back the char after the CR
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
		      elseif c = ascB(fieldseparator) or c = 10 or c = 13 then // we got a , CR or LF (folloiwing a ")
		        
		        newfield (fieldBuffer)
		        if c= 10 or c = 13 then 
		          handleLine(line,currentRow)
		          redim currentRow(-1)
		          fieldCount = 1
		          if c = 13 then // if it was a CR did we get CR LF ?
		            if b.EOF = true then exit
		            c = b.ReadUInt8
		            if c = 10 then
		            else
		              b.Position = b.position - 1 // no push back the character so it is next to be dealt with
		            end if
		          end if
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
		      csverror(line,fieldCount,"Unterminated quote on line " + str(line) + " field " + str(fieldCount))
		    else
		      newfield (fieldBuffer)
		      handleLine(line,currentRow)
		      redim currentRow(-1)
		      
		      fieldCount = fieldCount + 1
		    end if
		  end if
		  
		  b.close
		  
		  raiseEvent Finished
		  
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event CSVError(lineNumber as integer, fieldNumber as integer, error as string)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Finished()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Headers(lineNumber as integer, values() as string)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event NewLine(lineNumber as integer, values() as string)
	#tag EndHook


	#tag Property, Flags = &h1
		Protected currentRow(-1) As string
	#tag EndProperty

	#tag Property, Flags = &h0
		fieldenclosure As string = """"
	#tag EndProperty

	#tag Property, Flags = &h0
		fieldseparator As string = ","
	#tag EndProperty

	#tag Property, Flags = &h0
		FieldsEscapedBy As string
	#tag EndProperty

	#tag Property, Flags = &h0
		treatFirstLineAsHeaders As boolean
	#tag EndProperty


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
			Name="fieldseparator"
			Visible=false
			Group="Behavior"
			InitialValue=","
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fieldenclosure"
			Visible=false
			Group="Behavior"
			InitialValue=""""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="treatFirstLineAsHeaders"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FieldsEscapedBy"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
