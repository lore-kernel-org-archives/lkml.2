Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966083Ab2FBBHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 21:07:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33050 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933722Ab2FBBHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 21:07:41 -0400
Message-ID: <4FC9674F.4010509@gmail.com>
Date: Sat, 02 Jun 2012 03:07:27 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/5] Rename files from nls_mac*.c to nls_mac-*.c
X-Enigmail-Version: 1.4
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig97C1E8257A14412AEE90106D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig97C1E8257A14412AEE90106D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

This is textual changes. Rename is done by

cs fs/nls; for x in nls_mac*.c; do git mv "$x" "$(echo "$x"|sed s,mac,mac=
-,g)"; done

Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
---
 fs/nls/Makefile           |   22 +-
 fs/nls/nls_mac-celtic.c   |  602 +++++++++++++++++++++++++++++++++++++++=
+++
 fs/nls/nls_mac-centeuro.c |  532 +++++++++++++++++++++++++++++++++++++
 fs/nls/nls_mac-croatian.c |  602 +++++++++++++++++++++++++++++++++++++++=
+++
 fs/nls/nls_mac-cyrillic.c |  497 +++++++++++++++++++++++++++++++++++
 fs/nls/nls_mac-gaelic.c   |  567 +++++++++++++++++++++++++++++++++++++++=
+
 fs/nls/nls_mac-greek.c    |  497 +++++++++++++++++++++++++++++++++++
 fs/nls/nls_mac-iceland.c  |  602 +++++++++++++++++++++++++++++++++++++++=
+++
 fs/nls/nls_mac-inuit.c    |  532 +++++++++++++++++++++++++++++++++++++
 fs/nls/nls_mac-roman.c    |  637 +++++++++++++++++++++++++++++++++++++++=
++++++
 fs/nls/nls_mac-romanian.c |  602 +++++++++++++++++++++++++++++++++++++++=
+++
 fs/nls/nls_mac-turkish.c  |  602 +++++++++++++++++++++++++++++++++++++++=
+++
 fs/nls/nls_macceltic.c    |  602 ---------------------------------------=
---
 fs/nls/nls_maccenteuro.c  |  532 -------------------------------------
 fs/nls/nls_maccroatian.c  |  602 ---------------------------------------=
---
 fs/nls/nls_maccyrillic.c  |  497 -----------------------------------
 fs/nls/nls_macgaelic.c    |  567 ---------------------------------------=
-
 fs/nls/nls_macgreek.c     |  497 -----------------------------------
 fs/nls/nls_maciceland.c   |  602 ---------------------------------------=
---
 fs/nls/nls_macinuit.c     |  532 -------------------------------------
 fs/nls/nls_macroman.c     |  637 ---------------------------------------=
------
 fs/nls/nls_macromanian.c  |  602 ---------------------------------------=
---
 fs/nls/nls_macturkish.c   |  602 ---------------------------------------=
---
 23 files changed, 6283 insertions(+), 6283 deletions(-)
 create mode 100644 fs/nls/nls_mac-celtic.c
 create mode 100644 fs/nls/nls_mac-centeuro.c
 create mode 100644 fs/nls/nls_mac-croatian.c
 create mode 100644 fs/nls/nls_mac-cyrillic.c
 create mode 100644 fs/nls/nls_mac-gaelic.c
 create mode 100644 fs/nls/nls_mac-greek.c
 create mode 100644 fs/nls/nls_mac-iceland.c
 create mode 100644 fs/nls/nls_mac-inuit.c
 create mode 100644 fs/nls/nls_mac-roman.c
 create mode 100644 fs/nls/nls_mac-romanian.c
 create mode 100644 fs/nls/nls_mac-turkish.c
 delete mode 100644 fs/nls/nls_macceltic.c
 delete mode 100644 fs/nls/nls_maccenteuro.c
 delete mode 100644 fs/nls/nls_maccroatian.c
 delete mode 100644 fs/nls/nls_maccyrillic.c
 delete mode 100644 fs/nls/nls_macgaelic.c
 delete mode 100644 fs/nls/nls_macgreek.c
 delete mode 100644 fs/nls/nls_maciceland.c
 delete mode 100644 fs/nls/nls_macinuit.c
 delete mode 100644 fs/nls/nls_macroman.c
 delete mode 100644 fs/nls/nls_macromanian.c
 delete mode 100644 fs/nls/nls_macturkish.c

