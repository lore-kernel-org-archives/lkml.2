Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966098Ab2FBBIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 21:08:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47097 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965612Ab2FBBIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 21:08:48 -0400
Message-ID: <4FC96795.5020702@gmail.com>
Date: Sat, 02 Jun 2012 03:08:37 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/5] Rename charsets from mac* to mac-*
X-Enigmail-Version: 1.4
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig62FF2035AE0FC9CFF8BC5528"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig62FF2035AE0FC9CFF8BC5528
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
---
 fs/nls/Kconfig            |   24 ++++++++++++------------
 fs/nls/nls_mac-celtic.c   |    2 +-
 fs/nls/nls_mac-centeuro.c |    2 +-
 fs/nls/nls_mac-croatian.c |    2 +-
 fs/nls/nls_mac-cyrillic.c |    2 +-
 fs/nls/nls_mac-gaelic.c   |    2 +-
 fs/nls/nls_mac-greek.c    |    2 +-
 fs/nls/nls_mac-iceland.c  |    2 +-
 fs/nls/nls_mac-inuit.c    |    2 +-
 fs/nls/nls_mac-roman.c    |    2 +-
 fs/nls/nls_mac-romanian.c |    2 +-
 fs/nls/nls_mac-turkish.c  |    2 +-
 12 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/nls/Kconfig b/fs/nls/Kconfig
index e2ce79e..3a5747e 100644
--- a/fs/nls/Kconfig
+++ b/fs/nls/Kconfig
@@ -30,7 +30,7 @@ config NLS_DEFAULT
 	  cp949, cp950, cp1251, cp1255, euc-jp, euc-kr, gb2312, iso8859-1,
 	  iso8859-2, iso8859-3, iso8859-4, iso8859-5, iso8859-6, iso8859-7,
 	  iso8859-8, iso8859-9, iso8859-13, iso8859-14, iso8859-15,
-	  koi8-r, koi8-ru, koi8-u, sjis, tis-620, macroman, utf8.
+	  koi8-r, koi8-ru, koi8-u, sjis, tis-620, mac-roman, utf8.
 	  If you specify a wrong value, it will use the built-in NLS;
 	  compatible with iso8859-1.
=20
@@ -453,7 +453,7 @@ config NLS_KOI8_U
 	  (koi8-u) and Belarusian (koi8-ru) character sets.
=20
 config NLS_MAC_ROMAN
-	tristate "Codepage macroman"
+	tristate "Codepage mac-roman"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -468,7 +468,7 @@ config NLS_MAC_ROMAN
 	  If unsure, say Y.
=20
 config NLS_MAC_CELTIC
-	tristate "Codepage macceltic"
+	tristate "Codepage mac-celtic"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -482,7 +482,7 @@ config NLS_MAC_CELTIC
 	  If unsure, say Y.
=20
 config NLS_MAC_CENTEURO
-	tristate "Codepage maccenteuro"
+	tristate "Codepage mac-centeuro"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -496,7 +496,7 @@ config NLS_MAC_CENTEURO
 	  If unsure, say Y.
=20
 config NLS_MAC_CROATIAN
-	tristate "Codepage maccroatian"
+	tristate "Codepage mac-croatian"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -510,7 +510,7 @@ config NLS_MAC_CROATIAN
 	  If unsure, say Y.
=20
 config NLS_MAC_CYRILLIC
-	tristate "Codepage maccyrillic"
+	tristate "Codepage mac-cyrillic"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -524,7 +524,7 @@ config NLS_MAC_CYRILLIC
 	  If unsure, say Y.
=20
 config NLS_MAC_GAELIC
-	tristate "Codepage macgaelic"
+	tristate "Codepage mac-gaelic"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -538,7 +538,7 @@ config NLS_MAC_GAELIC
 	  If unsure, say Y.
=20
 config NLS_MAC_GREEK
-	tristate "Codepage macgreek"
+	tristate "Codepage mac-greek"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -552,7 +552,7 @@ config NLS_MAC_GREEK
 	  If unsure, say Y.
=20
 config NLS_MAC_ICELAND
-	tristate "Codepage maciceland"
+	tristate "Codepage mac-iceland"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -566,7 +566,7 @@ config NLS_MAC_ICELAND
 	  If unsure, say Y.
