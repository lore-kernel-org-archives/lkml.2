Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab1EQMPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:15:06 -0400
Received: from powered.by.root24.eu ([91.121.20.142]:44601 "EHLO Root24.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710Ab1EQMPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:15:05 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 May 2011 08:15:04 EDT
Message-ID: <4DD2648C.6020309@ionic.de>
Date: Tue, 17 May 2011 14:05:32 +0200
From: Mihai Moldovan <ionic@ionic.de>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Kernel BUG with i915 in intel_sdvo_ddc_proxy_func
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080704090000060901010506"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms080704090000060901010506
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi,

I'm having trouble with an integrated i915 card, KMS and Linux >2.6.36.

The bug has been introduced somewhere between 2.6.36.1 (working) and=20
2.6.37 (bad) and is still happening on 2.6.38.6.

Kernel output (Images only, sorry):

http://ionic.de/gfx/Screenshots/Kernel/i915-BUG/Part1.jpg
http://ionic.de/gfx/Screenshots/Kernel/i915-BUG/Part2.jpg
http://ionic.de/gfx/Screenshots/Kernel/i915-BUG/Part3.jpg
http://ionic.de/gfx/Screenshots/Kernel/i915-BUG/Part4.jpg

lspci:

00:00.0 Host bridge: Intel Corporation 4 Series Chipset DRAM Controller=20
(rev 03)
         Subsystem: Intel Corporation Device 1003
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-=20
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort-=
=20
<TAbort- <MAbort+ >SERR- <PERR- INTx-
         Latency: 0
         Capabilities: [e0] Vendor Specific Information: Len=3D0c <?>
         Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation 4 Series Chipset=20
Integrated Graphics Controller (rev 03) (prog-if 00 [VGA controller])
         Subsystem: Intel Corporation Device 1003
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-=20
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort-=
=20
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 50
         Region 0: Memory at e0000000 (64-bit, non-prefetchable) [size=3D=
4M]
         Region 2: Memory at d0000000 (64-bit, prefetchable) [size=3D256M=
]
         Region 4: I/O ports at f220 [size=3D8]
         Expansion ROM at <unassigned> [disabled]
         Capabilities: [90] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
                 Address: fee0f00c  Data: 41c1
         Capabilities: [d0] Power Management version 2
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA=20
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PM=
E-

00:02.1 Display controller: Intel Corporation 4 Series Chipset=20
Integrated Graphics Controller (rev 03)
         Subsystem: Intel Corporation Device 1003
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-=20
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort-=
=20
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Region 0: Memory at e0400000 (64-bit, non-prefetchable) [size=3D=
1M]
         Capabilities: [d0] Power Management version 2
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA=20
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PM=
E-

PCI:IDs for those devices:
00:00.0 0600: 8086:2e10 (rev 03)
         Subsystem: 8086:1003

00:02.0 0300: 8086:2e12 (rev 03) (prog-if 00 [VGA controller])
         Subsystem: 8086:1003

00:02.1 0380: 8086:2e13 (rev 03)
         Subsystem: 8086:1003

It only happens when I enable CONFIG_DRM_I915_KMS.

Also, as of 2.6.37, the video=3D Kernel parameter doesn't have any effect=
=20
anymore (set to video=3D1280x1024-24@75). It's working fine on 2.6.36.1.

Do you need anything else? Feel free to request additional information.

I'm looking forward to hearing from you.

Best regards,


Mihai


--------------ms080704090000060901010506
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIT1DCC
BjQwggQcoAMCAQICASAwDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3
MTAyNDIxMDI1NVoXDTE3MTAyNDIxMDI1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWdu
aW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENs
aWVudCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMsohUWcASz7GfKrpTOM
KqANy9BV7V0igWdGxA8IU77L3aTxErQ+fcxtDYZ36Z6GH0YFn7fq5RADteP0AYzrCA+EQTfi
8q1+kA3m0nwtwXG94M5sIqsvs7lRP1aycBke/s5g9hJHryZ2acScnzczjBCAo7X1v5G3yw8M
DP2m2RCye0KfgZ4nODerZJVzhAlOD9YejvAXZqHksw56HzElVIoYSZ3q4+RJuPXXfIoyby+Y
2m1E+YzX5iCZXBx05gk6MKAW1vaw4/v2OOLy6FZH3XHHtOkzUreG//CsFnB9+uaYSlR65cdG
zTsmoIK8WH1ygoXhRBm98SD7Hf/r3FELNvUCAwEAAaOCAa0wggGpMA8GA1UdEwEB/wQFMAMB
Af8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBSuVYNv7DHKufcd+q9rMfPIHeOsuzAfBgNV
HSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRaMFgwJwYIKwYBBQUH
MAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYhaHR0cDovL3d3
dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20v
c2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93
d3cuc3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBADqp
Jw3I07QWke9plNBpxUxcffc7nUrIQpJHDci91DFG7fVhHRkMZ1J+BKg5UNUxIFJ2Z9B90Mic
c/NXcs7kPBRdn6XGO/vPc87Y6R+cWS9Nc9+fp3Enmsm94OxOwI9wn8qnr/6o3mD4noP9Jphw
UPTXwHovjavRnhUQHLfo/i2NG0XXgTHXS2Xm0kVUozXqpYpAdumMiB/vezj1QHQJDmUdPYMc
p+reg9901zkyT3fDW/ivJVv6pWtkh6Pw2ytZT7mvg7YhX3V50Nv860cV11mocUVcqBLv0gcT
+HBDYtbuvexNftwNQKD5193A7zN4vG7CTYkXxytSjKuXrpEatEiFPxWgb84nVj25SU5q/r1X
hwby6mLhkbaXslkVtwEWT3Van49rKjlK4XrUKYYWtnfzq6aSak5u0Vpxd1rY79tWhD3EdCvO
hNz/QplNa+VkIsrcp7+8ZhP1l1b2U6MaxIVteuVMD3X0vziIwr7jxYae9FZjbxlpUemqXjcC
0QaFfN7qI0JsQMALL7iGRBg7K0CoOBzECdD3fuZil5kU/LP9cr1BK31U0Uy651bFnAMMMkqh
AChIbn0ei72VnbpSsrrSdF0BAGYQ8vyHae5aCg+H75dVCV33K6FuxZrf09yTz+Vx/PkdRUYk
XmZz/OTfyJXsUOUXrym6KvI2rYpccSk5MIIGyjCCBbKgAwIBAgICBnIwDQYJKoZIhvcNAQEF
BQAwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJT
ZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBD
bGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQTAeFw0xMDAzMjMxNjI2NTZa
Fw0xMjAzMjQwNTQ2MjJaMIHHMSAwHgYDVQQNExcxNjg2MTctOUo5elVlMUVuNHg5b3ZiTzEL
MAkGA1UEBhMCREUxGzAZBgNVBAgTEkJhZGVuLVd1ZXJ0dGVtYmVyZzESMBAGA1UEBxMJS2Fy
bHNydWhlMS0wKwYDVQQLEyRTdGFydENvbSBWZXJpZmllZCBDZXJ0aWZpY2F0ZSBNZW1iZXIx
FzAVBgNVBAMTDk1paGFpIE1vbGRvdmFuMR0wGwYJKoZIhvcNAQkBFg5pb25pY0Bpb25pYy5k
ZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMssU6wPYwJJAxY07er/P6ANPXgz
yCczuA+7q/eql1St56r91yQ534A4oeXEqRZvpMsDuvczNG1Yz80nLpM+lO3Wg8csxaGReewe
RBIS3abf40HCIBVlOl7oTcmzZuzqz2KE70CHZ7p3k0WAEUfUb7AS8qrqxuoj0dtUkrdMwjoD
rPWs3zJ+vHo5FU3sTvj2ksiStjG3NMERBT+1Gzf2pVx2cKJRBmqACbKZfwE9QufRqrZT8bWY
i5DCV34RL7eVLnejLL+MvtarZv2K8Acojq9t7zO9Z+0rnlr6o46c2egVB+s/ol28q3DEce6f
p1KrCiujqRqQwVQ8O/2ogg4l5h0CAwEAAaOCAvcwggLzMAkGA1UdEwQCMAAwCwYDVR0PBAQD
AgSwMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQU3JbCyOa+BBzV
nBAKycZGQAzit2wwHwYDVR0jBBgwFoAUrlWDb+wxyrn3HfqvazHzyB3jrLswGQYDVR0RBBIw
EIEOaW9uaWNAaW9uaWMuZGUwggFCBgNVHSAEggE5MIIBNTCCATEGCysGAQQBgbU3AQIBMIIB
IDAuBggrBgEFBQcCARYiaHR0cDovL3d3dy5zdGFydHNzbC5jb20vcG9saWN5LnBkZjA0Bggr
BgEFBQcCARYoaHR0cDovL3d3dy5zdGFydHNzbC5jb20vaW50ZXJtZWRpYXRlLnBkZjCBtwYI
KwYBBQUHAgIwgaowFBYNU3RhcnRDb20gTHRkLjADAgEBGoGRTGltaXRlZCBMaWFiaWxpdHks
IHNlZSBzZWN0aW9uICpMZWdhbCBMaW1pdGF0aW9ucyogb2YgdGhlIFN0YXJ0Q29tIENlcnRp
ZmljYXRpb24gQXV0aG9yaXR5IFBvbGljeSBhdmFpbGFibGUgYXQgaHR0cDovL3d3dy5zdGFy
dHNzbC5jb20vcG9saWN5LnBkZjBjBgNVHR8EXDBaMCugKaAnhiVodHRwOi8vd3d3LnN0YXJ0
c3NsLmNvbS9jcnR1Mi1jcmwuY3JsMCugKaAnhiVodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9j
cnR1Mi1jcmwuY3JsMIGOBggrBgEFBQcBAQSBgTB/MDkGCCsGAQUFBzABhi1odHRwOi8vb2Nz
cC5zdGFydHNzbC5jb20vc3ViL2NsYXNzMi9jbGllbnQvY2EwQgYIKwYBBQUHMAKGNmh0dHA6
Ly93d3cuc3RhcnRzc2wuY29tL2NlcnRzL3N1Yi5jbGFzczIuY2xpZW50LmNhLmNydDAjBgNV
HRIEHDAahhhodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS8wDQYJKoZIhvcNAQEFBQADggEBACle
v1JwhVI4Pu8GzKRJzJdcYdsT7fJ9R5OzNnec4CADsb9Xu7HDyRa5qABBXihHvmo+fxGVe6Hy
8TxPvZYCGaeUi2t6aodIFOTQDWcdEP9o7SynBOXHqsN2lZ08Q4MBuoGfquJi0XjpCNnLY9KS
OZTHTwAIqGVH7lf99egY1Atfl+y/Lc0e6Sw/0qvcnaQSzwCZ/OkqVWSTGDZXwCDFuy6Cbwjy
Kn9qshZzeMqvSKHmHPihzJQ6eVXImZgrgWk5FrBpO8d59xoqO32PbSyM0cZhqvkbG/nlWPbz
Xn13+cgG7ajAGCg8XueMeh3m03sIIHinvgaeHOAqeO3TvVVv6WQwggbKMIIFsqADAgECAgIG
cjANBgkqhkiG9w0BAQUFADCBjDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0
ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2BgNV
BAMTL1N0YXJ0Q29tIENsYXNzIDIgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBMB4X
DTEwMDMyMzE2MjY1NloXDTEyMDMyNDA1NDYyMlowgccxIDAeBgNVBA0TFzE2ODYxNy05Sjl6
VWUxRW40eDlvdmJPMQswCQYDVQQGEwJERTEbMBkGA1UECBMSQmFkZW4tV3VlcnR0ZW1iZXJn
MRIwEAYDVQQHEwlLYXJsc3J1aGUxLTArBgNVBAsTJFN0YXJ0Q29tIFZlcmlmaWVkIENlcnRp
ZmljYXRlIE1lbWJlcjEXMBUGA1UEAxMOTWloYWkgTW9sZG92YW4xHTAbBgkqhkiG9w0BCQEW
DmlvbmljQGlvbmljLmRlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyyxTrA9j
AkkDFjTt6v8/oA09eDPIJzO4D7ur96qXVK3nqv3XJDnfgDih5cSpFm+kywO69zM0bVjPzScu
kz6U7daDxyzFoZF57B5EEhLdpt/jQcIgFWU6XuhNybNm7OrPYoTvQIdnuneTRYARR9RvsBLy
qurG6iPR21SSt0zCOgOs9azfMn68ejkVTexO+PaSyJK2Mbc0wREFP7UbN/alXHZwolEGaoAJ
spl/AT1C59GqtlPxtZiLkMJXfhEvt5Uud6Msv4y+1qtm/YrwByiOr23vM71n7SueWvqjjpzZ
6BUH6z+iXbyrcMRx7p+nUqsKK6OpGpDBVDw7/aiCDiXmHQIDAQABo4IC9zCCAvMwCQYDVR0T
BAIwADALBgNVHQ8EBAMCBLAwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMB0GA1Ud
DgQWBBTclsLI5r4EHNWcEArJxkZADOK3bDAfBgNVHSMEGDAWgBSuVYNv7DHKufcd+q9rMfPI
HeOsuzAZBgNVHREEEjAQgQ5pb25pY0Bpb25pYy5kZTCCAUIGA1UdIASCATkwggE1MIIBMQYL
KwYBBAGBtTcBAgEwggEgMC4GCCsGAQUFBwIBFiJodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9w
b2xpY3kucGRmMDQGCCsGAQUFBwIBFihodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9pbnRlcm1l
ZGlhdGUucGRmMIG3BggrBgEFBQcCAjCBqjAUFg1TdGFydENvbSBMdGQuMAMCAQEagZFMaW1p
dGVkIExpYWJpbGl0eSwgc2VlIHNlY3Rpb24gKkxlZ2FsIExpbWl0YXRpb25zKiBvZiB0aGUg
U3RhcnRDb20gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgUG9saWN5IGF2YWlsYWJsZSBhdCBo
dHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kucGRmMGMGA1UdHwRcMFowK6ApoCeGJWh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL2NydHUyLWNybC5jcmwwK6ApoCeGJWh0dHA6Ly9jcmwu
c3RhcnRzc2wuY29tL2NydHUyLWNybC5jcmwwgY4GCCsGAQUFBwEBBIGBMH8wOQYIKwYBBQUH
MAGGLWh0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9zdWIvY2xhc3MyL2NsaWVudC9jYTBCBggr
BgEFBQcwAoY2aHR0cDovL3d3dy5zdGFydHNzbC5jb20vY2VydHMvc3ViLmNsYXNzMi5jbGll
bnQuY2EuY3J0MCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cuc3RhcnRzc2wuY29tLzANBgkqhkiG
9w0BAQUFAAOCAQEAKV6/UnCFUjg+7wbMpEnMl1xh2xPt8n1Hk7M2d5zgIAOxv1e7scPJFrmo
AEFeKEe+aj5/EZV7ofLxPE+9lgIZp5SLa3pqh0gU5NANZx0Q/2jtLKcE5ceqw3aVnTxDgwG6
gZ+q4mLReOkI2ctj0pI5lMdPAAioZUfuV/316BjUC1+X7L8tzR7pLD/Sq9ydpBLPAJn86SpV
ZJMYNlfAIMW7LoJvCPIqf2qyFnN4yq9IoeYc+KHMlDp5VciZmCuBaTkWsGk7x3n3Gio7fY9t
LIzRxmGq+Rsb+eVY9vNefXf5yAbtqMAYKDxe54x6HebTewggeKe+Bp4c4Cp47dO9VW/pZDGC
A80wggPJAgEBMIGTMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjEr
MCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMv
U3RhcnRDb20gQ2xhc3MgMiBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0ECAgZyMAkG
BSsOAwIaBQCgggIOMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8X
DTExMDUxNzEyMDUzMlowIwYJKoZIhvcNAQkEMRYEFEOxM35czwkHxcz9GF+LrOL2oql6MF8G
CSqGSIb3DQEJDzFSMFAwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBpAYJKwYBBAGCNxAE
MYGWMIGTMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UE
CxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRD
b20gQ2xhc3MgMiBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0ECAgZyMIGmBgsqhkiG
9w0BCRACCzGBlqCBkzCBjDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4x
KzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2BgNVBAMT
L1N0YXJ0Q29tIENsYXNzIDIgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBAgIGcjAN
BgkqhkiG9w0BAQEFAASCAQC1984WVoynMymWBibVdNg8xMAVlDrkxGSIGIw6odOqmWUr2gOF
60AGCSjJX9G5duo5zp6G55d7w1HPT9Oe7zyL5kCL0Ck9RRN6PN4o9wm/1gJdnJAZrxHXilO1
GibZnKzy+GAXmsQawhu1yUerTXp7Z5du4Ywn1lKH13Tq58+aMZo6hIXf81u2GpXfEcbs6jt2
0ny8IETkzzHVP62rnIKLYwWwQLSCLvOs/S3KKqNfaQeDdYoTiAfml29JsYEiUexOxJiVeetZ
IIaVloEp+2NF2nLWyLo//YxgYbLwVLBuOEogeoHrJcdpUTUAQUluwRFmA4DzECpcH63NtGpf
ELkyAAAAAAAA
--------------ms080704090000060901010506--
