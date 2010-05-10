Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab0EJA3d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 20:29:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41599 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab0EJA3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 20:29:31 -0400
Date: Mon, 10 May 2010 10:29:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?UTF-8?B?IkJqw7hybiBNb3JrIg==?= <bjorn@mork.no>
Subject: linux-next: manual merge of the v4l-dvb tree with Linus' tree
Message-Id: <20100510102924.cb973cfc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__10_May_2010_10_29_24_+1000_/=5Fu5RjjJwEBEQY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_May_2010_10_29_24_+1000_/=5Fu5RjjJwEBEQY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
drivers/media/dvb/ttpci/budget.c between commit
6f550dc08369ee0bc6402963c377e65f0f2e3b71 ("V4L/DVB: budget: Oops: "BUG:
unable to handle kernel NULL pointer 	dereference"") from Linus'
tree and commit 2bf92108b679637c2e50114f4c655d7cc608a1d9 ("[v2, for,
v4l-dvb, 	master] V4L/DVB: budget: Oops: "BUG: unable to handle
kernel NULL 	pointer dereference"") from the v4l-dvb tree.

I just used the version of that file from the v4l-dvb tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__10_May_2010_10_29_24_+1000_/=5Fu5RjjJwEBEQY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvnU2QACgkQjjKRsyhoI8w1xQCeKTP6EAt36n0wqJI8OLDm6Qtb
XlsAoJ/xDpVNtmBYm24zSyX+aCDMcyfa
=2ggq
-----END PGP SIGNATURE-----

--Signature=_Mon__10_May_2010_10_29_24_+1000_/=5Fu5RjjJwEBEQY--
