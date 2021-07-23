#tag Menu
Begin Menu MenuBar1
   Begin MenuItem UntitledMenu1
      SpecialMenu = 0
      Index = -2147483648
      Text = ""
      AutoEnabled = False
      AutoEnable = False
      Visible = True
   End
   Begin MenuItem FileMenu
      SpecialMenu = 0
      Index = -2147483648
      Text = "&File"
      AutoEnabled = False
      AutoEnable = False
      Visible = True
      Begin MenuItem FileNew
         SpecialMenu = 0
         Index = -2147483648
         Text = "New"
         AutoEnabled = True
         AutoEnable = True
         SubMenu = True
         Visible = True
         Begin MenuItem NewFileParser
            SpecialMenu = 0
            Index = -2147483648
            Text = "File Parser Window"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem NewStringParserWindow
            SpecialMenu = 0
            Index = -2147483648
            Text = "String Parser Window"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
         Begin MenuItem NewCSVWriterWindow
            SpecialMenu = 0
            Index = -2147483648
            Text = "CSV Writer Window"
            AutoEnabled = True
            AutoEnable = True
            Visible = True
         End
      End
      Begin MenuItem UntitledMenu5
         SpecialMenu = 0
         Index = -2147483648
         Text = "-"
         AutoEnabled = False
         AutoEnable = False
         Visible = True
      End
      Begin QuitMenuItem FileQuit
         SpecialMenu = 0
         Index = -2147483648
         Text = "Quit"
         ShortcutKey = "Q"
         Shortcut = "Cmd+Q"
         MenuModifier = True
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
   End
   Begin MenuItem EditMenu
      SpecialMenu = 0
      Index = -2147483648
      Text = "&Edit"
      AutoEnabled = False
      AutoEnable = False
      Visible = True
      Begin MenuItem EditUndo
         SpecialMenu = 0
         Index = -2147483648
         Text = "&Undo"
         ShortcutKey = "Z"
         Shortcut = "Cmd+Z"
         MenuModifier = True
         AutoEnabled = False
         AutoEnable = False
         Visible = True
      End
      Begin MenuItem UntitledMenu0
         SpecialMenu = 0
         Index = -2147483648
         Text = "-"
         AutoEnabled = False
         AutoEnable = False
         Visible = True
      End
      Begin MenuItem EditCut
         SpecialMenu = 0
         Index = -2147483648
         Text = "Cu&t"
         ShortcutKey = "X"
         Shortcut = "Cmd+X"
         MenuModifier = True
         AutoEnabled = False
         AutoEnable = False
         Visible = True
      End
      Begin MenuItem EditCopy
         SpecialMenu = 0
         Index = -2147483648
         Text = "&Copy"
         ShortcutKey = "C"
         Shortcut = "Cmd+C"
         MenuModifier = True
         AutoEnabled = False
         AutoEnable = False
         Visible = True
      End
      Begin MenuItem EditPaste
         SpecialMenu = 0
         Index = -2147483648
         Text = "&Paste"
         ShortcutKey = "V"
         Shortcut = "Cmd+V"
         MenuModifier = True
         AutoEnabled = False
         AutoEnable = False
         Visible = True
      End
      Begin MenuItem EditClear
         SpecialMenu = 0
         Index = -2147483648
         Text = "Clear"
         AutoEnabled = False
         AutoEnable = False
         Visible = True
      End
      Begin MenuItem UntitledMenu4
         SpecialMenu = 0
         Index = -2147483648
         Text = ""
         AutoEnabled = False
         AutoEnable = False
         Visible = True
      End
      Begin AppleMenuItem UntitledMenu3
         SpecialMenu = 0
         Index = -2147483648
         Text = ""
         AutoEnabled = False
         AutoEnable = False
         Visible = True
      End
   End
   Begin MenuItem UntitledMenu2
      SpecialMenu = 0
      Index = -2147483648
      Text = ""
      AutoEnabled = False
      AutoEnable = False
      Visible = True
   End
   Begin MenuItem Menu
      SpecialMenu = 0
      Index = -2147483648
      Text = ""
      AutoEnabled = True
      AutoEnable = True
      Visible = True
   End
End
#tag EndMenu
