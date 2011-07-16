Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab1GPMhE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 08:37:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46569 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab1GPMhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 08:37:00 -0400
Date: Sat, 16 Jul 2011 15:07:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20110716150741.a2ed85a4f7addcfccedf16e7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__16_Jul_2011_15_07_41_+1000_VlcaVhL8=j1Kfr+Q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__16_Jul_2011_15_07_41_+1000_VlcaVhL8=j1Kfr+Q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the arm-soc tree got conflicts in lots of
files due to commit 7712eeac230b ("arm-soc: remove rmk/for-next merge")
from the arm-soc tree (and maybe some others).

Arnd, is there some way that you can rebuild (rebase) your tree without
the merge of Russell's tree and the consequent revert of that merge?  It
is likely to revert a whole swath of changes from Russell's tree :-(

I have dropped the arm-soc tree for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__16_Jul_2011_15_07_41_+1000_VlcaVhL8=j1Kfr+Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOIRyeAAoJEDMEi1NhKgbstGsH/jzM7OTNHybruh2gJYTDHFS+
6iuNIhqB68r10yHihz7IWpZIrNI9MLcQ/RMGQ428KoUFMnXGaMZatBuf6R48Jxxf
X9orITBeZqSP040nUTyjvYq/KBtJXmEsIfVJyVnmSV3AElnRBYksA3ua6geX2w0p
70YpPHG69lAlD4IT8GoeJ5zGn3vZMX5n4t2pczAQ8XEieWD7tSk4NxnzX5R1NdhR
6nnfhvXZ2kNGROMPtDLnxzsdcXyZWjBK6+SJEURZ5ykcin9pWdV4M6gCBMYg+AEZ
1tKB56yTMy+aKpmyZbhCdPIS6QTkKkFiP++QAfzM652vhDcHXp3GFKMVNdOf98Q=
=ugcT
-----END PGP SIGNATURE-----

--Signature=_Sat__16_Jul_2011_15_07_41_+1000_VlcaVhL8=j1Kfr+Q--
