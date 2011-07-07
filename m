Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab1GGFmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 01:42:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42281 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab1GGFmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 01:42:31 -0400
Date: Thu, 7 Jul 2011 15:42:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Axel Lin <axel.lin@gmail.com>
Subject: linux-next: manual merge of the staging tree with the ux500-core
 tree
Message-Id: <20110707154223.d7ecda2a6cc84e033bb0b26a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__7_Jul_2011_15_42_23_+1000_S_rn4UPX4EFpDgMW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Jul_2011_15_42_23_+1000_S_rn4UPX4EFpDgMW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
arch/arm/mach-ux500/board-mop500-u8500uib.c between commit 0df7aaf0f276
("mach-ux500: fix build error due to unknown 'regulator_en' field") from
the ux500-core tree and commit 857f727674f4 ("staging: ste_rmi4: remove
cross-dependent platform data") from the staging tree.

The second supercedes the first, so I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__7_Jul_2011_15_42_23_+1000_S_rn4UPX4EFpDgMW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOFUc/AAoJEDMEi1NhKgbszIsIAICL1QbMwT5auuSfqN5uJD/r
gTdzQQGsUf90fm1cQev6+QjCkZexWBeWDEJWyDTAMsIM6VSOdhfraii4TM6UeoSm
GWJzP2eZKwULwH8NO2h4lsZ+bEqS8E8ZxalBktPQAISB1CkIp0/aM7uUV1DUhCIR
StHIYvgJPoygrV+5wnm4PY9Vp5SpVrcHhV8T4xNWRF56OWulvYBpd9CneoEY5n4C
7k5BLR/zLFhAXbez39OJG6RGR7aQhpfx8uTvOGgPicke9s1VUIEO6RVQhtPTkvPU
gflYytf7xZt7xk2mZ4cCLe6SwJ1anzSJpPxtwW12rlqESha+0uekzVNbFNoNt+I=
=WQ0Q
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Jul_2011_15_42_23_+1000_S_rn4UPX4EFpDgMW--