=20
 config NLS_MAC_INUIT
-	tristate "Codepage macinuit"
+	tristate "Codepage mac-inuit"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -580,7 +580,7 @@ config NLS_MAC_INUIT
 	  If unsure, say Y.
=20
 config NLS_MAC_ROMANIAN
-	tristate "Codepage macromanian"
+	tristate "Codepage mac-romanian"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -594,7 +594,7 @@ config NLS_MAC_ROMANIAN
 	  If unsure, say Y.
=20
 config NLS_MAC_TURKISH
-	tristate "Codepage macturkish"
+	tristate "Codepage mac-turkish"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
diff --git a/fs/nls/nls_mac-celtic.c b/fs/nls/nls_mac-celtic.c
index 95ac5b4..984ecb5 100644
--- a/fs/nls/nls_mac-celtic.c
+++ b/fs/nls/nls_mac-celtic.c
@@ -578,7 +578,7 @@ static int char2uni(const unsigned char *rawstring, i=
nt boundlen, wchar_t *uni)
 }
=20
 static struct nls_table table =3D {
-	.charset	=3D "macceltic",
+	.charset	=3D "mac-celtic",
 	.uni2char	=3D uni2char,
 	.char2uni	=3D char2uni,
 	.charset2lower	=3D charset2lower,
diff --git a/fs/nls/nls_mac-centeuro.c b/fs/nls/nls_mac-centeuro.c
index ce0d57e..246d279 100644
--- a/fs/nls/nls_mac-centeuro.c
+++ b/fs/nls/nls_mac-centeuro.c
@@ -508,7 +508,7 @@ static int char2uni(const unsigned char *rawstring, i=
nt boundlen, wchar_t *uni)
 }
=20
 static struct nls_table table =3D {
-	.charset	=3D "maccenteuro",
+	.charset	=3D "mac-centeuro",
 	.uni2char	=3D uni2char,
 	.char2uni	=3D char2uni,
 	.charset2lower	=3D charset2lower,
diff --git a/fs/nls/nls_mac-croatian.c b/fs/nls/nls_mac-croatian.c
index 10b01c3..da965de 100644
--- a/fs/nls/nls_mac-croatian.c
+++ b/fs/nls/nls_mac-croatian.c
@@ -578,7 +578,7 @@ static int char2uni(const unsigned char *rawstring, i=
nt boundlen, wchar_t *uni)
 }
=20
 static struct nls_table table =3D {
-	.charset	=3D "maccroatian",
+	.charset	=3D "mac-croatian",
 	.uni2char	=3D uni2char,
 	.char2uni	=3D char2uni,
 	.charset2lower	=3D charset2lower,
diff --git a/fs/nls/nls_mac-cyrillic.c b/fs/nls/nls_mac-cyrillic.c
index 318473f..35e1a7ea 100644
--- a/fs/nls/nls_mac-cyrillic.c
+++ b/fs/nls/nls_mac-cyrillic.c
@@ -473,7 +473,7 @@ static int char2uni(const unsigned char *rawstring, i=
nt boundlen, wchar_t *uni)
 }
=20
 static struct nls_table table =3D {
-	.charset	=3D "maccyrillic",
+	.charset	=3D "mac-cyrillic",
 	.uni2char	=3D uni2char,
 	.char2uni	=3D char2uni,
 	.charset2lower	=3D charset2lower,
diff --git a/fs/nls/nls_mac-gaelic.c b/fs/nls/nls_mac-gaelic.c
index 615d8e1..7815e00 100644
--- a/fs/nls/nls_mac-gaelic.c
+++ b/fs/nls/nls_mac-gaelic.c
@@ -543,7 +543,7 @@ static int char2uni(const unsigned char *rawstring, i=
nt boundlen, wchar_t *uni)
 }
=20
 static struct nls_table table =3D {
-	.charset	=3D "macgaelic",
+	.charset	=3D "mac-gaelic",
 	.uni2char	=3D uni2char,
 	.char2uni	=3D char2uni,
 	.charset2lower	=3D charset2lower,
diff --git a/fs/nls/nls_mac-greek.c b/fs/nls/nls_mac-greek.c
index 79880f3..b5ede78 100644
--- a/fs/nls/nls_mac-greek.c
+++ b/fs/nls/nls_mac-greek.c
@@ -473,7 +473,7 @@ static int char2uni(const unsigned char *rawstring, i=
nt boundlen, wchar_t *uni)
 }
