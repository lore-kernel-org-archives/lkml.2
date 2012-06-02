Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735Ab2FBBEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 21:04:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53643 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933327Ab2FBBEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 21:04:48 -0400
Message-ID: <4FC966A8.2040109@gmail.com>
Date: Sat, 02 Jun 2012 03:04:40 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/5] Rename CODEPAGE_MAC* to MAC_* in config variables
X-Enigmail-Version: 1.4
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig9296152C5B306BF310FAE3B0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9296152C5B306BF310FAE3B0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
---
 fs/nls/Kconfig  |   22 +++++++++++-----------
 fs/nls/Makefile |   22 +++++++++++-----------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/fs/nls/Kconfig b/fs/nls/Kconfig
index b5eac98..e2ce79e 100644
--- a/fs/nls/Kconfig
+++ b/fs/nls/Kconfig
@@ -452,7 +452,7 @@ config NLS_KOI8_U
 	  input/output character sets. Say Y here for the preferred Ukrainian
 	  (koi8-u) and Belarusian (koi8-ru) character sets.
=20
-config NLS_CODEPAGE_MACROMAN
+config NLS_MAC_ROMAN
 	tristate "Codepage macroman"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
@@ -467,7 +467,7 @@ config NLS_CODEPAGE_MACROMAN
=20
 	  If unsure, say Y.
=20
-config NLS_CODEPAGE_MACCELTIC
+config NLS_MAC_CELTIC
 	tristate "Codepage macceltic"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
@@ -481,7 +481,7 @@ config NLS_CODEPAGE_MACCELTIC
=20
 	  If unsure, say Y.
=20
-config NLS_CODEPAGE_MACCENTEURO
+config NLS_MAC_CENTEURO
 	tristate "Codepage maccenteuro"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
@@ -495,7 +495,7 @@ config NLS_CODEPAGE_MACCENTEURO
=20
 	  If unsure, say Y.
=20
-config NLS_CODEPAGE_MACCROATIAN
+config NLS_MAC_CROATIAN
 	tristate "Codepage maccroatian"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
@@ -509,7 +509,7 @@ config NLS_CODEPAGE_MACCROATIAN
=20
 	  If unsure, say Y.
=20
-config NLS_CODEPAGE_MACCYRILLIC
+config NLS_MAC_CYRILLIC
 	tristate "Codepage maccyrillic"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
@@ -523,7 +523,7 @@ config NLS_CODEPAGE_MACCYRILLIC
=20
 	  If unsure, say Y.
=20
-config NLS_CODEPAGE_MACGAELIC
+config NLS_MAC_GAELIC
 	tristate "Codepage macgaelic"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
@@ -537,7 +537,7 @@ config NLS_CODEPAGE_MACGAELIC
=20
 	  If unsure, say Y.
=20
-config NLS_CODEPAGE_MACGREEK
+config NLS_MAC_GREEK
 	tristate "Codepage macgreek"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
@@ -551,7 +551,7 @@ config NLS_CODEPAGE_MACGREEK
=20
 	  If unsure, say Y.
=20
-config NLS_CODEPAGE_MACICELAND
+config NLS_MAC_ICELAND
 	tristate "Codepage maciceland"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
@@ -565,7 +565,7 @@ config NLS_CODEPAGE_MACICELAND
=20
 	  If unsure, say Y.
=20
-config NLS_CODEPAGE_MACINUIT
+config NLS_MAC_INUIT
 	tristate "Codepage macinuit"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
@@ -579,7 +579,7 @@ config NLS_CODEPAGE_MACINUIT
=20
 	  If unsure, say Y.
=20
-config NLS_CODEPAGE_MACROMANIAN
+config NLS_MAC_ROMANIAN
 	tristate "Codepage macromanian"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
@@ -593,7 +593,7 @@ config NLS_CODEPAGE_MACROMANIAN
=20
 	  If unsure, say Y.
=20
-config NLS_CODEPAGE_MACTURKISH
+config NLS_MAC_TURKISH
 	tristate "Codepage macturkish"
 	---help---
 	  The Apple HFS file system family can deal with filenames in
diff --git a/fs/nls/Makefile b/fs/nls/Makefile
index 5d74647..2dea8a1 100644
--- a/fs/nls/Makefile
+++ b/fs/nls/Makefile
@@ -42,14 +42,14 @@ obj-$(CONFIG_NLS_ISO8859_15)	+=3D nls_iso8859-15.o
 obj-$(CONFIG_NLS_KOI8_R)	+=3D nls_koi8-r.o
 obj-$(CONFIG_NLS_KOI8_U)	+=3D nls_koi8-u.o nls_koi8-ru.o
 obj-$(CONFIG_NLS_UTF8)		+=3D nls_utf8.o
-obj-$(CONFIG_NLS_MACCELTIC)     +=3D nls_macceltic.o
-obj-$(CONFIG_NLS_MACCENTEURO)   +=3D nls_maccenteuro.o
-obj-$(CONFIG_NLS_MACCROATIAN)   +=3D nls_maccroatian.o
-obj-$(CONFIG_NLS_MACCYRILLIC)   +=3D nls_maccyrillic.o
-obj-$(CONFIG_NLS_MACGAELIC)     +=3D nls_macgaelic.o
-obj-$(CONFIG_NLS_MACGREEK)      +=3D nls_macgreek.o
-obj-$(CONFIG_NLS_MACICELAND)    +=3D nls_maciceland.o
-obj-$(CONFIG_NLS_MACINUIT)      +=3D nls_macinuit.o
-obj-$(CONFIG_NLS_MACROMANIAN)   +=3D nls_macromanian.o
-obj-$(CONFIG_NLS_MACROMAN)      +=3D nls_macroman.o
-obj-$(CONFIG_NLS_MACTURKISH)    +=3D nls_macturkish.o
+obj-$(CONFIG_NLS_MAC_CELTIC)     +=3D nls_macceltic.o
+obj-$(CONFIG_NLS_MAC_CENTEURO)   +=3D nls_maccenteuro.o
+obj-$(CONFIG_NLS_MAC_CROATIAN)   +=3D nls_maccroatian.o
+obj-$(CONFIG_NLS_MAC_CYRILLIC)   +=3D nls_maccyrillic.o
+obj-$(CONFIG_NLS_MAC_GAELIC)     +=3D nls_macgaelic.o
+obj-$(CONFIG_NLS_MAC_GREEK)      +=3D nls_macgreek.o
+obj-$(CONFIG_NLS_MAC_ICELAND)    +=3D nls_maciceland.o
+obj-$(CONFIG_NLS_MAC_INUIT)      +=3D nls_macinuit.o
+obj-$(CONFIG_NLS_MAC_ROMANIAN)   +=3D nls_macromanian.o
+obj-$(CONFIG_NLS_MAC_ROMAN)      +=3D nls_macroman.o
+obj-$(CONFIG_NLS_MAC_TURKISH)    +=3D nls_macturkish.o
--=20
1.7.7.6

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enig9296152C5B306BF310FAE3B0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk/JZqgACgkQNak7dOguQgnxZwD/QFVJD/gm466nd0nlOMXF0gLl
lyR/jszz0sTj2Wk09JEA/30oCYLx1r4VilkgHkdanRMgBK21NOAZYaJ8ZK4ScRVa
=1QMV
-----END PGP SIGNATURE-----

--------------enig9296152C5B306BF310FAE3B0--
