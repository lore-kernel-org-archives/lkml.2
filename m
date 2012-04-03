Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab2DCNie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 09:38:34 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55287 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab2DCNid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 09:38:33 -0400
Message-ID: <4F7AFD55.8080500@gentoo.org>
Date: Tue, 03 Apr 2012 15:38:29 +0200
From: justin <jlec@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120330 Thunderbird/11.0.1
MIME-Version: 1.0
To: dhowells@redhat.com, linux-cachefs@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs: cachefiles: Add support for large files in filesystem
 caching
X-Enigmail-Version: 1.4
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig130E4C88D191990B88DA2ACD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig130E4C88D191990B88DA2ACD
Content-Type: multipart/mixed;
 boundary="------------010109090803060709020401"

This is a multi-part message in MIME format.
--------------010109090803060709020401
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

=46rom 87b3da18f351c4f91d608e75e235c22cd30d7818 Mon Sep 17 00:00:00 2001
From: Justin Lecher <jlec@gentoo.org>
Date: Tue, 3 Apr 2012 13:51:58 +0200
Subject: [PATCH] fs: cachefiles: Add support for large files in filesyste=
m
 caching

Support the caching of large files.

https://bugzilla.kernel.org/show_bug.cgi?id=3D31182

Signed-off-by: Justin Lecher <jlec@gentoo.org>
---
 fs/cachefiles/rdwr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index 0e3c092..cc7ef95 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -918,7 +918,7 @@ int cachefiles_write_page(struct fscache_storage
*op, struct page *page)
 	 * own time */
 	dget(object->backer);
 	mntget(cache->mnt);
-	file =3D dentry_open(object->backer, cache->mnt, O_RDWR,
+	file =3D dentry_open(object->backer, cache->mnt, (O_RDWR | O_LARGEFILE)=
,
 			   cache->cache_cred);
 	if (IS_ERR(file)) {
 		ret =3D PTR_ERR(file);

--------------010109090803060709020401
Content-Type: text/x-patch;
 name="0001-fs-cachefiles-Add-support-for-large-files-in-filesys.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-fs-cachefiles-Add-support-for-large-files-in-filesys.pa";
 filename*1="tch"

=46rom 87b3da18f351c4f91d608e75e235c22cd30d7818 Mon Sep 17 00:00:00 2001
From: Justin Lecher <jlec@gentoo.org>
Date: Tue, 3 Apr 2012 13:51:58 +0200
Subject: [PATCH] fs: cachefiles: Add support for large files in filesyste=
m
 caching

Support the caching of large files.

https://bugzilla.kernel.org/show_bug.cgi?id=3D31182

Signed-off-by: Justin Lecher <jlec@gentoo.org>
---
 fs/cachefiles/rdwr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index 0e3c092..cc7ef95 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -918,7 +918,7 @@ int cachefiles_write_page(struct fscache_storage *op,=
 struct page *page)
 	 * own time */
 	dget(object->backer);
 	mntget(cache->mnt);
-	file =3D dentry_open(object->backer, cache->mnt, O_RDWR,
+	file =3D dentry_open(object->backer, cache->mnt, (O_RDWR | O_LARGEFILE)=
,
 			   cache->cache_cred);
 	if (IS_ERR(file)) {
 		ret =3D PTR_ERR(file);
--=20
1.7.8.5


--------------010109090803060709020401--

--------------enig130E4C88D191990B88DA2ACD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEAREKAAYFAk96/VUACgkQgAnW8HDreRbUTgCgrTuRW1pCanpSDYdAk7fCd3vU
9fcAnRyS+/23a9/4cz9eN6io4B5Xyr5X
=uo8c
-----END PGP SIGNATURE-----

--------------enig130E4C88D191990B88DA2ACD--
