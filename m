Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab1C2Kvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 06:51:51 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51471 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475Ab1C2Kvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 06:51:50 -0400
X-Sasl-enc: Hve4WdVXx1ZNdpdbFVieJxn8llXoze0N7hEIvk5G8ruL 1301395909
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: keyrings@linux-nfs.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com, ramunno@polito.it,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
        ecryptfs-devel@lists.launchpad.net,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH v4 0/6] eCryptfs: added support for the encrypted key type
Date: Tue, 29 Mar 2011 12:47:29 +0200
Message-Id: <1301395658-28494-1-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.4
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----17325B61E029CCC4BA91EEF4658B87BD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------17325B61E029CCC4BA91EEF4658B87BD

This patch set adds support for the 'encrypted' key type in the eCryptfs
filesystem.

Changelog from version v3:
- rebased on the latest commit of the mainline kernel (89078d572e);
- built upon the new key locking mechanism of eCryptfs;
- replaced pr_err() with pr_info() in the patch 2/6;
- keys_ecryptfs.[ch] files renamed in ecryptfs_format.[ch] in the
    patch 5/6;

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
 fs/ecryptfs/ecryptfs_kernel.h            |  150 +++++--------------
 fs/ecryptfs/keystore.c                   |   13 +-
 include/keys/encrypted-type.h            |   13 ++-
 include/linux/ecryptfs.h                 |  113 ++++++++++++++
 security/keys/Makefile                   |    2 +-
 security/keys/ecryptfs_format.c          |   81 ++++++++++
 security/keys/ecryptfs_format.h          |   30 ++++
 security/keys/encrypted.c                |  242 ++++++++++++++++++++++++------
 10 files changed, 578 insertions(+), 186 deletions(-)
 create mode 100644 Documentation/keys-ecryptfs.txt
 create mode 100644 include/linux/ecryptfs.h
 create mode 100644 security/keys/ecryptfs_format.c
 create mode 100644 security/keys/ecryptfs_format.h

-- 
1.7.4


------17325B61E029CCC4BA91EEF4658B87BD
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTAzMjkxMDQ3MzhaMCMGCSqG
SIb3DQEJBDEWBBQVS/nwc+P+cbIm9CBJTBZQHlTLjTB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQBOTYZWRYbjRCbjWYDa8p9mk4Lp
u7tn6jdOlDIE+4JIfo9d/RHFVBumLbacAiTWU+62GOPFLvrEag2I0dij6hoQTpPj
4W/2mW2vm4I8DP6DeqZpoe+uJ3sgJOeR1redWubCkRTkUKMcxEZG09Dq9lUvkhAE
PNL7U/HGMuvp8XELV2c3pEHilVjnc354O1wOgEAfKpgD8Wd7ycOcTciDaJXcM1B1
Bgel29mwYUs+N4uSfxeIiHa69J+dmpL7WDHwgGB4beN+D8Ow7IPG0rVO/L4PUD6t
czGPlhf+D38h2syGyUGdrNNv6GVIRVXk4FRXW/nixjyKyKYH45mO+1aBqCua

------17325B61E029CCC4BA91EEF4658B87BD--


