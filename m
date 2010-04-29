Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab0D3Rcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:32:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36096 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758555Ab0D3Rcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:32:36 -0400
Date: Thu, 29 Apr 2010 15:49:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?IkZyw6lkw6lyaWMgV2Vpc2JlY2tlciI=?= <fweisbec@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the bkl-ioctl tree with the bkl-procfs
 tree
Message-Id: <20100429154954.84966e61.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__29_Apr_2010_15_49_54_+1000_RF0jtTdhfiSd5FrH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Apr_2010_15_49_54_+1000_RF0jtTdhfiSd5FrH
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Fr=C3=A9d=C3=A9ric,

Today's linux-next merge of the bkl-ioctl tree got a conflict in
drivers/char/i8k.c between commit
64ef834551d7696f54553d7608eba80a5a800e77 ("procfs: Push down the bkl from
ioctl") from the bkl-procfs tree and commit
59ce88717d9d8af8cb14af3a0a505cafb692b482 ("drivers: Push down BKL into
various drivers") from the bkl-ioctl tree.

I used the version from the bkl-procfs tree for today.

Can you guys please sort out these various bkl removal trees, please.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__29_Apr_2010_15_49_54_+1000_RF0jtTdhfiSd5FrH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvZHgMACgkQjjKRsyhoI8x/XQCePei03lEkFKKn9oBbisG8epUB
Xq0An3mV45lfwl66q0bNW4u7ALnLKwkB
=02In
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Apr_2010_15_49_54_+1000_RF0jtTdhfiSd5FrH--
