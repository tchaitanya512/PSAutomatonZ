


function Call-Compare_pff {

	#----------------------------------------------
	#region Import the Assemblies
	#----------------------------------------------
	[void][reflection.assembly]::Load("mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
	[void][reflection.assembly]::Load("System.Xml, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("System.DirectoryServices, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
	[void][reflection.assembly]::Load("System.Core, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("System.ServiceProcess, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
	#endregion Import Assemblies

	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	[System.Windows.Forms.Application]::EnableVisualStyles()
	$formCompare = New-Object 'System.Windows.Forms.Form'
	$buttonClose = New-Object 'System.Windows.Forms.Button'
	$labelOutput3count = New-Object 'System.Windows.Forms.Label'
	$labelOutput2count = New-Object 'System.Windows.Forms.Label'
	$labelOutput1count = New-Object 'System.Windows.Forms.Label'
	$labelInput2Count = New-Object 'System.Windows.Forms.Label'
	$labelInputContains = New-Object 'System.Windows.Forms.Label'
	$labelCommonValuesInBothIn = New-Object 'System.Windows.Forms.Label'
	$txtOutput3 = New-Object 'System.Windows.Forms.RichTextBox'
	$labelInput2DataWhichIsNot = New-Object 'System.Windows.Forms.Label'
	$txtOutput2 = New-Object 'System.Windows.Forms.RichTextBox'
	$buttonCompare = New-Object 'System.Windows.Forms.Button'
	$labelInput1DataWhichIsNot = New-Object 'System.Windows.Forms.Label'
	$labelInput2 = New-Object 'System.Windows.Forms.Label'
	$labelInput1 = New-Object 'System.Windows.Forms.Label'
	$txtobjoutput = New-Object 'System.Windows.Forms.RichTextBox'
	$txtobj2 = New-Object 'System.Windows.Forms.RichTextBox'
	$txtObj1 = New-Object 'System.Windows.Forms.RichTextBox'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	
	$formCompare_Load={
		#TODO: Initialize Form Controls here
		
		$buttonCompare.Enabled=$true;
		
		$labelInputContains.Visible=$false
		$labelInput2Count.Visible=$false;
	
		$global:count=0;
		$global:count2=0;
		$lines1=0;
		$lines2=0;
		$lines3=0;
		
		$labelOutput1count.Visible=$false;
		$labelOutput2count.Visible=$false;
		$labelOutput3count.Visible=$false;
	}
	
	$buttonCompare_Click={
		#TODO: Place custom script here
		
		
		
			   [array]$Input1 = $txtObj1.Text.Split("`n") | % { $_.trim() }
	
				$FinalInput1 = $Input1 | ? { $_ }
	
			
			   [array]$Input2 = $txtObj2.Text.Split("`n") | % { $_.trim() }
	
				$FinalInput2 = $Input2 | ? { $_ }
		
		
			[array]$CompareObj1 = Compare-Object -ReferenceObject $FinalInput1 -DifferenceObject $FinalInput2 -PassThru |  Where-Object { $_.SideIndicator -eq '=>' }
		
			[array]$CompareObj2 = Compare-Object -ReferenceObject $FinalInput1 -DifferenceObject $FinalInput2 -PassThru |  Where-Object { $_.SideIndicator -eq '<=' }
		
		    [array]$CompareObj3 = Compare-Object -ReferenceObject $FinalInput1 -DifferenceObject $FinalInput2 -IncludeEqual -PassThru |  Where-Object { $_.SideIndicator -eq '==' }
		   
		
		if ($CompareObj2.count -ge 1 )
				{
	
				$txtobjoutput.Text="$CompareObj2 `n"
				$txtobjoutput.Refresh();
			 
			    $lines1= $CompareObj2.count
			
	            $labelOutput1count.Text="Element Count : $lines1"
			$labelOutput1count.Refresh();
			
				$labelOutput1count.Visible=$true;
		
				}
		else
		{        $txtobjoutput.Text=$null
			      $txtobjoutput.Refresh();
			      $labelOutput1count.Text="Element Count :0"
			
				  $labelOutput1count.Visible=$true;
			
		}
		
		
		    
		if ($CompareObj1.count -ge 1 )
				{
	
	
	
				$txtOutput2.Text="$CompareObj1 `n"
				$txtOutput2.Refresh();
	            $lines2=$CompareObj1.count
			    $labelOutput2count.Text="Element Count : $lines2 "
			    $labelOutput2count.Refresh();
			    $labelOutput2count.Visible=$true;
		
				}
		
		else
		{
			
			       $txtOutput2.Text=$null
			      $txtOutput2.Refresh();
	
			      $labelOutput2count.Text="Element Count :0"
			
				  $labelOutput2count.Visible=$true;
			
		}
			    
		if ($CompareObj3.count -ge 1 )
				{
	
	
	
				$txtOutput3.Text="$CompareObj3 `n"
			$txtOutput3.Refresh();
			    $lines3= $CompareObj3.count
	            $labelOutput3count.Text="Element Count : $lines3"
			$labelOutput3count.Refresh();
			    $labelOutput3count.Visible=$true;
	
				}
	
	else
		{
				
				     $txtOutput3.Text=$null
			      $txtOutput3.Refresh();
			      $labelOutput3count.Text="Element Count :0"
				  $labelOutput3count.Visible=$true;
			
		}
				
	}
	
	  
	
	function setCompareButtonEnable  {
		if ($count -ge 1 -and $count2 -ge 1 )
		{
		$buttonCompare.Enabled=$true	
			
		}
		
		else
		{
			
			$buttonCompare.Enabled=$true	
		}
		
		
			
		
		
	}
	
	$txtObj1_PreviewKeyDown=[System.Windows.Forms.PreviewKeyDownEventHandler]{
	#Event Argument: $_ = [System.Windows.Forms.PreviewKeyDownEventArgs]
		#TODO: Place custom script here
		
		if($_.KeyCode -eq 'Enter' -or (($_.Control -eq $true) -and ($_.KeyCode -eq 'V')))
		{
			$count= $txtObj1.Lines.Length;
			
			$labelInputContains.Text ="Input-1 Contains $count Items";
			$labelInputContains.Visible=$true;
			setCompareButtonEnable
			
		}
	
		
	}
	
	$txtobj2_PreviewKeyDown=[System.Windows.Forms.PreviewKeyDownEventHandler]{
	#Event Argument: $_ = [System.Windows.Forms.PreviewKeyDownEventArgs]
		#TODO: Place custom script here
		
		if($_.KeyCode -eq 'Enter' -or (($_.Control -eq $true) -and ($_.KeyCode -eq 'V')))
		{
					
			$count2= $txtObj2.Lines.Length
			$labelInput2Count.Text ="Input-2 Contains $count2 Items";
			$labelInput2Count.Visible=$true;
			
			setCompareButtonEnable
		
			
			
		}
	
		
	}
	
	$txtObj1_KeyUp=[System.Windows.Forms.KeyEventHandler]{
	#Event Argument: $_ = [System.Windows.Forms.KeyEventArgs]
		#TODO: Place custom script here
		
		
				$count= $txtObj1.Lines.Length
		
			$labelInputContains.Text ="Input-1 Contains $count Items";
			$labelInputContains.Visible=$true;
			
		setCompareButtonEnable
	}
	
	
	$txtobj2_KeyUp=[System.Windows.Forms.KeyEventHandler]{
	#Event Argument: $_ = [System.Windows.Forms.KeyEventArgs]
		#TODO: Place custom script here
		
				$count2= $txtObj2.Lines.Length
		
			$labelInput2Count.Text ="Input-2 Contains $count2 Items";
			$labelInput2Count.Visible=$true;
		
		setCompareButtonEnable
	}
	
	
	$buttonClose_Click={
		#TODO: Place custom script here
		$formCompare.Close();
	}
		# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$formCompare.WindowState = $InitialFormWindowState
	}
	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$buttonClose.remove_Click($buttonClose_Click)
			$buttonCompare.remove_Click($buttonCompare_Click)
			$txtobj2.remove_KeyUp($txtobj2_KeyUp)
			$txtobj2.remove_PreviewKeyDown($txtobj2_PreviewKeyDown)
			$txtObj1.remove_KeyUp($txtObj1_KeyUp)
			$txtObj1.remove_PreviewKeyDown($txtObj1_PreviewKeyDown)
			$formCompare.remove_Load($formCompare_Load)
			$formCompare.remove_Load($Form_StateCorrection_Load)
			$formCompare.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch [Exception]
		{ }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	#
	# formCompare
	#
	$formCompare.Controls.Add($buttonClose)
	$formCompare.Controls.Add($labelOutput3count)
	$formCompare.Controls.Add($labelOutput2count)
	$formCompare.Controls.Add($labelOutput1count)
	$formCompare.Controls.Add($labelInput2Count)
	$formCompare.Controls.Add($labelInputContains)
	$formCompare.Controls.Add($labelCommonValuesInBothIn)
	$formCompare.Controls.Add($txtOutput3)
	$formCompare.Controls.Add($labelInput2DataWhichIsNot)
	$formCompare.Controls.Add($txtOutput2)
	$formCompare.Controls.Add($buttonCompare)
	$formCompare.Controls.Add($labelInput1DataWhichIsNot)
	$formCompare.Controls.Add($labelInput2)
	$formCompare.Controls.Add($labelInput1)
	$formCompare.Controls.Add($txtobjoutput)
	$formCompare.Controls.Add($txtobj2)
	$formCompare.Controls.Add($txtObj1)
	$formCompare.AutoScroll = $True
	$formCompare.AutoSize = $True
	$formCompare.ClientSize = '1057, 572'
	$formCompare.Name = "formCompare"
	$formCompare.Text = "Compare"
	$formCompare.add_Load($formCompare_Load)
	#
	# buttonClose
	#
	$buttonClose.Location = '420, 288'
	$buttonClose.Name = "buttonClose"
	$buttonClose.Size = '75, 23'
	$buttonClose.TabIndex = 16
	$buttonClose.Text = "Close"
	$buttonClose.UseVisualStyleBackColor = $True
	$buttonClose.add_Click($buttonClose_Click)
	#
	# labelOutput3count
	#
	$labelOutput3count.Location = '894, 497'
	$labelOutput3count.Name = "labelOutput3count"
	$labelOutput3count.Size = '125, 23'
	$labelOutput3count.TabIndex = 15
	$labelOutput3count.Text = "output3count"
	#
	# labelOutput2count
	#
	$labelOutput2count.Location = '709, 497'
	$labelOutput2count.Name = "labelOutput2count"
	$labelOutput2count.Size = '100, 23'
	$labelOutput2count.TabIndex = 14
	$labelOutput2count.Text = "output2count"
	#
	# labelOutput1count
	#
	$labelOutput1count.Location = '539, 497'
	$labelOutput1count.Name = "labelOutput1count"
	$labelOutput1count.Size = '100, 23'
	$labelOutput1count.TabIndex = 13
	$labelOutput1count.Text = "output1count"
	#
	# labelInput2Count
	#
	$labelInput2Count.Location = '261, 497'
	$labelInput2Count.Name = "labelInput2Count"
	$labelInput2Count.Size = '100, 23'
	$labelInput2Count.TabIndex = 12
	$labelInput2Count.Text = "Input 2 count"
	#
	# labelInputContains
	#
	$labelInputContains.Location = '85, 497'
	$labelInputContains.Name = "labelInputContains"
	$labelInputContains.Size = '100, 23'
	$labelInputContains.TabIndex = 11
	$labelInputContains.Text = "Input Contains "
	#
	# labelCommonValuesInBothIn
	#
	$labelCommonValuesInBothIn.Location = '914, 9'
	$labelCommonValuesInBothIn.Name = "labelCommonValuesInBothIn"
	$labelCommonValuesInBothIn.Size = '105, 35'
	$labelCommonValuesInBothIn.TabIndex = 10
	$labelCommonValuesInBothIn.Text = "Common Values in Both Inputs"
	#
	# txtOutput3
	#
	$txtOutput3.Location = '894, 47'
	$txtOutput3.Name = "txtOutput3"
	$txtOutput3.Size = '125, 413'
	$txtOutput3.TabIndex = 9
	$txtOutput3.Text = ""
	#
	# labelInput2DataWhichIsNot
	#
	$labelInput2DataWhichIsNot.Location = '683, 9'
	$labelInput2DataWhichIsNot.Name = "labelInput2DataWhichIsNot"
	$labelInput2DataWhichIsNot.Size = '183, 23'
	$labelInput2DataWhichIsNot.TabIndex = 8
	$labelInput2DataWhichIsNot.Text = "Input-2 Data which is not in Input-1"
	#
	# txtOutput2
	#
	$txtOutput2.Location = '709, 47'
	$txtOutput2.Name = "txtOutput2"
	$txtOutput2.ScrollBars = 'Vertical'
	$txtOutput2.Size = '124, 413'
	$txtOutput2.TabIndex = 7
	$txtOutput2.Text = ""
	#
	# buttonCompare
	#
	$buttonCompare.Location = '420, 248'
	$buttonCompare.Name = "buttonCompare"
	$buttonCompare.Size = '75, 23'
	$buttonCompare.TabIndex = 6
	$buttonCompare.Text = "Compare"
	$buttonCompare.UseVisualStyleBackColor = $True
	$buttonCompare.add_Click($buttonCompare_Click)
	#
	# labelInput1DataWhichIsNot
	#
	$labelInput1DataWhichIsNot.Location = '460, 9'
	$labelInput1DataWhichIsNot.Name = "labelInput1DataWhichIsNot"
	$labelInput1DataWhichIsNot.Size = '185, 23'
	$labelInput1DataWhichIsNot.TabIndex = 5
	$labelInput1DataWhichIsNot.Text = "Input-1 Data which is not in Input-2"
	#
	# labelInput2
	#
	$labelInput2.Location = '279, 9'
	$labelInput2.Name = "labelInput2"
	$labelInput2.Size = '100, 23'
	$labelInput2.TabIndex = 4
	$labelInput2.Text = "Input-2"
	#
	# labelInput1
	#
	$labelInput1.Location = '70, 9'
	$labelInput1.Name = "labelInput1"
	$labelInput1.Size = '100, 23'
	$labelInput1.TabIndex = 3
	$labelInput1.Text = "Input-1"
	#
	# txtobjoutput
	#
	$txtobjoutput.Location = '521, 47'
	$txtobjoutput.Name = "txtobjoutput"
	$txtobjoutput.ScrollBars = 'Vertical'
	$txtobjoutput.Size = '112, 413'
	$txtobjoutput.TabIndex = 2
	$txtobjoutput.Text = ""
	#
	# txtobj2
	#
	$txtobj2.Location = '276, 39'
	$txtobj2.Name = "txtobj2"
	$txtobj2.ScrollBars = 'Vertical'
	$txtobj2.Size = '103, 413'
	$txtobj2.TabIndex = 1
	$txtobj2.Text = ""
	$txtobj2.add_KeyUp($txtobj2_KeyUp)
	$txtobj2.add_PreviewKeyDown($txtobj2_PreviewKeyDown)
	#
	# txtObj1
	#
	$txtObj1.Location = '59, 39'
	$txtObj1.Name = "txtObj1"
	$txtObj1.ScrollBars = 'Vertical'
	$txtObj1.Size = '125, 413'
	$txtObj1.TabIndex = 0
	$txtObj1.Text = ""
	$txtObj1.add_KeyUp($txtObj1_KeyUp)
	$txtObj1.add_PreviewKeyDown($txtObj1_PreviewKeyDown)
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $formCompare.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$formCompare.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$formCompare.add_FormClosed($Form_Cleanup_FormClosed)
	#Show the Form
	return $formCompare.ShowDialog()

} #End Function

#Call the form
Call-Compare_pff | Out-Null
