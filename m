Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab0KRJju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:39:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:62012 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151Ab0KRJjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:39:47 -0500
Content-Type: multipart/mixed; boundary="===============1952494109=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,216,1288594800"; 
   d="p7s'?scan'208";a="858901922"
From: "Struk, Tadeusz" <tadeusz.struk@intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "O Mahony, Aidan" <aidan.o.mahony@intel.com>,
        "Paoloni, Gabriele" <gabriele.paoloni@intel.com>,
        "Hoban, Adrian" <adrian.hoban@intel.com>
Date: Thu, 18 Nov 2010 09:38:50 +0000
Subject: RE: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
Thread-Topic: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
Thread-Index: AcuHAr1rIasRO447Roqzo85ELxw8rwAAYEYw
Message-ID: <24483BA4C9F69C43A7379639D35543D7C3450A84@irsmsx502.ger.corp.intel.com>
References: <4CC9946D.mailLH511GU0C@intel.com>
 <20101104190405.GA2501@gondor.apana.org.au>
 <20101117172331.3bbec734.akpm@linux-foundation.org>
 <20101118092640.GA9486@gondor.apana.org.au>
In-Reply-To: <20101118092640.GA9486@gondor.apana.org.au>
Accept-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============1952494109==
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=SHA1; boundary="----=_NextPart_000_000A_01CB8704.68312020"

------=_NextPart_000_000A_01CB8704.68312020
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Will do.
Tadeusz

-----Original Message-----
From: Herbert Xu [mailto:herbert@gondor.apana.org.au] 
Sent: Thursday, November 18, 2010 9:27 AM
To: Andrew Morton
Cc: Struk, Tadeusz; linux-kernel@vger.kernel.org; linux-crypto@vger.kernel.org; O Mahony, Aidan; Paoloni, Gabriele; Hoban, Adrian
Subject: Re: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions

On Wed, Nov 17, 2010 at 05:23:31PM -0800, Andrew Morton wrote:
> On Thu, 4 Nov 2010 14:04:05 -0500
> Herbert Xu <herbert@gondor.hengli.com.au> wrote:
> 
> > On Thu, Oct 28, 2010 at 04:19:09PM +0100, tadeusz.struk@intel.com wrote:
> > > Hi Herbert,
> > >    We have reworked the assembly to use macros instead of the new aesni instructions.
> > 
> > Both applied.  Thanks for your efforts!
> 
> Whatever's in today's linux-next is a big fail with gas-2.16.1.
> 
> Which was entirely predictable!  How often has this happened recently??
> 
> 
> arch/x86/crypto/aesni-intel_asm.S: Assembler messages:
> arch/x86/crypto/aesni-intel_asm.S:834: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm13'
> arch/x86/crypto/aesni-intel_asm.S:866: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm5'
> arch/x86/crypto/aesni-intel_asm.S:866: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm0'
> arch/x86/crypto/aesni-intel_asm.S:866: Error: bad expression

Sorry, but I no longer have access to a binutils that is older
than 2.18 so I never saw this failure.

Tadeusz, could you please make an incremental patch that converts
all the pshufb instructions to macros?

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

