Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab0L1Ksi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 05:48:38 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41380 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752719Ab0L1Ksg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 05:48:36 -0500
X-Sasl-enc: EcCfuAqKev3shtY7IIgG404IdgpyWGrrQPnWWCeh69w4 1293533315
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: keyrings@linux-nfs.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
        dhowells@redhat.com, jmorris@namei.org, safford@watson.ibm.com,
        ramunno@polito.it, tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH v2 0/6] eCryptfs: added support for the encrypted key type
Date: Tue, 28 Dec 2010 11:48:10 +0100
Message-Id: <1293533302-22868-1-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----CE58403B3E7E2514B1A662BC83190689"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is an S/MIME signed message

------CE58403B3E7E2514B1A662BC83190689
Content-Type: text/plain

This patch set adds support for the 'encrypted' key type in the eCryptfs
filesystem.

Changelog from version v1:
- added title and fixed text formatting in Documentation/keys-ecryptfs.txt;
- using isxdigit() in the function valid_ecryptfs_desc().

Roberto Sassu


Roberto Sassu (6):
  encrypted-keys: fixed valid_master_desc() function description
  encrypted-keys: added additional debug messages
  encrypted-keys: add key format support
  eCryptfs: export global eCryptfs definitions to
    include/linux/ecryptfs.h
  encrypted-keys: add ecryptfs format support
  eCryptfs: added support for the encrypted key type

 Documentation/keys-ecryptfs.txt          |   68 +++++++++
 Documentation/keys-trusted-encrypted.txt |   52 ++++---
 fs/ecryptfs/ecryptfs_kernel.h            |  120 ++--------------
 fs/ecryptfs/keystore.c                   |   15 ++-
 include/keys/encrypted-type.h            |   13 ++-
 include/linux/ecryptfs.h                 |  113 ++++++++++++++
 security/keys/Makefile                   |    2 +-
 security/keys/encrypted_defined.c        |  242 ++++++++++++++++++++++++------
 security/keys/keys_ecryptfs.c            |   81 ++++++++++
 security/keys/keys_ecryptfs.h            |   30 ++++
 10 files changed, 551 insertions(+), 185 deletions(-)
 create mode 100644 Documentation/keys-ecryptfs.txt
 create mode 100644 include/linux/ecryptfs.h
 create mode 100644 security/keys/keys_ecryptfs.c
 create mode 100644 security/keys/keys_ecryptfs.h

-- 
1.7.2.3


