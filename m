Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab1LFWkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:40:00 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:59959 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab1LFWj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:39:58 -0500
Date: Wed, 7 Dec 2011 09:39:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: unable to fetch the arm-current and arm trees
Message-Id: <20111207093949.14b5f8f894a696e69d326460@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__7_Dec_2011_09_39_49_+1100_0Dpm3rhuiJqTD4xo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Dec_2011_09_39_49_+1100_0Dpm3rhuiJqTD4xo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

Trying to fetch the arm-current or arm tree this morning produces this error
(after a long time waiting):

error: RPC failed; result=3D18, HTTP code =3D 200
fatal: The remote end hung up unexpectedly
fatal: protocol error: bad pack header

I am fetching from
http://ftp.arm.linux.org.uk/pub/linux/arm/kernel/git-cur/linux-2.6-arm
(branches fixes and for-next).  Can you check that the repo is ok and the
that "git update-server-info" has been run?  Alternatively, is there any
chance that you could set up a git daemon?=20

I will use what I collected last night.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__7_Dec_2011_09_39_49_+1100_0Dpm3rhuiJqTD4xo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO3pm1AAoJEECxmPOUX5FEt5sQAIFD0sLmRnWUUGWDTYY+YGP5
8jIcB1/k94ehTleca7eAVr6LkGohatJJOrVChAUKEsmIspyaPYlUed2l44Zzdo32
gKYfWQY4RIns8liQJvcy7069BpBLIVoBRd1X7Sa+cY2c02JJHbqCiB2qyuMaliio
kgZIUqFEo6AV+hWffo6thSyKrqB09ZITu2SzcF3+8NutKIffiPWygB82RYW8ZvHo
7za/9LV/xNGCoWBbECg3G/QDrM6Ied4/pAQkvJgQlA8wdOxouurqGkTz5IF1htJd
zroIlxTuk+DoO1sXWH1R84CFhOC9Kvcm4DIOld92GvAVewEohishFUSWqI0AB7A1
7HUUvAu3tDwBAJLbiPVXyarlul9g4w2mjbe5p/8BGUen3nq5Wp75oPQQibRUV8SU
w3+t38lk7Ului4CDjJvB9Tbmb6ILfnpsWlbKlQCicoOEgOUTDzjBw3o2mLbr9N9V
vbPBmopjZkCbhlEot0PZGoBpcli9E5QhfDNOOgT5ZuMnaPqH0Nh5jLfPU+RHl9/C
2+srqoBCSpQ9mVo+QXvEnaj9H/ryADpx4GbAshoE3t5gdIFf21P0kCAqfec/RQEM
gJHHP7fOpi1y4U9WknfUFzL/moIThc1o20BIaSZnlLBPm2Zd5OTdiguXPwk5Ow1m
czLNUwfLudteFsZVg7zn
=CEcd
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Dec_2011_09_39_49_+1100_0Dpm3rhuiJqTD4xo--
