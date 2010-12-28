Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab0L1F02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 00:26:28 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48933 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab0L1F01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 00:26:27 -0500
Date: Tue, 28 Dec 2010 16:26:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: linux-next: manual merge of the bkl-config tree with the v4l-dvb
 tree
Message-Id: <20101228162615.f94b1478.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__28_Dec_2010_16_26_15_+1100_p.zK.WV..c/Sk_7s"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Dec_2010_16_26_15_+1100_p.zK.WV..c/Sk_7s
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the bkl-config tree got a conflict in
drivers/staging/stradis/Kconfig between commit
aef01debdfad83ab71a83b7af8cd90203404c1aa ("[media] cpia, stradis: remove
deprecated V4L1 drivers") from the v4l-dvb tree and commit
f2fed18d2a61afa5592b3002407e432c689c33f4 ("staging/stradis: mark as
"depends on BKL"") from the bkl-config tree.

The former removed the file that the latter modified, so I removed the
file as well.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__28_Dec_2010_16_26_15_+1100_p.zK.WV..c/Sk_7s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNGXT3AAoJEDMEi1NhKgbslzEH/16OgmTfRxV+CYUS3063t1+z
IIFeHoPqtjNwXhIED8NNpQSm5OeaBtyF6A7Anr1wHA50VFcR58MweOBZWcJl7rKO
me5bkYoRnoy/Wefy1faU3xxytqB8S8B2mKjES/BQDzTbNQxaRmvc8EjSYcMghyAS
WbMuT1s2PLb/Suh4c23BFgkvWkS69ZHT+62qIsCWm364aUQrpzK3g0WsHVr0Ht7C
gkuKfgUHnbfEjWlk2LG3Xzs6E0Zrwqhn+wTwCFRYsLjE0LShgzWILQ3XqaBE0YUC
L3EdtrmqNWcps4fgCCPryPkdnQsZ9gd8EL+fgQoMNqIOhrLbrhkGbh64Ndd/aZM=
=inRo
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Dec_2010_16_26_15_+1100_p.zK.WV..c/Sk_7s--