=20
 static struct nls_table table =3D {
-	.charset	=3D "macgreek",
+	.charset	=3D "mac-greek",
 	.uni2char	=3D uni2char,
 	.char2uni	=3D char2uni,
 	.charset2lower	=3D charset2lower,
diff --git a/fs/nls/nls_mac-iceland.c b/fs/nls/nls_mac-iceland.c
index 1e688c5..d0c7e71 100644
--- a/fs/nls/nls_mac-iceland.c
+++ b/fs/nls/nls_mac-iceland.c
@@ -578,7 +578,7 @@ static int char2uni(const unsigned char *rawstring, i=
nt boundlen, wchar_t *uni)
 }
=20
 static struct nls_table table =3D {
-	.charset	=3D "maciceland",
+	.charset	=3D "mac-iceland",
 	.uni2char	=3D uni2char,
 	.char2uni	=3D char2uni,
 	.charset2lower	=3D charset2lower,
diff --git a/fs/nls/nls_mac-inuit.c b/fs/nls/nls_mac-inuit.c
index f333d98..85fc451 100644
--- a/fs/nls/nls_mac-inuit.c
+++ b/fs/nls/nls_mac-inuit.c
@@ -508,7 +508,7 @@ static int char2uni(const unsigned char *rawstring, i=
nt boundlen, wchar_t *uni)
 }
=20
 static struct nls_table table =3D {
-	.charset	=3D "macinuit",
+	.charset	=3D "mac-inuit",
 	.uni2char	=3D uni2char,
 	.char2uni	=3D char2uni,
 	.charset2lower	=3D charset2lower,
diff --git a/fs/nls/nls_mac-roman.c b/fs/nls/nls_mac-roman.c
index 6315a85..711e152 100644
--- a/fs/nls/nls_mac-roman.c
+++ b/fs/nls/nls_mac-roman.c
@@ -613,7 +613,7 @@ static int char2uni(const unsigned char *rawstring, i=
nt boundlen, wchar_t *uni)
 }
=20
 static struct nls_table table =3D {
-	.charset	=3D "macroman",
+	.charset	=3D "mac-roman",
 	.uni2char	=3D uni2char,
 	.char2uni	=3D char2uni,
 	.charset2lower	=3D charset2lower,
diff --git a/fs/nls/nls_mac-romanian.c b/fs/nls/nls_mac-romanian.c
index b83c07a..53ac67e 100644
--- a/fs/nls/nls_mac-romanian.c
+++ b/fs/nls/nls_mac-romanian.c
@@ -578,7 +578,7 @@ static int char2uni(const unsigned char *rawstring, i=
nt boundlen, wchar_t *uni)
 }
=20
 static struct nls_table table =3D {
-	.charset	=3D "macromanian",
+	.charset	=3D "mac-romanian",
 	.uni2char	=3D uni2char,
 	.char2uni	=3D char2uni,
 	.charset2lower	=3D charset2lower,
diff --git a/fs/nls/nls_mac-turkish.c b/fs/nls/nls_mac-turkish.c
index 0cc2c65..842bf3d 100644
--- a/fs/nls/nls_mac-turkish.c
+++ b/fs/nls/nls_mac-turkish.c
@@ -578,7 +578,7 @@ static int char2uni(const unsigned char *rawstring, i=
nt boundlen, wchar_t *uni)
 }
=20
 static struct nls_table table =3D {
-	.charset	=3D "macturkish",
+	.charset	=3D "mac-turkish",
 	.uni2char	=3D uni2char,
 	.char2uni	=3D char2uni,
 	.charset2lower	=3D charset2lower,
--=20
1.7.7.6

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enig62FF2035AE0FC9CFF8BC5528
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk/JZ5UACgkQNak7dOguQgmxlQD+MBNDXnfcfwWEP1Hjn9eSp9by
GVdDeJ6BXfC+Lt7ApNoBAKsQ33oxBU9B58aTTBzYPEIVAbMq0yW2zvS72u8z4Fuq
=zbpd
-----END PGP SIGNATURE-----

--------------enig62FF2035AE0FC9CFF8BC5528--
