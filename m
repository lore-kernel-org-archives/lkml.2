Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab0GFFZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 01:25:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47105 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab0GFFZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 01:25:40 -0400
Date: Tue, 6 Jul 2010 15:25:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Amerigo Wang <amwang@redhat.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>
Subject: linux-next: manual merge of the trivial tree with the v4l-dvb tree
Message-Id: <20100706152529.371c7800.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__6_Jul_2010_15_25_29_+1000_y+MAoYv=qgM/3_Se"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Jul_2010_15_25_29_+1000_y+MAoYv=qgM/3_Se
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/media/video/ov511.c between commit
b2bde15c455d09057dc7bd9f5b9ed67b9ac99b8a ("V4L/DVB: Remove obsolete ov511
driver") from the v4l-dvb tree and commit
421f91d21ad6f799dc7b489bb33cc560ccc56f98 ("fix typos concerning "initiali
[zs]e"") from the trivial tree.

The former just removes the file, so I removed it.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_Jul_2010_15_25_29_+1000_y+MAoYv=qgM/3_Se
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMMr5JAAoJEDMEi1NhKgbsffkH/1VTqWg02opeAa2gadCIgx8K
2na3kFS9Z93PibQ3aeYF6+1B7OPtUtqJknN82OT7WJtAnobjndAPm6Wws8FtjSg1
gYsZMKT2kE5IiXksSZQ1lrLW03+QOA2jop5I6UbKC6sUxrPrQO+HKiDyAtYxxH9m
oZigpCDUGAJc//rmkOCLi+Cik6LVldlmddMfW4t61iMWCTK+v4wo9tAxexCijA3j
xZk8HWJ1P5XSZpipx3l5R32aU+vPdWxH/vpvuohbVtf2lIk8zYjfCZ2KIplYPZQR
rGJJT53Sp2Ww4opaJoEZ3i2tQmKaEX7bTL0Jgv6dyU+qesedkw1Nco2+/6isMHE=
=iMqx
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Jul_2010_15_25_29_+1000_y+MAoYv=qgM/3_Se--
