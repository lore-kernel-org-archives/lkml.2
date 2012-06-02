Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966109Ab2FBBKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 21:10:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63455 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966072Ab2FBBKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 21:10:08 -0400
Message-ID: <4FC967E4.7010507@gmail.com>
Date: Sat, 02 Jun 2012 03:09:56 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 5/5] Rename variables from nls_mac* to nls_mac_*
X-Enigmail-Version: 1.4
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigE90E478FDEA0822146C31CE9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE90E478FDEA0822146C31CE9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
---
 fs/nls/nls_mac-celtic.c   |   10 +++++-----
 fs/nls/nls_mac-centeuro.c |   10 +++++-----
 fs/nls/nls_mac-croatian.c |   10 +++++-----
 fs/nls/nls_mac-cyrillic.c |   10 +++++-----
 fs/nls/nls_mac-gaelic.c   |   10 +++++-----
 fs/nls/nls_mac-greek.c    |   10 +++++-----
 fs/nls/nls_mac-iceland.c  |   10 +++++-----
 fs/nls/nls_mac-inuit.c    |   10 +++++-----
 fs/nls/nls_mac-roman.c    |   10 +++++-----
 fs/nls/nls_mac-romanian.c |   10 +++++-----
 fs/nls/nls_mac-turkish.c  |   10 +++++-----
 11 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/fs/nls/nls_mac-celtic.c b/fs/nls/nls_mac-celtic.c
index 984ecb5..bf7cba9 100644
--- a/fs/nls/nls_mac-celtic.c
+++ b/fs/nls/nls_mac-celtic.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/nls/nls_macceltic.c
+ * linux/fs/nls/nls_mac_celtic.c
  *
  * Charset macceltic translation tables.
  * Generated automatically from the Unicode and charset
@@ -586,17 +586,17 @@ static struct nls_table table =3D {
 	.owner		=3D THIS_MODULE,
 };
=20
-static int __init init_nls_macceltic(void)
+static int __init init_nls_mac_celtic(void)
 {
 	return register_nls(&table);
 }
=20
-static void __exit exit_nls_macceltic(void)
+static void __exit exit_nls_mac_celtic(void)
 {
 	unregister_nls(&table);
 }
=20
-module_init(init_nls_macceltic)
-module_exit(exit_nls_macceltic)
+module_init(init_nls_mac_celtic)
+module_exit(exit_nls_mac_celtic)
=20
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_mac-centeuro.c b/fs/nls/nls_mac-centeuro.c
index 246d279..8749d31 100644
--- a/fs/nls/nls_mac-centeuro.c
+++ b/fs/nls/nls_mac-centeuro.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/nls/nls_maccenteuro.c
+ * linux/fs/nls/nls_mac_centeuro.c
  *
  * Charset maccenteuro translation tables.
  * Generated automatically from the Unicode and charset
@@ -516,17 +516,17 @@ static struct nls_table table =3D {
 	.owner		=3D THIS_MODULE,
 };
=20
-static int __init init_nls_maccenteuro(void)
+static int __init init_nls_mac_centeuro(void)
 {
 	return register_nls(&table);
 }
=20
-static void __exit exit_nls_maccenteuro(void)
+static void __exit exit_nls_mac_centeuro(void)
 {
 	unregister_nls(&table);
 }
=20
-module_init(init_nls_maccenteuro)
-module_exit(exit_nls_maccenteuro)
+module_init(init_nls_mac_centeuro)
+module_exit(exit_nls_mac_centeuro)
=20
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_mac-croatian.c b/fs/nls/nls_mac-croatian.c
index da965de..0d2b586 100644
--- a/fs/nls/nls_mac-croatian.c
+++ b/fs/nls/nls_mac-croatian.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/nls/nls_maccroatian.c
+ * linux/fs/nls/nls_mac_croatian.c
  *
  * Charset maccroatian translation tables.
  * Generated automatically from the Unicode and charset
@@ -586,17 +586,17 @@ static struct nls_table table =3D {
 	.owner		=3D THIS_MODULE,
 };
=20
-static int __init init_nls_maccroatian(void)
+static int __init init_nls_mac_croatian(void)
 {
 	return register_nls(&table);
 }
=20
-static void __exit exit_nls_maccroatian(void)
+static void __exit exit_nls_mac_croatian(void)
 {
 	unregister_nls(&table);
 }
