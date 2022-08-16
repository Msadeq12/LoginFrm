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


# This is the function that searches for the user logged in
function Get-UserName{

    param(
        [string] $name
    )

    (get-wmiobject -Class Win32_computersystem -ComputerName $name -ErrorAction SilentlyContinue).UserName

}

# The function that performs the query
$submit_click = {
    
    $textBox2.Clear()
    
    $input = $textBox1.Text.Trim()

    
    
    Try{
        
        $result2 = Get-UserName -name $input

        $test = Test-Connection -ComputerName $input -Count 1 -Quiet

        if($result2 -eq $null){

            if($test -eq $null -or $test -eq ""){
                
                $textBox2.AppendText("Computer must be turned off. Please try again later.")
                $textBox2.ForeColor = "Red"
            }

            elseif($test -ne $null -or $test -ne ""){
                
                $textBox2.AppendText("No user logged in.")
                $textBox2.ForeColor = "Red"

            }
            
        }

        $textBox2.AppendText($result2)

        $textBox2.ForeColor = "Blue"

    }

    Catch [System.Net.NetworkInformation.PingException] {
    
        Write-Warning "Computer must be turned off. Please try again later."
    }

    Catch [System.Management.Automation.RemoteException]{
    
        Write-Warning "Connection error. Please make sure the end-device is turned on."
    }
    
    Catch [System.Management.Automation.MethodInvocationException]{
    
        Write-Warning "Connection error. Please make sure the end-device is turned on."
    }

    Catch {
        
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


[void] $form.ShowDialog()

}

