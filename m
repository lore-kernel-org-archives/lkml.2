Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab1AWWxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 17:53:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52506 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab1AWWxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 17:53:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=cXzo5tlPNfGOHPy5JNd1440wD/toYN4tP1ngnqacZcfVslZ/IdUDv1Qtcr+9NT4ewl
         PbBM704JqhHMCcERBltdB+flUGzcI4UU4q9y+p8Fk8L56rz3l5Xf9AOfOKev9EspugCO
         VKyxVL1JaRLctfXKLLxqwbxUFau5lplNmri5A=
Date: Sun, 23 Jan 2011 17:53:42 -0500
From: Tracey Dent <tdent48227@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Kernel: gcov: Makefile: Use proper ccflag flag in Makefile
Message-ID: <20110123225339.GA1435@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Use the ccflags-y flag instead of EXTRA_CFLAGS because EXTRA_CFLAGS is
deprecated and should now be switched.  According to
(documentation/kbuild/makefiles.txt)

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 kernel/gcov/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/gcov/Makefile b/kernel/gcov/Makefile
index 3f76100..e97ca59 100644
--- a/kernel/gcov/Makefile
+++ b/kernel/gcov/Makefile
@@ -1,3 +1,3 @@
-EXTRA_CFLAGS :=3D -DSRCTREE=3D'"$(srctree)"' -DOBJTREE=3D'"$(objtree)"'
+ccflags-y :=3D -DSRCTREE=3D'"$(srctree)"' -DOBJTREE=3D'"$(objtree)"'
=20
 obj-$(CONFIG_GCOV_KERNEL) :=3D base.o fs.o gcc_3_4.o
--=20
1.7.4.rc2


--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNPLFyAAoJECZLfNMSiLYCDa8H/Rynqy+0LRfKuycjy7VLFN+c
jEM4Ri69ayS1U2U8X3Dsy03DJjC/mI8LCwC9+NoAq34lXh9OzWLC8eSmyXd1bOoo
pwuSK43Sv8FpW2SxQe6iTKZ9gP3rIFjX4HD0XnQRC8FLHdrE+g2Bbw5+CvLgo+l8
+k0FJELIBxHGjZHZPJOpxrhn9Xjs1Bkp3EwPTeSIBjkkFaK74kvSwNGoakuO5sJ/
3HWT36/ZNDgtfAmT6yYQ+lHyr5N+m9DLB6pHkXpJaRm2JkefsNpN0tHsQMciDiyh
WpY8eVgHpglgjpecTaFHXQq6nbwLThwQ+OxSN5L3ZBS2SYIHydgPWVH+GhYcrFI=
=P8cf
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