=20
-module_init(init_nls_maccroatian)
-module_exit(exit_nls_maccroatian)
+module_init(init_nls_mac_croatian)
+module_exit(exit_nls_mac_croatian)
=20
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_mac-cyrillic.c b/fs/nls/nls_mac-cyrillic.c
index 35e1a7ea..52ee4b2 100644
--- a/fs/nls/nls_mac-cyrillic.c
+++ b/fs/nls/nls_mac-cyrillic.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/nls/nls_maccyrillic.c
+ * linux/fs/nls/nls_mac_cyrillic.c
  *
  * Charset maccyrillic translation tables.
  * Generated automatically from the Unicode and charset
@@ -481,17 +481,17 @@ static struct nls_table table =3D {
 	.owner		=3D THIS_MODULE,
 };
=20
-static int __init init_nls_maccyrillic(void)
+static int __init init_nls_mac_cyrillic(void)
 {
 	return register_nls(&table);
 }
=20
-static void __exit exit_nls_maccyrillic(void)
+static void __exit exit_nls_mac_cyrillic(void)
 {
 	unregister_nls(&table);
 }
=20
-module_init(init_nls_maccyrillic)
-module_exit(exit_nls_maccyrillic)
+module_init(init_nls_mac_cyrillic)
+module_exit(exit_nls_mac_cyrillic)
=20
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_mac-gaelic.c b/fs/nls/nls_mac-gaelic.c
index 7815e00..bbf6bf6 100644
--- a/fs/nls/nls_mac-gaelic.c
+++ b/fs/nls/nls_mac-gaelic.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/nls/nls_macgaelic.c
+ * linux/fs/nls/nls_mac_gaelic.c
  *
  * Charset macgaelic translation tables.
  * Generated automatically from the Unicode and charset
@@ -551,17 +551,17 @@ static struct nls_table table =3D {
 	.owner		=3D THIS_MODULE,
 };
=20
-static int __init init_nls_macgaelic(void)
+static int __init init_nls_mac_gaelic(void)
 {
 	return register_nls(&table);
 }
=20
-static void __exit exit_nls_macgaelic(void)
+static void __exit exit_nls_mac_gaelic(void)
 {
 	unregister_nls(&table);
 }
=20
-module_init(init_nls_macgaelic)
-module_exit(exit_nls_macgaelic)
+module_init(init_nls_mac_gaelic)
+module_exit(exit_nls_mac_gaelic)
=20
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_mac-greek.c b/fs/nls/nls_mac-greek.c
index b5ede78..51469cc 100644
--- a/fs/nls/nls_mac-greek.c
+++ b/fs/nls/nls_mac-greek.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/nls/nls_macgreek.c
+ * linux/fs/nls/nls_mac_greek.c
  *
  * Charset macgreek translation tables.
  * Generated automatically from the Unicode and charset
@@ -481,17 +481,17 @@ static struct nls_table table =3D {
 	.owner		=3D THIS_MODULE,
 };
=20
-static int __init init_nls_macgreek(void)
+static int __init init_nls_mac_greek(void)
 {
 	return register_nls(&table);
 }
=20
-static void __exit exit_nls_macgreek(void)
+static void __exit exit_nls_mac_greek(void)
 {
 	unregister_nls(&table);
 }
=20
-module_init(init_nls_macgreek)
-module_exit(exit_nls_macgreek)
+module_init(init_nls_mac_greek)
+module_exit(exit_nls_mac_greek)
=20
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_mac-iceland.c b/fs/nls/nls_mac-iceland.c
index d0c7e71..1fb5908 100644
--- a/fs/nls/nls_mac-iceland.c
+++ b/fs/nls/nls_mac-iceland.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/nls/nls_maciceland.c
+ * linux/fs/nls/nls_mac_iceland.c
  *
  * Charset maciceland translation tables.
  * Generated automatically from the Unicode and charset
@@ -586,17 +586,17 @@ static struct nls_table table =3D {
 	.owner		=3D THIS_MODULE,
 };
=20
-static int __init init_nls_maciceland(void)
+static int __init init_nls_mac_iceland(void)
 {
 	return register_nls(&table);
 }
=20
-static void __exit exit_nls_maciceland(void)
+static void __exit exit_nls_mac_iceland(void)
 {
 	unregister_nls(&table);
 }
=20
-module_init(init_nls_maciceland)
-module_exit(exit_nls_maciceland)
+module_init(init_nls_mac_iceland)
+module_exit(exit_nls_mac_iceland)
=20
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_mac-inuit.c b/fs/nls/nls_mac-inuit.c
index 85fc451..ec8453d 100644
--- a/fs/nls/nls_mac-inuit.c
+++ b/fs/nls/nls_mac-inuit.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/nls/nls_macinuit.c
+ * linux/fs/nls/nls_mac_inuit.c
  *
  * Charset macinuit translation tables.
  * Generated automatically from the Unicode and charset
