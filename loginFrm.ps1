#Author: Mohammad Sadeq Khandakar

#declarations
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework 

if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')){
    
    #Start-Process powershell -Verb RunAs -ArgumentList ".\loginFrm.ps1"
    Start-Process -filepath "powershell" -verb runas -ArgumentList "$PSScriptRoot\loginFrm.ps1" 
}

else{


#Form Design down below:


# form design parameters:
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Who logged in?'
$form.Size = New-Object System.Drawing.Size(480,350)
$form.StartPosition = 'CenterScreen'

# Run button parameters:
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(200,35)
$okButton.Size = New-Object System.Drawing.Size(75,40)
$okButton.Text = 'OK'


$okButton.Add_Click($submit_click)
$form.Controls.Add($okButton)


# clear button parameters:
$clearButton = New-Object System.Windows.Forms.Button
$clearButton.Location = New-Object System.Drawing.Point(300,35)
$clearButton.Size = New-Object System.Drawing.Size(75,40)
$clearButton.Text = 'Clear'

$form.Controls.Add($clearButton)

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
$textBox2.Size = New-Object System.Drawing.Size(430,75)
$form.Controls.Add($textBox2)
$textBox2.Enabled = $false

$textBox3 = New-Object System.Windows.Forms.TextBox
$textBox3.Location = New-Object System.Drawing.Point(11,200)
$textBox3.Size = New-Object System.Drawing.Size(160,100)
$form.Controls.Add($textBox3)
$textBox3.Enabled = $false


# This is the function that searches for the user logged in
function DeviceName{

    param (
        [string] $name
    )
     
    #(get-ciminstance -Class cim_computersystem -ComputerName $name).UserName
    query user console /server:$name
  
}

function Get-UserName{

    param(
        [string] $name
    )

    (get-wmiobject -Class Win32_computersystem -ComputerName $name).UserName

}

# The function that performs the query
$submit_click = {
    
    $textBox2.Clear()
    $textBox3.Clear()
    
    $input = $textBox1.Text.Trim()
    
    Try{
        
        $result1 = DeviceName -name $input
        $result2 = Get-UserName -name $input

        if($result1 -eq $null -or $result2 -eq $null){

            [System.Windows.MessageBox]::Show("Connection error. Please make sure the end-device is turned on.")
            
        }

        $textBox2.AppendText($result1)

        $textBox3.AppendText($result2)

    }

    Catch [System.Management.Automation.RemoteException]{

        Write-Warning "Connection error. Please make sure the end-device is turned on."
    }

    Catch [System.Management.Automation.MethodInvocationException]{

        Write-Warning "Connection error. Please make sure the end-device is turned on."
    }

    Catch{
        
        Write-Warning "Something went wrong. Please check your settings."
    }
    
}

# This function clears out the input box.
$clear_click = {
    
    $textBox1.Text = ""

}


$form.Topmost = $true

$form.Add_Shown({$form.Activate()})
$form.Add_Shown{($okButton.Add_Click($submit_click))}
$form.Add_Shown{($clearButton.Add_Click($clear_click))}
$form.Add_Shown{([System.Windows.MessageBox].Show("Connection error. Please make sure the end-device is turned on."))}

[void] $form.ShowDialog()

}