Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1GPNSK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 09:18:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57698 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053Ab1GPNSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 09:18:07 -0400
Date: Sat, 16 Jul 2011 23:18:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: build failure after merge of the staging tree
Message-Id: <20110716231800.62389022e6eef4b3456db52e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__16_Jul_2011_23_18_00_+1000_CJejqOlv6A=oj3Ri"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__16_Jul_2011_23_18_00_+1000_CJejqOlv6A=oj3Ri
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the staging tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from drivers/staging/gma500/backlight.c:23:0:
drivers/staging/gma500/psb_drv.h:34:22: fatal error: medfield.h: No such fi=
le or directory
In file included from drivers/staging/gma500/accel_2d.c:39:0:
drivers/staging/gma500/psb_drv.h:34:22: fatal error: medfield.h: No such fi=
le or directory
In file included from drivers/staging/gma500/gem.c:29:0:
drivers/staging/gma500/psb_drv.h:34:22: fatal error: medfield.h: No such fi=
le or directory
In file included from drivers/staging/gma500/framebuffer.c:36:0:
drivers/staging/gma500/psb_drv.h:34:22: fatal error: medfield.h: No such fi=
le or directory
In file included from drivers/staging/gma500/gtt.c:23:0:
drivers/staging/gma500/psb_drv.h:34:22: fatal error: medfield.h: No such fi=
le or directory
In file included from drivers/staging/gma500/intel_bios.c:24:0:
drivers/staging/gma500/psb_drv.h:34:22: fatal error: medfield.h: No such fi=
le or directory

Caused by commit 3caa89e93364 ("gma500: resync with Medfield progress").

I have used the staging tree from next-20110707 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__16_Jul_2011_23_18_00_+1000_CJejqOlv6A=oj3Ri
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOIY+IAAoJEDMEi1NhKgbsYpYH/iBxzf1MNAmyK21+8xkyDiWP
ythWx2SbPlhx+vg5EXOBxC4Ip8jCa5QsFmgAt58J+r7MI1P6PLOca1Qnt0FkAw9w
W2CPZ8MBbRDH+PVOr1F5PrL9rTLgBkSnW/CWGbmAqrTmf8DaYhXCe+FMzHn5CDjQ
d9gdqXyzRi5E8jhsgaO/DbckJFr8ElXAsnbTEn0OU+scsPKuzMKhRPxtoqn+Y+yY
iqqj+YDVpCsGY4iB2E5i+QRSoX/lyAq9FH7MJWzpgzvUIuzjrmB2Ak0ZDYlz1gsb
0+4Y34uhgNVIoXdYKu1ZQF8QqzvtcCb0iL3tp9rHaC+ugO3G8xrSYTb4/KI5R8o=
=kPsk
-----END PGP SIGNATURE-----

--Signature=_Sat__16_Jul_2011_23_18_00_+1000_CJejqOlv6A=oj3Ri--
