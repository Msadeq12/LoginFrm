#Author: Mohammad Sadeq Khandakar


#declarations
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#Form Design down below:


# form design parameters:
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Who logged in?'
$form.Size = New-Object System.Drawing.Size(600,600)
$form.StartPosition = 'CenterScreen'

# Run button parameters:
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(200,35)
$okButton.Size = New-Object System.Drawing.Size(75,40)
$okButton.Text = 'OK'


$okButton.Add_Click($submit_click)
$form.Controls.Add($okButton)


# clear button parameters:
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(300,35)
$cancelButton.Size = New-Object System.Drawing.Size(75,40)
$cancelButton.Text = 'Cancel'

$form.Controls.Add($cancelButton)

#label parameters:
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please enter device name:'
$form.Controls.Add($label)

$textBox1 = New-Object System.Windows.Forms.TextBox
$textBox1.Location = New-Object System.Drawing.Point(11,50)
$textBox1.Size = New-Object System.Drawing.Size(100,100)
$form.Controls.Add($textBox1)

$textBox2 = New-Object System.Windows.Forms.RichTextBox
$textBox2.Location = New-Object System.Drawing.Point(10,100)
$textBox2.Size = New-Object System.Drawing.Size(430,300)
$form.Controls.Add($textBox2)




function DeviceName{

    param (
        [string] $name
    )

    
    Try{
   
        query user console /server:$name
    }
   
    Catch [System.Management.Automation.RemoteException]{
        
        "Connection error. Please ensure the end-device is turned on."
    }
      
}


$submit_click = {
    
    $textBox2.Clear()
    
    $input = $textBox1.Text

    Try{
        $result = DeviceName -name $input
    }

    Catch [System.Management.Automation.RemoteException]{
        
        $result = "Connection error. Please ensure the end-device is turned on."
    }


    
    $textBox2.AppendText($result)
    $textBox2.Refresh()
}



$form.Topmost = $true

$form.Add_Shown({$form.Activate()})

[void] $form.ShowDialog()

