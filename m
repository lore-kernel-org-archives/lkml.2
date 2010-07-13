Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab0GMB2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 21:28:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46115 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab0GMB2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 21:28:20 -0400
Date: Tue, 13 Jul 2010 11:28:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>
Subject: linux-next: manual merge of the genesis tree with Linus' tree
Message-Id: <20100713112814.39dbd280.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Jul_2010_11_28_14_+1000_YHJk2XcfKUh0bnz0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Jul_2010_11_28_14_+1000_YHJk2XcfKUh0bnz0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the genesis tree got a conflict in
arch/arm/configs/ap4evb_defconfig arch/arm/configs/g3evm_defconfig
arch/arm/configs/g4evm_defconfig between commit
07a8c03f3e06129e847acd068b8b89c13357ee64 ("ARM: reduce defconfigs") from
Linus' tree and commits 4a539a2023fd2f7384916ef6e7777ad234a00dcd ("ARM:
mach-shmobile: update defconfigs") and
1ddb76fd29da170d77d70b94cdcba74b0d935152 ("ARM: mach-shmobile: update
ap4evb defconfig for MMC/DMA changes") from the genesis tree.

The changes are far to extensive for me to fix up, so I have used the
versions from the genesis tree for today.

Paul you should merge in Linus' tree (or rebase) and use Uwe's script on
your updated config files ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Jul_2010_11_28_14_+1000_YHJk2XcfKUh0bnz0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMO8EuAAoJEDMEi1NhKgbsvYsH/0jcvtLbOnxZEg7kX7SkKEeY
KDxTEDZ14r0B8iXJJNZ1KSwkFe9TlDAG//Ghm+o50YPp9kKXj0YzuOMDAnfqncwA
/1HltJeInSQLaF8U/u0T4+xNom9sB1pTVu/v56HFQCX036hyrhgpUbIij1/JkFj/
RyGaENy+ber/0xExGhJ+swWweQOVfjl9OBbNxhQj8+R/IoLBtpcOuEHiYSr3lR8U
2hEfpPlv+AgWnEgJyFde8IHQJiMJvlCXjFaCmHL+YAQ9nZKdgIU4zWp5x9aNrq60
lp9wkceWyAKsZQZtR3govUMboL/D8euF6x/uIKtBCG47FySiOkgxLmrdEbcFIxk=
=yfp/
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Jul_2010_11_28_14_+1000_YHJk2XcfKUh0bnz0--
