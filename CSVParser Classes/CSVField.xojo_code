#tag Class
Protected Class CSVField
	#tag Method, Flags = &h0
		Sub Constructor(s as string)
		  myValue = s
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StringValue() As string
		  return myValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub StringValue(assigns s as string)
		  myValue = s
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected myValue As variant
	#tag EndProperty


	#tag ViewBehavior
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
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
