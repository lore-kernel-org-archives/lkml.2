Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab2FHEEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 00:04:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34159 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab2FHEEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 00:04:01 -0400
Date: Fri, 8 Jun 2012 14:03:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the sound-asoc tree
Message-Id: <20120608140358.74bf0efedbfe393d42ab732d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Jun_2012_14_03_58_+1000_/F_ysBJ1z_2quWiX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Jun_2012_14_03_58_+1000_/F_ysBJ1z_2quWiX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

sound/soc/soc-dapm.c: In function 'dapm_clock_event':
sound/soc/soc-dapm.c:1022:1: warning: control reaches end of non-void funct=
ion [-Wreturn-type]

This is with CONFIG_HAVE_CLK not set.  Introduced by commit ec02995adad5
("ASoC: dapm: Bodge for lack of a widely available clk API").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__8_Jun_2012_14_03_58_+1000_/F_ysBJ1z_2quWiX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP0XmuAAoJEECxmPOUX5FE0NwP/Ra18PIn0zZ3H8Q4o6CG1YMa
qz/JeknF+Ec3Etja1tWFH+CtiKIl2uY8ixSmxaaLOb0CgA89sr/AbXy1YKrCb5CX
+DaPi1A+1yVXmQBPr/U4JfhRghipbsDh8/qPSO3mFTpbEYaGDe3hpmYMJUszJL2j
Bd7har0Vtg7IykR8DykOZwVHA3bNiqOSgVoPThwAZZgCLgCJ6A1PnZLZGH2aKStP
jWMrNF6x9rVJteaCC6uUjPYY9ZbFKaKJxJX2RrkPMaKyUjLDWKXtowy60gl38tfF
G/roA6TmI7bcSoeV69Ozi8l2pCVUxEzzp91amQl9/4XKs4wUdAhrmKGcsg6K0dqm
5AShx4r9APZcGun73xI9Lsqny6jlNogiGSijMgphBPkJSF97oB/TL60zlrtMOfi9
N8J8XBwEWxPzUnwQ59UyVeFRz6wPsKqpRGOr863w5KnHXnhi1RhKsSlTT/G2Z73/
AAntZYeBOYajyCTGhj6CPYbrg8Pu7nSSh91WkDL2gOFKmRFiDpMEOdzVwAUzwGSM
Nu+bT7Xbbc852A+NO2NTS7gser3FuaslK1cti4DnKfhtvZVXnZMHXDDl1bKEHcI5
FqzLYezjVQwMN8KLZjJihQ4ZYrJ8orDYLb1FS3O8GuFprPkKUJ17LRR626Mv1yrR
0Cp88B+nNYGaRqw0Kbei
=p8Ed
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Jun_2012_14_03_58_+1000_/F_ysBJ1z_2quWiX--
