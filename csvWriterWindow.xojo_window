#tag Window
Begin Window csvWriterWindow
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF00
   Composite       =   False
   DefaultLocation =   0
   FullScreen      =   False
   HasBackColor    =   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   Height          =   400
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   0
   MenuBarVisible  =   True
   MinimumHeight   =   400
   MinimumWidth    =   600
   Resizeable      =   True
   Title           =   "Writer Tests"
   Type            =   0
   Visible         =   True
   Width           =   600
   Begin PushButton pbWriteDir
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   False
      Caption         =   "Try writing to a directory"
      Default         =   False
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   350
   End
   Begin PushButton pbWriteExisting
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   False
      Caption         =   "Try writing to an existing folderitem"
      Default         =   False
      Enabled         =   True
      Height          =   20
      HelpTag         =   "Note you _could_ append to a file IF you first open it as a textutputstream to be written to\n\n"
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   52
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   350
   End
   Begin PushButton pbWriteNew
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   False
      Caption         =   "Simple writing to a new file (no use of events)"
      Default         =   False
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   84
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   350
   End
   Begin PushButton pbWriteNewWithEvents
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   False
      Caption         =   "Writing to a new file with reformat events"
      Default         =   False
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   116
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   350
   End
   Begin CSVWriter writer1
      Index           =   -2147483648
      LockedInPosition=   False
      Scope           =   0
      TabPanelIndex   =   0
   End
End
#tag EndWindow

#tag WindowCode
	#tag Method, Flags = &h21
		Private Sub writeCSVSampleData(writer as CSVWriter)
		  
		  // ok we want to try several things
		  
		  Try
		    
		    writer.WriteLine( 123, "a string", "a string with ' in it", "a string with "" in it" )
		    
		    writer.WriteLine( New Date(), "a "+EndOfLine+"string", dateTime.Now() )
		    
		  Catch usoEx As UnsupportedOperationException
		    
		    Break
		    
		  End Try
		  
		  // this is particularly important for the event driven control on a layout !
		  
		  writer.Close
		  
		  
		End Sub
	#tag EndMethod


#tag EndWindowCode

#tag Events pbWriteDir
	#tag Event
		Sub Action()
		  
		  Dim dlg As New SelectFolderDialog
		  
		  Dim f As folderitem = dlg.ShowModal
		  
		  If f <> Nil Then
		    Try
		      Dim csvwrite As New CSVWriter( f )
		      // ok lets write 
		      writeCSVSampleData( csvwrite )
		      
		    Catch usoEx As UnsupportedOperationException
		      msgbox usoEx.Message
		    End Try
		  End If
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events pbWriteExisting
	#tag Event
		Sub Action()
		  
		  Dim dlg As New OpenFileDialog
		  
		  Dim f As folderitem = dlg.ShowModal
		  
		  If f <> Nil Then
		    Try
		      Dim csvwrite As New CSVWriter( f )
		      // ok lets write 
		      writeCSVSampleData( csvwrite )
		      
		    Catch usoEx As UnsupportedOperationException
		      msgbox usoEx.Message
		    End Try
		  End If
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events pbWriteNew
	#tag Event
		Sub Action()
		  
		  Dim dlg As New SaveFileDialog
		  
		  Dim f As folderitem = dlg.ShowModal
		  
		  If f <> Nil Then
		    Try
		      Dim csvwrite As New CSVWriter( f )
		      // ok lets write 
		      writeCSVSampleData( csvwrite )
		      
		    Catch usoEx As UnsupportedOperationException
		      MsgBox usoEx.Message
		    End Try
		  End If
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events pbWriteNewWithEvents
	#tag Event
		Sub Action()
		  // ok lets write 
		  writeCSVSampleData( writer1 )
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events writer1
	#tag Event
		Function ReformatBoolean(value as boolean) As string
		  
		  
		  Dim v As Variant = value
		  
		  Return v.stringvalue
		End Function
	#tag EndEvent
	#tag Event
		Function ReformatColor(value as color) As string
		  
		  
		  Dim v As Variant = value
		  
		  Return v.stringvalue
		End Function
	#tag EndEvent
	#tag Event
		Function ReformatCurrency(value as Currency) As string
		  
		  
		  Dim v As Variant = value
		  
		  Return v.stringvalue
		End Function
	#tag EndEvent
	#tag Event
		Function ReformatDate(value as date) As string
		  
		  
		  Dim v As Variant = value
		  
		  Return v.stringvalue
		End Function
	#tag EndEvent
	#tag Event
		Function ReformatDateTime(value as DateTime) As string
		  
		  
		  Dim v As Variant = value
		  
		  Return v.stringvalue
		End Function
	#tag EndEvent
	#tag Event
		Function ReformatDouble(value as double) As string
		  
		  
		  Dim v As Variant = value
		  
		  Return v.stringvalue
		End Function
	#tag EndEvent
	#tag Event
		Function ReformatInt32(value as int32) As string
		  
		  
		  Dim v As Variant = value
		  
		  Return v.stringvalue
		End Function
	#tag EndEvent
	#tag Event
		Function ReformatInt64(value as int64) As string
		  
		  
		  Dim v As Variant = value
		  
		  Return v.stringvalue
		End Function
	#tag EndEvent
	#tag Event
		Function ReformatNil(value as variant) As string
		  
		  
		  Dim v As Variant = value
		  
		  Return v.stringvalue
		End Function
	#tag EndEvent
	#tag Event
		Function ReformatSingle(value as Single) As string
		  
		  
		  Dim v As Variant = value
		  
		  Return v.stringvalue
		End Function
	#tag EndEvent
	#tag Event
		Function ReformatString(value as String) As string
		  
		  
		  Dim v As Variant = value
		  
		  Return v.stringvalue
		End Function
	#tag EndEvent
	#tag Event
		Function ReformatValue(value as Variant) As string
		  
		  
		  Dim v As Variant = value
		  
		  Return v.stringvalue
		End Function
	#tag EndEvent
	#tag Event
		Function Setup() As TextOutputStream
		  
		  Dim dlg As New SaveFileDialog
		  
		  Dim f As folderitem = dlg.ShowModal
		  
		  If f <> Nil Then
		    
		    Dim tos As TextOutputStream = TextOutputStream.Create( f )
		    
		    Return tos
		    
		  End If
		  
		End Function
	#tag EndEvent
#tag EndEvents
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
		Name="Interfaces"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
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
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=false
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="0"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&hFFFFFF"
		Type="Color"
		EditorType="Color"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="MenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
