Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab0IZATW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 20:19:22 -0400
Received: from imp01.mtu.ru ([62.5.255.10]:35608 "EHLO imp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459Ab0IZATV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 20:19:21 -0400
To: linux-kernel@vger.kernel.org
Subject: autofs_root_unlink() declared but not defined
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc
X-Face: $dO4505L-bM3\Iz"(
 =?utf-8?q?V=3Dy=2EbL/75=7B5ys3=3AB=5B-aPBQvs*Z=25fdBqFhvc85hmZN4j1kwRzwvY*?=
 =?utf-8?q?R=0A=094=09nvQ/=23/+kWXH?=((aXWh\%mvG1V()Z0k:NwZAIu\S0d1%,nv`^
Date: Sun, 26 Sep 2010 04:19:09 +0400
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1704021.ECmpdQc2Cx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009260419.18477.pavel@pavlinux.ru>
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1704021.ECmpdQc2Cx
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


  autofs_root_unlink() declared but not defined if not CONFIG_COMPAT


latest git=20

=2D-- cut ---

diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index 11b1ea7..0c4ca81 100644
=2D-- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -27,7 +27,9 @@ static int autofs_root_unlink(struct inode *,struct dentr=
y=20
*);
 static int autofs_root_rmdir(struct inode *,struct dentry *);
 static int autofs_root_mkdir(struct inode *,struct dentry *,int);
 static long autofs_root_ioctl(struct file *,unsigned int,unsigned long);
+#ifdef CONFIG_COMPAT
 static long autofs_root_compat_ioctl(struct file *,unsigned int,unsigned=20
long);
+#endif
=20
 const struct file_operations autofs_root_operations =3D {
        .llseek         =3D generic_file_llseek,

=2D-- cut ---

--nextPart1704021.ECmpdQc2Cx
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkyekYYACgkQOqfDywN0JIkIJwCgiZOu2DaufKp3fPja0+WZDkwQ
PQsAn3bFFG0qXFmkM2t83BVsZbQa6jM6
=aYQf
-----END PGP SIGNATURE-----

--nextPart1704021.ECmpdQc2Cx--
