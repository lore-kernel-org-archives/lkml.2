Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab0GEAjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 20:39:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33782 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab0GEAjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 20:39:47 -0400
Date: Mon, 5 Jul 2010 10:39:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the kbuild-current tree
Message-Id: <20100705103941.9b57282d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__5_Jul_2010_10_39_41_+1000_DVFNj1zrtR1XTcAT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Jul_2010_10_39_41_+1000_DVFNj1zrtR1XTcAT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

After merging the libata tree, today's linux-next build produced this
warning (but it should be a failure ...):

/bin/sh: scripts/setlocalversion: No such file or directory

Probably introduced by commit 0a564b2645c8766a669c55bde1f1ef5b0518caec
("kbuild: Propagate LOCALVERSION=3D down to scripts/setlocalversion").

That commit really isn't ready for inclusion in Linus' tree ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__5_Jul_2010_10_39_41_+1000_DVFNj1zrtR1XTcAT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMMSnNAAoJEDMEi1NhKgbsfM4H/jnInkBDEvjhXE7Zp38EmqSO
7J5cNWJv/XwKyaVjWthczZ1Fp0CFh/ViXVm0gG5KIBI5GaFj5zQsTRc1GmORye43
QRNxtCnqyW2N2s4YpI2hAO8w0GjCmVVUgYXmRaeY/sFaCrbVi3YPenltGdDhzXl4
bekdwGecdTEolGONq+kRchNAM49wrva6vue26uFXwu2KxNEHdxuTBF9VkNhcE7pn
HgqkBgcF5ZdBqifJTxe+szLz6C2Njw4BEEwKPZPu95X4BKRe41J938dgEBIs00qi
EXIySiwkCFQh0v3oGNhBQha87FeDoQKamWRBR3ISIBzR1onQJ9W5xPkRpe15xLo=
=ojAg
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Jul_2010_10_39_41_+1000_DVFNj1zrtR1XTcAT--
