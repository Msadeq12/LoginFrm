#Author: Mohammad Sadeq Khandakar


#declarations
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#Form Design down below:


# form design parameters:
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Who logged in?'
$form.Size = New-Object System.Drawing.Size(400,300)
$form.StartPosition = 'CenterScreen'

# Run button parameters:
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(200,35)
$okButton.Size = New-Object System.Drawing.Size(75,40)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK

$okButton.Add_Click($submit_click)
$form.Controls.Add($okButton)


# clear button parameters:
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(300,35)
$cancelButton.Size = New-Object System.Drawing.Size(75,40)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

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
$textBox2.Size = New-Object System.Drawing.Size(350,135)
$form.Controls.Add($textBox2)

$form.Topmost = $true

$form.Add_Shown({$form.Activate()})

[void] $form.ShowDialog()


$submit_click = {
    $input = $textBox1.Text.Trim()
    $output = $textBox2.Text

    query user console /server:$input
}




