Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab0L1ApF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 19:45:05 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39137 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab0L1ApE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 19:45:04 -0500
Date: Tue, 28 Dec 2010 11:44:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>
Subject: linux-next: manual merge of the trivial tree with the v4l-dvb tree
Message-Id: <20101228114451.a24d0ead.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__28_Dec_2010_11_44_51_+1100_ouHsf6yw/o9G2ibR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Dec_2010_11_44_51_+1100_ouHsf6yw/o9G2ibR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/media/video/zoran/zoran.h between commit
8221f9b5fa3e08ba35378f08f2a606156e685916 ("[media] zoran: remove V4L1
compat code and zoran custom ioctls") from the v4l-dvb tree and commit
b595076a180a56d1bb170e6eceda6eb9d76f4cd3 ("tree-wide: fix comment/printk
typos") from the trivial tree.

The former removed the code modified by the latter, so I used the former.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__28_Dec_2010_11_44_51_+1100_ouHsf6yw/o9G2ibR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNGTMDAAoJEDMEi1NhKgbsTF8H/3wDcXmIwNa6wrlbOxaKsbfQ
Px+bKKu8yphPxmEyzBjM+m2RO93Ts5ltnB1d9ZVb5Z+wkRJfhY2JIKBH80O5iqOy
4Cwo1fDLl3XfMLOyNk9R9Bs2TRWGe7h+wFUn2KwHF7123eqgGWPBWgpLivPoSyx0
55i2Q6oJruq80dgBgehx0IoZ3+SmDJhwKGimMmF6E7wQCuHEG7w0pgc1yoDoUbIK
OFv9QYVdAc2GtBk1NTLVfgIff/G6+50mosr0+lwepv/J+u2JnrMdI3BFDIEckeuD
P0l9dl1Y6SrUkGDhviUrdrKoA+rsckzgpN7bKtvtjEYCROjEkScwVATnX2ezLGo=
=zjms
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Dec_2010_11_44_51_+1100_ouHsf6yw/o9G2ibR--
