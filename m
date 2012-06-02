Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726Ab2FBBDD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 21:03:03 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45235 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933322Ab2FBBDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 21:03:01 -0400
Message-ID: <4FC96637.3090701@gmail.com>
Date: Sat, 02 Jun 2012 03:02:47 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/5] REmove accidentally committed asignments
X-Enigmail-Version: 1.4
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig30CCB3D744EA3310F7F02F74"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig30CCB3D744EA3310F7F02F74
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
---
 fs/nls/Makefile |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/fs/nls/Makefile b/fs/nls/Makefile
index b6b0550..5d74647 100644
--- a/fs/nls/Makefile
+++ b/fs/nls/Makefile
@@ -2,18 +2,6 @@
 # Makefile for native language support
 #
=20
-CONFIG_NLS_MACCELTIC=3Dm
-CONFIG_NLS_MACCENTEURO=3Dm
-CONFIG_NLS_MACCROATIAN=3Dm
-CONFIG_NLS_MACCYRILLIC=3Dm
-CONFIG_NLS_MACGAELIC=3Dm
-CONFIG_NLS_MACGREEK=3Dm
-CONFIG_NLS_MACICELAND=3Dm
-CONFIG_NLS_MACINUIT=3Dm
-CONFIG_NLS_MACROMANIAN=3Dm
-CONFIG_NLS_MACROMAN=3Dm
-CONFIG_NLS_MACTURKISH=3Dm
-
 obj-$(CONFIG_NLS)		+=3D nls_base.o
=20
 obj-$(CONFIG_NLS_CODEPAGE_437)	+=3D nls_cp437.o
--=20
1.7.7.6

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enig30CCB3D744EA3310F7F02F74
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk/JZkAACgkQNak7dOguQgkx7QEArkkSFdzsPnr8v71wsFA8fjOJ
qwzeSgkxFvbBKk3ynJoA/i0UN9eJX5c3DwQVM9tEfkqrfvZtbeOfAx0jV+LVm+g/
=wmyX
-----END PGP SIGNATURE-----

--------------enig30CCB3D744EA3310F7F02F74--
