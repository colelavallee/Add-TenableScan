function New-TenableScan {
    $Date = Get-Date -UFormat "%b %d %Y_%H:%M"
    $Name = ([System.Net.Dns]::GetHostByName(($env:computerName))).Hostname
    $ReportName = "$($Name) - $($Date)"
    $ManagedCredsUUID = "<Managed Credentials UUID>"
    $FolderID = "<Folder ID>"
    $Scanner = "<Scanner ID>"
    $URI = "https://cloud.tenable.com/scans"
    $AccessKey = "<accesskey>"
    $SecretKey = "<secretkey>"
    $Headers = @{ }
    $Headers.Add("accept", "application/json")
    $Headers.Add("X-ApiKeys", "accessKey=$AccessKey;secretKey=$Secretkey")
    $UUID = "<uuid>"
    $ScanSettings = [ordered]@{
        uuid        = $UUID
        settings    = @{
            name         = $ReportName
            folder_id    = $FolderID
            scanner_id   = $Scanner
            text_targets = $Name
        }
        credentials = @{
            add = @{
                Host = @{
                    Windows = @(
                        @{
                            id = $ManagedCredsUUID
                        }
                    )
                }
            }
        }
    }
    $JSON = $ScanSettings | ConvertTo-Json -Depth 10
    $Response = Invoke-RestMethod -Uri $URI -Method Post -Headers $Headers -ContentType 'application/json' -Body $JSON

    return $Response
}

function Start-TenableScan {
    $CreateResponse = New-TenableScan

    $ScanUUID = "https://cloud.tenable.com/scans/$($CreationResponse.scan.uuid)/launch"

    $StartScanResponse = Invoke-RestMethod -Uri $ScanUUID -Method POST -Headers $headers
    { }