@@ -516,17 +516,17 @@ static struct nls_table table =3D {
 	.owner		=3D THIS_MODULE,
 };
=20
-static int __init init_nls_macinuit(void)
+static int __init init_nls_mac_inuit(void)
 {
 	return register_nls(&table);
 }
=20
-static void __exit exit_nls_macinuit(void)
+static void __exit exit_nls_mac_inuit(void)
 {
 	unregister_nls(&table);
 }
=20
-module_init(init_nls_macinuit)
-module_exit(exit_nls_macinuit)
+module_init(init_nls_mac_inuit)
+module_exit(exit_nls_mac_inuit)
=20
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_mac-roman.c b/fs/nls/nls_mac-roman.c
index 711e152..7aaba5c 100644
--- a/fs/nls/nls_mac-roman.c
+++ b/fs/nls/nls_mac-roman.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/nls/nls_macroman.c
+ * linux/fs/nls/nls_mac_roman.c
  *
  * Charset macroman translation tables.
  * Generated automatically from the Unicode and charset
@@ -621,17 +621,17 @@ static struct nls_table table =3D {
 	.owner		=3D THIS_MODULE,
 };
=20
-static int __init init_nls_macroman(void)
+static int __init init_nls_mac_roman(void)
 {
 	return register_nls(&table);
 }
=20
-static void __exit exit_nls_macroman(void)
+static void __exit exit_nls_mac_roman(void)
 {
 	unregister_nls(&table);
 }
=20
-module_init(init_nls_macroman)
-module_exit(exit_nls_macroman)
+module_init(init_nls_mac_roman)
+module_exit(exit_nls_mac_roman)
=20
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_mac-romanian.c b/fs/nls/nls_mac-romanian.c
index 53ac67e..1aad115 100644
--- a/fs/nls/nls_mac-romanian.c
+++ b/fs/nls/nls_mac-romanian.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/nls/nls_macromanian.c
+ * linux/fs/nls/nls_mac_romanian.c
  *
  * Charset macromanian translation tables.
  * Generated automatically from the Unicode and charset
@@ -586,17 +586,17 @@ static struct nls_table table =3D {
 	.owner		=3D THIS_MODULE,
 };
=20
-static int __init init_nls_macromanian(void)
+static int __init init_nls_mac_romanian(void)
 {
 	return register_nls(&table);
 }
=20
-static void __exit exit_nls_macromanian(void)
+static void __exit exit_nls_mac_romanian(void)
 {
 	unregister_nls(&table);
 }
=20
-module_init(init_nls_macromanian)
-module_exit(exit_nls_macromanian)
+module_init(init_nls_mac_romanian)
+module_exit(exit_nls_mac_romanian)
=20
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_mac-turkish.c b/fs/nls/nls_mac-turkish.c
index 842bf3d..605817c 100644
--- a/fs/nls/nls_mac-turkish.c
+++ b/fs/nls/nls_mac-turkish.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/nls/nls_macturkish.c
+ * linux/fs/nls/nls_mac_turkish.c
  *
  * Charset macturkish translation tables.
  * Generated automatically from the Unicode and charset
@@ -586,17 +586,17 @@ static struct nls_table table =3D {
 	.owner		=3D THIS_MODULE,
 };
=20
-static int __init init_nls_macturkish(void)
+static int __init init_nls_mac_turkish(void)
 {
 	return register_nls(&table);
 }
=20
-static void __exit exit_nls_macturkish(void)
+static void __exit exit_nls_mac_turkish(void)
 {
 	unregister_nls(&table);
 }
=20
-module_init(init_nls_macturkish)
-module_exit(exit_nls_macturkish)
+module_init(init_nls_mac_turkish)
+module_exit(exit_nls_mac_turkish)
=20
 MODULE_LICENSE("Dual BSD/GPL");
--=20
1.7.7.6

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enigE90E478FDEA0822146C31CE9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk/JZ+QACgkQNak7dOguQgl4xQD/TlqYirWUoveQ+5gyu3NhMIQ6
UNfp1IorKEhQ5t5dZsUA/3x9O4sGGRobd2+m6zBirD96empV7Fb3tFA9uj5tsVe9
=gpul
-----END PGP SIGNATURE-----

--------------enigE90E478FDEA0822146C31CE9--
