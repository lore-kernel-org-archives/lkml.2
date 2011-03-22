Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab1CVBOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 21:14:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49590 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227Ab1CVBOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 21:14:20 -0400
Date: Tue, 22 Mar 2011 12:14:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20110322121409.f4bb8a4e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__22_Mar_2011_12_14_09_+1100_/Nf1gwtrXq2PpJoF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Mar_2011_12_14_09_+1100_/Nf1gwtrXq2PpJoF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/media/media-devnode.c:40:28: error: linux/smp_lock.h: No such file =
or directory

Caused by commit cb3c186e31be ("[media] media: Media device node
support").  The BKL is no more ...

Why is a patch with Author date 2009-12-09 turning up in linux-next today?

I have used the v4l-dvb tree from next-20110321 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_Mar_2011_12_14_09_+1100_/Nf1gwtrXq2PpJoF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNh/fhAAoJEDMEi1NhKgbs6CwH/1Gt9pv17XASEG3cabQBJvAn
TfrAjfJQqkxmkO2yGZCfj2Glu++hGHMf0Qb6JTTo48hbMwhAXzgLnipKkw5I5lDw
mkG2jvUjNHkE2GNMBC0tqXh9EVjNQYK+R+eQg2fAjkIImGHZdF0ga908JzIBQwVl
f57rVkR6+z7Ecrh0vxCzJKcAe8b0Lr0hy+rYIVh3ntecQlNVXps1tzmbf+BR3h0S
2HqposYHN0jIp9vQJQbg7IOtDy0cNBCbB3SuqKiZIX3hTla27ZhkZ8Vlul93xqO6
cb5uyn6u7RVRIn0gBQP1w0WYMH4fRCXv5ZyX9mniIxa/FmQXa7IW8flUcX64y0Q=
=y28Q
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Mar_2011_12_14_09_+1100_/Nf1gwtrXq2PpJoF--