------CE58403B3E7E2514B1A662BC83190689
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIIICQYJKoZIhvcNAQcCoIIH+jCCB/YCAQExCzAJBgUrDgMCGgUAMAsGCSqGSIb3
DQEHAaCCBWQwggVgMIIESKADAgECAgICuzANBgkqhkiG9w0BAQUFADBlMQswCQYD
VQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMTYwNAYDVQQD
Ey1Qb2xpdGVjbmljbyBkaSBUb3Jpbm8gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkw
HhcNMTAxMjIwMTExOTU0WhcNMTUxMjMxMjM1OTU5WjBfMQswCQYDVQQGEwJJVDEe
MBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMRcwFQYDVQQDEw5Sb2JlcnRv
ICBTYXNzdTEXMBUGCgmSJomT8ixkAQETB2QwMjEzMDUwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDS6p4SaJdmmJHJu9On9ZohhBFE2GgYiY7YtRnhhQJA
NfOtHEhSbpUMaSOfq/Pna6ipR5nAFrlM8cOGcSHZdxrPcgzeJU7F2v1fl2ThvFOc
TIkcC1aAJGQUuCaCXDlQt+KFecJWTrRZnalMHZueO+J6cgHcvR1CQz5e88dSzo3Q
XZy0w/hxGL9Ht9velqsl48ohBk2rs/svAOCp6GfqT1Yxwx1p87d3ViTrmuZB4/X+
da39nJqmo6AZ/y3Zg+r91BgNcfsHVqFT0JTcG6qRIaeqTtqVYpYl+rH1rZzYCakD
yQyys66sBvaXyaiMr0M+SpyH+LaGz5bDn5Odq16FYEq7AgMBAAGjggIeMIICGjAO
BgNVHQ8BAf8EBAMCA/gwJwYDVR0lBCAwHgYIKwYBBQUHAwIGCCsGAQUFBwMDBggr
BgEFBQcDBDAiBgNVHREEGzAZgRdyb2JlcnRvLnNhc3N1QHBvbGl0by5pdDAMBgNV
HRMBAf8EAjAAMB0GA1UdDgQWBBQgKbXSXn+j769x0tsZQ9pSOzIIdDAfBgNVHSME
GDAWgBTNm1tbnup2IcQQaOjSLTfbHy/I5DCBywYDVR0gBIHDMIHAMD4GCisGAQQB
qQcBAQIwMDAuBggrBgEFBQcCARYiaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9j
cHMvMS4yLzBEBgorBgEEAakHAgECMDYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cu
aXRhbHkuZXVyb3BraS5vcmcvY2EvY3BzLzEuMi8wOAYKKwYBBAGVYgECAjAqMCgG
CCsGAQUFBwIBFhxodHRwOi8vY2EucG9saXRvLml0L2Nwcy8yLjIvMGYGCCsGAQUF
BwEBBFowWDAhBggrBgEFBQcwAYYVaHR0cDovL29jc3AucG9saXRvLml0MDMGCCsG
AQUFBzAChidodHRwOi8vY2EucG9saXRvLml0L2NlcnRzL3BvbGl0b19jYS5jZXIw
NwYDVR0fBDAwLjAsoCqgKIYmaHR0cDovL2NhLnBvbGl0by5pdC9jcmwvcG9saXRv
X2NybC5jcmwwDQYJKoZIhvcNAQEFBQADggEBADMe0aHcBJXV6pMJPVVSt1Vazd8Y
LuTLO45Igs9Sb2LuaO6pvcDGvq9dEJnBhP1B+zBAK6WEA1PWb66xC4QXaJnlGZTX
S3XeBivHWm6BNOH2kNeU0HBeGZCV/n5r70TPxkEAcc7u8YY2i6CiMM428YhZK8Zj
oN9D3QNIRf4HZgh0FTbf8eL/XvBbK/oPC+Rew+Qql6M3DHnaS1q2SKUwwO/4VXA4
JsOdatFI68AMXH0Xx9UIcjRi+kvsyvwHlc0Z8AoAtfRMoIl4zFF4Qaowec2UunBK
YlqPpFTtU9czuoEP12A86nqSVsoNok2mZOeYa9IdIjeE2rfdKx6k3YNRg08xggJt
MIICaQIBATBrMGUxCzAJBgNVBAYTAklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBk
aSBUb3Jpbm8xNjA0BgNVBAMTLVBvbGl0ZWNuaWNvIGRpIFRvcmlubyBDZXJ0aWZp
Y2F0aW9uIEF1dGhvcml0eQICArswCQYFKw4DAhoFAKCB2DAYBgkqhkiG9w0BCQMx
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMDEyMjgxMDQ4MjJaMCMGCSqG
SIb3DQEJBDEWBBSqPlKF5XELggnT97LwDvTyKBNsvDB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQCwSz6cRjthvsuiJMhddkyrUUyb
FXSS8CvNtk77ZEu0rW6hEsrRGeYVMBQT+2coTzDCLjTlcDFhBR22Kjoih9Guvrwx
2q08OtADXz9Ysd1XwHFwz5f+1oVI+O2RvtfJmSLzw9vx9eVeRTrxSo3EZd/BAeu5
FD3PGhhp6OVZIgpN4x4UtXJyx2hokymOjSRwLS4wFsowEh+2CSOrLVtVoKY70GHK
40eMEVb/7nvKFnF3kyjoDROzzuCaPddD78KQ9uFVNvcd3dCQxUdy8fNTOqgl22ft
8uueJ8cfsto22e/BWy3BYGqg62Eqme3dP+DWvjDwIi2UA296o6xGymQYySlf

------CE58403B3E7E2514B1A662BC83190689--

