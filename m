Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320Ab0LUBBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 20:01:34 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53008 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388Ab0LUBBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 20:01:32 -0500
Date: Tue, 21 Dec 2010 12:01:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>, Jens Axboe <jaxboe@fusionio.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, stable@kernel.org
Subject: linux-next: build failure in Linus' tree
Message-Id: <20101221120123.93838d16.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__21_Dec_2010_12_01_23_+1100_xOSrSwU4CX0QNL+J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Dec_2010_12_01_23_+1100_xOSrSwU4CX0QNL+J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

While building Linus' tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/block/cciss.c: In function 'cciss_revalidate':
drivers/block/cciss.c:2839: error: expected ';' before 'if'

Caused by commit 0fc13c8995cd96f4123de400c71c223d80400ed9 ("cciss: fix
cciss_revalidate panic").  Was this even build tested?  More care
required.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__21_Dec_2010_12_01_23_+1100_xOSrSwU4CX0QNL+J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJND/xjAAoJEDMEi1NhKgbsDxQH/1dK3LyHXZcizXnVKSHBmZtQ
GgHNhhYosADK7u2ePmiPEKhpuAUiiIdxs3KvuJz/GoVC3ocAcvX6u/DG7qY/c5sW
wGeu4lyNeajQbZJvYH+lb2TsfC5QEpJdqzWAHxSNkj78uh5rBs5MXrahxJuD8Puo
XDeTHaEKU3D/6FubxtYjwhMejBLcEQmxOdZc+RKiaZ3k8No1wXjE52A+EJutmBrK
lm2K2Px5kNguJGib1YMRh0NVW0zr74i1+TsRRBI/JIJu5T4vrhAkEPfMMDfbmlsC
VNDvubrE1Plo8c4+YlOYDE/K+mYarNTgc/NrMxd7wmcNGEd7w8vg0QvN63ZB/68=
=vjeU
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Dec_2010_12_01_23_+1100_xOSrSwU4CX0QNL+J--
