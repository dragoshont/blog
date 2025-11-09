Param(
    [string]$TargetDir = "static/images",
    [int]$Colors = 32
)

if (!(Get-Command magick -ErrorAction SilentlyContinue)) {
    Write-Host "ImageMagick 'magick' CLI not found. Skipping image optimization." -ForegroundColor Yellow
    exit 0
}

$pngs = Get-ChildItem -Path $TargetDir -Filter *.png -Recurse
foreach ($p in $pngs) {
    $origSize = (Get-Item $p.FullName).Length
    $tempFile = [IO.Path]::GetTempFileName() + '.png'
    try {
        & magick convert "$($p.FullName)" -strip -depth 8 -dither FloydSteinberg -colors $Colors PNG8:"$tempFile"
        if (Test-Path $tempFile) {
            $newSize = (Get-Item $tempFile).Length
            if ($newSize -lt $origSize) {
                Move-Item $tempFile $p.FullName -Force
                Write-Host ("Optimized {0}: {1} -> {2} bytes ({3}% saved)" -f $p.Name, $origSize, $newSize, [math]::Round((1-($newSize/$origSize))*100,2)) -ForegroundColor Green
            } else {
                Remove-Item $tempFile -Force
                Write-Host ("Skipped {0}: optimization not smaller" -f $p.Name) -ForegroundColor DarkGray
            }
        }
    } catch {
        Write-Host ("Failed {0}: $_" -f $p.Name) -ForegroundColor Red
        if (Test-Path $tempFile) { Remove-Item $tempFile -Force }
    }
}