diff --git a/fs/nls/Makefile b/fs/nls/Makefile
index 2dea8a1..7756060 100644
--- a/fs/nls/Makefile
+++ b/fs/nls/Makefile
@@ -42,14 +42,14 @@ obj-$(CONFIG_NLS_ISO8859_15)	+=3D nls_iso8859-15.o
 obj-$(CONFIG_NLS_KOI8_R)	+=3D nls_koi8-r.o
 obj-$(CONFIG_NLS_KOI8_U)	+=3D nls_koi8-u.o nls_koi8-ru.o
 obj-$(CONFIG_NLS_UTF8)		+=3D nls_utf8.o
-obj-$(CONFIG_NLS_MAC_CELTIC)     +=3D nls_macceltic.o
-obj-$(CONFIG_NLS_MAC_CENTEURO)   +=3D nls_maccenteuro.o
-obj-$(CONFIG_NLS_MAC_CROATIAN)   +=3D nls_maccroatian.o
-obj-$(CONFIG_NLS_MAC_CYRILLIC)   +=3D nls_maccyrillic.o
-obj-$(CONFIG_NLS_MAC_GAELIC)     +=3D nls_macgaelic.o
-obj-$(CONFIG_NLS_MAC_GREEK)      +=3D nls_macgreek.o
-obj-$(CONFIG_NLS_MAC_ICELAND)    +=3D nls_maciceland.o
-obj-$(CONFIG_NLS_MAC_INUIT)      +=3D nls_macinuit.o
-obj-$(CONFIG_NLS_MAC_ROMANIAN)   +=3D nls_macromanian.o
-obj-$(CONFIG_NLS_MAC_ROMAN)      +=3D nls_macroman.o
-obj-$(CONFIG_NLS_MAC_TURKISH)    +=3D nls_macturkish.o
+obj-$(CONFIG_NLS_MAC_CELTIC)     +=3D nls_mac-celtic.o
+obj-$(CONFIG_NLS_MAC_CENTEURO)   +=3D nls_mac-centeuro.o
+obj-$(CONFIG_NLS_MAC_CROATIAN)   +=3D nls_mac-croatian.o
+obj-$(CONFIG_NLS_MAC_CYRILLIC)   +=3D nls_mac-cyrillic.o
+obj-$(CONFIG_NLS_MAC_GAELIC)     +=3D nls_mac-gaelic.o
+obj-$(CONFIG_NLS_MAC_GREEK)      +=3D nls_mac-greek.o
+obj-$(CONFIG_NLS_MAC_ICELAND)    +=3D nls_mac-iceland.o
+obj-$(CONFIG_NLS_MAC_INUIT)      +=3D nls_mac-inuit.o
+obj-$(CONFIG_NLS_MAC_ROMANIAN)   +=3D nls_mac-romanian.o
+obj-$(CONFIG_NLS_MAC_ROMAN)      +=3D nls_mac-roman.o
+obj-$(CONFIG_NLS_MAC_TURKISH)    +=3D nls_mac-turkish.o
--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enig97C1E8257A14412AEE90106D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk/JZ08ACgkQNak7dOguQgnW/QEArDcAFRObPYa4Eg4ONPbZ2/hP
/Bb4AOjZyliNbh7fQxEA/2XSOvjvvkW1YfNmM+W40Xol1u8833NqO/fchL2LtfJC
=FS1X
-----END PGP SIGNATURE-----

--------------enig97C1E8257A14412AEE90106D--