------=_NextPart_000_000A_01CB8704.68312020
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIYITCCAyAw
ggKJoAMCAQICBDXe9M8wDQYJKoZIhvcNAQEFBQAwTjELMAkGA1UEBhMCVVMxEDAOBgNVBAoTB0Vx
dWlmYXgxLTArBgNVBAsTJEVxdWlmYXggU2VjdXJlIENlcnRpZmljYXRlIEF1dGhvcml0eTAeFw05
ODA4MjIxNjQxNTFaFw0xODA4MjIxNjQxNTFaME4xCzAJBgNVBAYTAlVTMRAwDgYDVQQKEwdFcXVp
ZmF4MS0wKwYDVQQLEyRFcXVpZmF4IFNlY3VyZSBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkwgZ8wDQYJ
KoZIhvcNAQEBBQADgY0AMIGJAoGBAMFdsVhnCGLuoJotHwhtkRRomAoe/toEbxOEYiHD0XzOnwXg
uAHwTjTs4oqVBGSs8WtTXwWzy2eAv0ICjv7dAQns4QAUT/z78AzdQ7pbK+EfgHCZFVeTFvEPl2q3
wmgjHMxNWTCsUR47ryvW7mNFe8XZX1DS41APOojnvxT94Me5AgMBAAGjggEJMIIBBTBwBgNVHR8E
aTBnMGWgY6BhpF8wXTELMAkGA1UEBhMCVVMxEDAOBgNVBAoTB0VxdWlmYXgxLTArBgNVBAsTJEVx
dWlmYXggU2VjdXJlIENlcnRpZmljYXRlIEF1dGhvcml0eTENMAsGA1UEAxMEQ1JMMTAaBgNVHRAE
EzARgQ8yMDE4MDgyMjE2NDE1MVowCwYDVR0PBAQDAgEGMB8GA1UdIwQYMBaAFEjmaPkr0rKV10fY
IyAQTzOYkJ/UMB0GA1UdDgQWBBRI5mj5K9KylddH2CMgEE8zmJCf1DAMBgNVHRMEBTADAQH/MBoG
CSqGSIb2fQdBAAQNMAsbBVYzLjBjAwIGwDANBgkqhkiG9w0BAQUFAAOBgQBYzinq/Pfetc4CuRe1
hdG54+CVzCUxDQCmkm5/tpJjnlCV0Zpv5BHeY4VumO6o/1rI01WyZnFX3sAh6z0qpyNJAQSGQnv8
7n+iFlK1Z2fTQNs7JliyKHc9rhR3Ydb6KmYnoA36p3Nc6nDxlCFlRF/6/O8paKmih3nvee9PrAd3
ODCCAz0wggKmoAMCAQICAwWw/zANBgkqhkiG9w0BAQUFADBOMQswCQYDVQQGEwJVUzEQMA4GA1UE
ChMHRXF1aWZheDEtMCsGA1UECxMkRXF1aWZheCBTZWN1cmUgQ2VydGlmaWNhdGUgQXV0aG9yaXR5
MB4XDTA2MDIxNjE4MDEzMFoXDTE2MDIxOTE4MDEzMFowUjELMAkGA1UEBhMCVVMxGjAYBgNVBAoT
EUludGVsIENvcnBvcmF0aW9uMScwJQYDVQQDEx5JbnRlbCBFeHRlcm5hbCBCYXNpYyBQb2xpY3kg
Q0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDBpd/XOb9QVqEZ8mQ1042TdOIq3ATD
IsV2xDyt30yLyMR5Wjtus0bn3B+he89BiNO/LP6+rFzEwlD55PlX+HLGIKeNNG97dqyc30FElEUj
ZzTZFq2N4e3kVJ/XAEEgANzV8v9qp7qWwxugPgfc3z9BkYot+CifozexHLb/hEZj+yISCU61kRZv
uSQ0E11yYL4dRgcglJeaHo3oX57rvIckaLsYV5/1Aj+R8DM1Ppk965XQAKsHfnyT7C4S50T4lVn4
lz36wOdNZn/zegG1zp41lnoTFfT4KuKVJH5x7YD1p6KbgJCKLovnujGuohquBNfdXKpZkvz6pGv+
iC1HawJdAgMBAAGjgaAwgZ0wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBQaxgxKxEdvqNutK/D0
Vgaj7TdUDDA6BgNVHR8EMzAxMC+gLaArhilodHRwOi8vY3JsLmdlb3RydXN0LmNvbS9jcmxzL3Nl
Y3VyZWNhLmNybDAfBgNVHSMEGDAWgBRI5mj5K9KylddH2CMgEE8zmJCf1DAPBgNVHRMBAf8EBTAD
AQH/MA0GCSqGSIb3DQEBBQUAA4GBABMQOK2kVKVIlUWwLTdywJ+e2O+PC/uQltK2F3lRyrPfBn69
tOkIP4SgDJOfsxyobIrPLe75kBLw+Dom13OBDp/EMZJZ1CglQfVV8co9mT3aZMjSGGQiMgkJLR3j
Mfr900fXZKj5XeqCJ+JP0mEhJGEdVCY+FFlksJjV86fDrq1QMIIFYzCCBEugAwIBAgIKYSyl/gAA
AAAABjANBgkqhkiG9w0BAQUFADBSMQswCQYDVQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9y
YXRpb24xJzAlBgNVBAMTHkludGVsIEV4dGVybmFsIEJhc2ljIFBvbGljeSBDQTAeFw0wNjAzMjIy
MjIyNDdaFw0xMjAzMjIyMjMyNDdaMFYxCzAJBgNVBAYTAlVTMRowGAYDVQQKExFJbnRlbCBDb3Jw
b3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwgQmFzaWMgSXNzdWluZyBDQSAzQjCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMDoHJYUGvcdR4k0Qv8/RrwNX4+vEe5PN2LnGn4x
fIWwdUbk5+zvrRy1HjoKdG/AShZfxAuFoVyNIah5GJLpiS/vGbsDYKK+EZcIcmtPfvbB9Yg09EnQ
0OpsZ2ORRd5lYUfMUU+zkpgL96vKFdkiG+eeHEwnSS3VikGVrF7UDdKfvxZwRwQCx6rEHAFPCjBD
VfGYZuYT1EDhSDvzEiU7KzBsxrdBCFU4RYL7kh+do+vyMDlBzpw3WKvMVbf3s5lxYiY7AjEhU8OS
yZEQlgtK8PNyifHjmyrSaeJrPshM3PuLFG4d3gm1UJEiGNzxcHGb6YLP29IQAwY5mAk8j+UOVcsC
AwEAAaOCAjUwggIxMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFG/DcREooZ0ZV/VnV8/ZKSaI
1aWiMAsGA1UdDwQEAwIBhjAQBgkrBgEEAYI3FQEEAwIBADAZBgkrBgEEAYI3FAIEDB4KAFMAdQBi
AEMAQTAfBgNVHSMEGDAWgBQaxgxKxEdvqNutK/D0Vgaj7TdUDDCBvQYDVR0fBIG1MIGyMIGvoIGs
oIGphk5odHRwOi8vd3d3LmludGVsLmNvbS9yZXBvc2l0b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFs
JTIwQmFzaWMlMjBQb2xpY3klMjBDQS5jcmyGV2h0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29t
L3JlcG9zaXRvcnkvQ1JML0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUyMENBLmNy
bDCB4wYIKwYBBQUHAQEEgdYwgdMwYwYIKwYBBQUHMAKGV2h0dHA6Ly93d3cuaW50ZWwuY29tL3Jl
cG9zaXRvcnkvY2VydGlmaWNhdGVzL0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUy
MENBLmNydDBsBggrBgEFBQcwAoZgaHR0cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVwb3Np
dG9yeS9jZXJ0aWZpY2F0ZXMvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwUG9saWN5JTIwQ0Eu
Y3J0MA0GCSqGSIb3DQEBBQUAA4IBAQBAiWWHL6T21QXFZDyaUIye0jh7f40GXqi75Ro5JbpROtlZ
BqyRq6oPMAG6Igxd5Bd9TMtNkOvguknFnK1y17UdMhLOl+FuInE+FAWk803aRW27OsX+ot0KmPio
KnZ3L1K5qcQS3tp6or7AaZzd0w0qFitm4UfP9nnTXQtY9XM5QJ07IKFDE3tlOlamKhjbiJV3FKig
CVesPZSx9h2G7Ve4irEfz915Vks26AJHGZagEHNxM9exkgem4ENsG+t0vYqn9x7YsqJ6fmbOSyrz
jzb3CYeEfyE5SL+f3Vx9uMsQDyb8LVCDBXQtxLEHnFEBPrRSSF9kPmyjavx4UqFdPEyCMIIGAzCC
BOugAwIBAgIKZw1HXAAAAAAjxTANBgkqhkiG9w0BAQUFADBWMQswCQYDVQQGEwJVUzEaMBgGA1UE
ChMRSW50ZWwgQ29ycG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2ljIElzc3Vp
bmcgQ0EgM0IwHhcNMDgwMTEwMTcyNzE4WhcNMTEwMTA5MTcyNzE4WjBBMRcwFQYDVQQDEw5TdHJ1
aywgVGFkZXVzejEmMCQGCSqGSIb3DQEJARYXdGFkZXVzei5zdHJ1a0BpbnRlbC5jb20wggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQClqSXlOFL/ggjqlQPgWQfbGoOT4yENVEwzZuvK4PeK
OXroeIoKcXFEoprX78QTrkYLDKB61GQk3NJSa2dTS4WAouEJvVEQu0s0E+Y4nTuaXz2SocnNZ/6j
CCOrzel1Ka5F97VDsbySdFsX352mupb7RWS2oFkLDV1uibKQRlBJcwlqDaEJ3lhUhmDMbF3QV6Ub
CJX+Gf43gGbS58QwUCXW2wvWBi/WYtr75OfvxJQt0+OyKz220C6DETxmICrehWb+JXKdQonW95uT
XoSV4dTX+rgVy/nm9QxV8BPU9HtGTE+x56ljiVFo1mXoq1p8NUN5ByAN9k8M4vb9D6u6V/s/AgMB
AAGjggLmMIIC4jALBgNVHQ8EBAMCB4AwHQYDVR0OBBYEFC0UqLUaXF/uJUZuopNj4kJ+HGrvMDwG
CSsGAQQBgjcVBwQvMC0GJSsGAQQBgjcVCIbDjHWEmeVRg/2BKIWOn1OCkcAJZ4HevTmV8EMCAWQC
AQUwHwYDVR0jBBgwFoAUb8NxESihnRlX9WdXz9kpJojVpaIwgckGA1UdHwSBwTCBvjCBu6CBuKCB
tYZUaHR0cDovL3d3dy5pbnRlbC5jb20vcmVwb3NpdG9yeS9DUkwvSW50ZWwlMjBFeHRlcm5hbCUy
MEJhc2ljJTIwSXNzdWluZyUyMENBJTIwM0IuY3Jshl1odHRwOi8vY2VydGlmaWNhdGVzLmludGVs
LmNvbS9yZXBvc2l0b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIw
Q0ElMjAzQi5jcmwwge8GCCsGAQUFBwEBBIHiMIHfMGkGCCsGAQUFBzAChl1odHRwOi8vd3d3Lmlu
dGVsLmNvbS9yZXBvc2l0b3J5L2NlcnRpZmljYXRlcy9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMl
MjBJc3N1aW5nJTIwQ0ElMjAzQi5jcnQwcgYIKwYBBQUHMAKGZmh0dHA6Ly9jZXJ0aWZpY2F0ZXMu
aW50ZWwuY29tL3JlcG9zaXRvcnkvY2VydGlmaWNhdGVzL0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNp
YyUyMElzc3VpbmclMjBDQSUyMDNCLmNydDAfBgNVHSUEGDAWBggrBgEFBQcDBAYKKwYBBAGCNwoD
DDApBgkrBgEEAYI3FQoEHDAaMAoGCCsGAQUFBwMEMAwGCisGAQQBgjcKAwwwSwYDVR0RBEQwQqAn
BgorBgEEAYI3FAIDoBkMF3RhZGV1c3ouc3RydWtAaW50ZWwuY29tgRd0YWRldXN6LnN0cnVrQGlu
dGVsLmNvbTANBgkqhkiG9w0BAQUFAAOCAQEAI92sQcvy3gnSPur4tntIcowUmIUXYCfLBz4kY/Ll
7hnXFWcWPUuocRfveYFGMc6dklCxkQTpJpZ5uTc39GBllWyGvbrC+CcMkDrzTeeSWIdW1qxmXlk1
5vySOVRyP8HmrhQbUIXZwqPx6CwlPu5FRHhxhNMbjWjPgTSHvGTBzcJ4BEHwBwlfb6rOww3v+FNx
UozHcoRpBz9Z1eD1GxjsdqokqTUw3jbEdh8r6U2lLrVIPs2KX5ggoKenHx/y+zEKgtOmHnx74Q17
LiCkMNhMomCmAxh6jAD+0gYkyyGNW4rBbjrd1x+yPNWXDkIveVIpG2+ItvvAOOcyu7Mk3CtrcTCC
BkowggUyoAMCAQICCmsY2okAAAAAI9YwDQYJKoZIhvcNAQEFBQAwVjELMAkGA1UEBhMCVVMxGjAY
BgNVBAoTEUludGVsIENvcnBvcmF0aW9uMSswKQYDVQQDEyJJbnRlbCBFeHRlcm5hbCBCYXNpYyBJ
c3N1aW5nIENBIDNCMB4XDTA4MDExMTEyMTgyMFoXDTExMDExMDEyMTgyMFowQTEXMBUGA1UEAxMO
U3RydWssIFRhZGV1c3oxJjAkBgkqhkiG9w0BCQEWF3RhZGV1c3ouc3RydWtAaW50ZWwuY29tMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnYPdO/c4AwR6kFsc+VmfTh3XklKcIqYwdAl/
g/gZP6QRAufJkBK90/g4Lx/hVwZQQ5itD7Hg1VnJ2GmMibZYeko6w47JX/xTNEl3Qb54xjjI3oG7
E8EQOt6chxIrQvrADY6HtS0e0GvR7KU8lVgpDzmmhtdGM3KfSAWPddKDHonY2nW8UNQRbxlHOVi5
/Buyg1/uZTvAU4j24EyluT92di7m3WfVuNGljAIJdvCvafgHuctaKw30zhLRKddT028bCyzH3rOE
45zV1f1xV6y1WfpvtB3OeD6SsmvWHnkhhTQb5ha3wlncmkFji6xgsbL0e4HHD7DKDGWLupQ/aJQJ
LQIDAQABo4IDLTCCAykwCwYDVR0PBAQDAgQwMEQGCSqGSIb3DQEJDwQ3MDUwDgYIKoZIhvcNAwIC
AgCAMA4GCCqGSIb3DQMEAgIAgDAHBgUrDgMCBzAKBggqhkiG9w0DBzAdBgNVHQ4EFgQUxFOVRH5a
3yrmo/bmsTy+YoXSZQIwPQYJKwYBBAGCNxUHBDAwLgYmKwYBBAGCNxUIhsOMdYSZ5VGD/YEohY6f
U4KRwAlnhLnZQYeE/04CAWQCAQkwHwYDVR0jBBgwFoAUb8NxESihnRlX9WdXz9kpJojVpaIwgckG
A1UdHwSBwTCBvjCBu6CBuKCBtYZUaHR0cDovL3d3dy5pbnRlbC5jb20vcmVwb3NpdG9yeS9DUkwv
SW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwM0IuY3Jshl1odHRwOi8v
Y2VydGlmaWNhdGVzLmludGVsLmNvbS9yZXBvc2l0b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFsJTIw
QmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjAzQi5jcmwwge8GCCsGAQUFBwEBBIHiMIHfMGkGCCsGAQUF
BzAChl1odHRwOi8vd3d3LmludGVsLmNvbS9yZXBvc2l0b3J5L2NlcnRpZmljYXRlcy9JbnRlbCUy
MEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjAzQi5jcnQwcgYIKwYBBQUHMAKGZmh0
dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3JlcG9zaXRvcnkvY2VydGlmaWNhdGVzL0ludGVs
JTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3VpbmclMjBDQSUyMDNCLmNydDAfBgNVHSUEGDAWBggr
BgEFBQcDBAYKKwYBBAGCNwoDBDApBgkrBgEEAYI3FQoEHDAaMAoGCCsGAQUFBwMEMAwGCisGAQQB
gjcKAwQwSwYDVR0RBEQwQqAnBgorBgEEAYI3FAIDoBkMF3RhZGV1c3ouc3RydWtAaW50ZWwuY29t
gRd0YWRldXN6LnN0cnVrQGludGVsLmNvbTANBgkqhkiG9w0BAQUFAAOCAQEArsRWL+cURG5dEUkU
dY8MLw2a7l2jDkqeoqandVwUdHxNTGz2mInJKZixCCCZKlDxnt/D11N+FNVFmK4FA6r3Eht2xZCZ
/uOXlsBkD4i2YbfZlcgRuvCbJMb8Hx3ioFrgszavij5/A+z0TwIAMY1lkJAZlTHjbfmAjPF43eiR
UWV9yoJecQi9Afcmei7E/zi77ob8Xi7HYZPcpQ2WKORCrTYwk+VphDwyDx12vdpaYVtUKpvzGdRw
5rT9Ma9N7EajhMbbCxFA3os83GHF1eLdQclsMbn1o3+J5KHr0rFaPcrFwEGhKsRgYr3Tgc9rU23r
9C+5RJzJWhAVS12PknyQaTGCA0EwggM9AgEBMGQwVjELMAkGA1UEBhMCVVMxGjAYBgNVBAoTEUlu
dGVsIENvcnBvcmF0aW9uMSswKQYDVQQDEyJJbnRlbCBFeHRlcm5hbCBCYXNpYyBJc3N1aW5nIENB
IDNCAgpnDUdcAAAAACPFMAkGBSsOAwIaBQCgggGyMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEw
HAYJKoZIhvcNAQkFMQ8XDTEwMTExODA5Mzg1MFowIwYJKoZIhvcNAQkEMRYEFEX9B1EaVGcmaDkD
z3aJy/O07e/xMGcGCSqGSIb3DQEJDzFaMFgwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0G
CCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMAcGBSsOAwIaMAoGCCqGSIb3DQIF
MHMGCSsGAQQBgjcQBDFmMGQwVjELMAkGA1UEBhMCVVMxGjAYBgNVBAoTEUludGVsIENvcnBvcmF0
aW9uMSswKQYDVQQDEyJJbnRlbCBFeHRlcm5hbCBCYXNpYyBJc3N1aW5nIENBIDNCAgprGNqJAAAA
ACPWMHUGCyqGSIb3DQEJEAILMWagZDBWMQswCQYDVQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29y
cG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2ljIElzc3VpbmcgQ0EgM0ICCmsY
2okAAAAAI9YwDQYJKoZIhvcNAQEBBQAEggEAGNHc+XPUkQohUVDcEAOH7dJcuUWxYrlZOa5Mmtrs
8wliMC/tVddRLBThvxlW717TsgrQyFovxqIxXE5FPFEcgnDhUbvB8Wfm1F3BMFQdYKGnoGgVLG3S
ejqe+XB/K2oM441nB5dGTaTGu9LjNrm/xNxWUaBfIho5p6AwXJCzevHdioS6XPMIdGBu6kVpaIVK
j0U1DqFqG9LTushvaPB8TWPHjTF1FRnziF4XHBIrbWdx5q0S2rRkr0mb1U3SP3HLc+mt4A1u/ysQ
jJN1X0mNYuhOp0VdGDD5WOCFuxE1pIrxJajuV8aSs2Clylj3Rs7sgtwOcXJrb7xJlRe0ZNN7gAAA
AAAAAA==

------=_NextPart_000_000A_01CB8704.68312020--
--===============1952494109==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

--------------------------------------------------------------
Intel Shannon Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263
Business address: Dromore House, East Park, Shannon, Co. Clare

This e-mail and any attachments may contain confidential material for the s=
ole use of the intended recipient(s). Any review or distribution by others =
is strictly prohibited. If you are not the intended recipient, please conta=
ct the sender and delete all copies.


--===============1952494109==--
