$qqPath = "E:\QQNT\QQ.exe"

function Start-QQ {
    Start-Process $qqPath
}

function Kill-CrashpadHandler {
    Get-Process -Name "crashpad_handler" -ErrorAction SilentlyContinue | ForEach-Object { $_.Kill() }
}

while ($true) {
    $qqProcess = Get-Process -Name "QQ" -ErrorAction SilentlyContinue
    if (-not $qqProcess) {
        Write-Host "Process died, restarting QQ..."
        Start-QQ
    }

    $crashpadProcess = Get-Process -Name "crashpad_handler" -ErrorAction SilentlyContinue
    if ($crashpadProcess) {
        Write-Host "Find crashpad_handler, killing..."
        Kill-CrashpadHandler
    }

    if ($Host.UI.RawUI.KeyAvailable) {
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        if ($key.Character -eq 'r') {
            Write-Host "Command received, restarting QQ..."
            Get-Process -Name "QQ" -ErrorAction SilentlyContinue | ForEach-Object { $_.Kill() }
            Start-QQ
        }
    }

    Start-Sleep -Seconds 15
}
