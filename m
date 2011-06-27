Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab1F0Lvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 07:51:31 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:42311 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757628Ab1F0Lud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 07:50:33 -0400
X-Sasl-enc: Mg0T9Jf+z5nm47I5yduBgmDNFwB3R7CEt3AIbo4TvQuC 1309175431
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: keyrings@linux-nfs.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com, ramunno@polito.it,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
        ecryptfs-devel@lists.launchpad.net,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH v5 0/7] eCryptfs: added support for the encrypted key type
Date: Mon, 27 Jun 2011 13:45:38 +0200
Message-Id: <1309175148-6651-1-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----011B7A1B8C9F799EBDF73EA9199DEDBA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------011B7A1B8C9F799EBDF73EA9199DEDBA

This patch set adds support for the 'encrypted' key type in the eCryptfs
filesystem.

Changelog from version v4:
 - rebased on the kernel version 3.0-rc4;
 - fixed master key dumping in request_master_key() when debug is enabled;
 - made more understandable the debug messages added in the patch 3/7.

Roberto Sassu


Roberto Sassu (7):
  encrypted_keys: avoid dumping the master key if the request fails
  encrypted-keys: fixed valid_master_desc() function description
  encrypted-keys: added additional debug messages
  encrypted-keys: add key format support
  eCryptfs: export global eCryptfs definitions to
    include/linux/ecryptfs.h
  encrypted-keys: add ecryptfs format support
  eCryptfs: added support for the encrypted key type

 Documentation/keys-ecryptfs.txt                   |   68 ++++++
 Documentation/security/keys-trusted-encrypted.txt |   52 +++--
 fs/ecryptfs/ecryptfs_kernel.h                     |  150 ++++---------
 fs/ecryptfs/keystore.c                            |   13 +-
 include/keys/encrypted-type.h                     |   13 +-
 include/linux/ecryptfs.h                          |  113 +++++++++
 security/keys/Makefile                            |    2 +-
 security/keys/ecryptfs_format.c                   |   81 +++++++
 security/keys/ecryptfs_format.h                   |   30 +++
 security/keys/encrypted.c                         |  251 ++++++++++++++++-----
 10 files changed, 584 insertions(+), 189 deletions(-)
 create mode 100644 Documentation/keys-ecryptfs.txt
 create mode 100644 include/linux/ecryptfs.h
 create mode 100644 security/keys/ecryptfs_format.c
 create mode 100644 security/keys/ecryptfs_format.h

-- 
1.7.4.4


------011B7A1B8C9F799EBDF73EA9199DEDBA
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTA2MjcxMTQ1NDhaMCMGCSqG
SIb3DQEJBDEWBBTjVfQKmCyvRa3NPuM7OOVvVr0iIjB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQCeXTnbt0SpRrQwwGT46b3P6BIN
9fSZziWmdIdU5joBybWCtYwPZKM0a0xGQ+63BWDM/2tchk3cV9asf6Pro5dLpxsL
WDje55bLh2xuTuJqRlKALYUe6mXyKKRMKywEm2y7PmpsZsUdo6/jzo+S2DDHbJiV
0BDi6wGzDQ2h+Omiy+hVaBGD9uqxfCWEH/M79loiNiKxgxklITSvcBaWUeobrG8Y
P+EFGDtzCsIerZYrL2HsUP/i9MOTOaQNhvDnpoAnryV1MHHXD5+keRTpJKh/KOMK
5lHsR+MTFFRf2IZLiopd6EPVYPu0UnVZRdpvq14eGOpAR6s/FCv5DxRQfKB6

------011B7A1B8C9F799EBDF73EA9199DEDBA--


