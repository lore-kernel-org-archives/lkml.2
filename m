Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab1GDDFo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 23:05:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35507 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362Ab1GDDFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 23:05:40 -0400
Date: Mon, 4 Jul 2011 13:04:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20110704130442.c4125fd9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__4_Jul_2011_13_04_42_+1000_pCe9Of1zK+pO0WrI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Jul_2011_13_04_42_+1000_pCe9Of1zK+pO0WrI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "vb2_dma_contig_init_ctx" [drivers/media/video/marvell-ccic/cafe_cci=
c.ko] undefined!
ERROR: "vb2_dma_contig_cleanup_ctx" [drivers/media/video/marvell-ccic/cafe_=
ccic.ko] undefined!
ERROR: "vb2_dma_contig_memops" [drivers/media/video/marvell-ccic/cafe_ccic.=
ko] undefined!

I have used the v4l-dvb tree from next-20110701 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__4_Jul_2011_13_04_42_+1000_pCe9Of1zK+pO0WrI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOES3KAAoJEDMEi1NhKgbs1X0H/jlgAM+PwePx5VN6QqlVfJrN
/i8mud9DnCGpXSTH9bnyw1ZFz+V0yBDGofpZyLggB180zHt0H0N91r7B6Ah1MR43
44nXY+foD1HhkdXElMybanHnEJEl1n3Ib++yHovOG2VYRozpQfaKyvZl/SIoaYQc
FxdybYkHwZBJhmJL/ATtT42h/n/C8nHdjvOV5gN2clcmxJ1bwa+4apU0FlxyMaQU
OGglYpfoLVK3lJs+f0kjoKE1N2FlqLwZX1jpBUNIWExoet/66stgr9QQU/sgLJC4
EOjdyzId31VKdQ9pOA2Qmv75qnhz1A/3XzIZK0wZVaJcffBzrVLCTYtXgqESK6U=
=OMqW
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Jul_2011_13_04_42_+1000_pCe9Of1zK+pO0WrI--
