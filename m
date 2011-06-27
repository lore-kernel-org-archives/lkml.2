Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab1F0Fh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 01:37:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49056 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756447Ab1F0Ff3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 01:35:29 -0400
Date: Mon, 27 Jun 2011 15:35:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
Message-Id: <20110627153522.8884b125.sfr@canb.auug.org.au>
In-Reply-To: <20110623152535.e9ec4ad2.sfr@canb.auug.org.au>
References: <20110623152535.e9ec4ad2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__27_Jun_2011_15_35_22_+1000_PG1115==keTrKek0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Jun_2011_15_35_22_+1000_PG1115==keTrKek0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 23 Jun 2011 15:25:35 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>=20
> drivers/net/can/sja1000/sja1000_of_platform.c: In function 'sja1000_ofp_r=
ead_reg':
> drivers/net/can/sja1000/sja1000_of_platform.c:61:2: error: implicit decla=
ration of function 'in_8'
> drivers/net/can/sja1000/sja1000_of_platform.c: In function 'sja1000_ofp_w=
rite_reg':
> drivers/net/can/sja1000/sja1000_of_platform.c:67:2: error: implicit decla=
ration of function 'out_8'
> drivers/net/can/sja1000/sja1000_of_platform.c: In function 'sja1000_ofp_r=
emove':
> drivers/net/can/sja1000/sja1000_of_platform.c:81:2: error: implicit decla=
ration of function 'iounmap'
> drivers/net/can/sja1000/sja1000_of_platform.c: In function 'sja1000_ofp_p=
robe':
> drivers/net/can/sja1000/sja1000_of_platform.c:113:2: error: implicit decl=
aration of function 'ioremap_nocache'
> drivers/net/can/sja1000/sja1000_of_platform.c:113:7: warning: assignment =
makes pointer from integer without a cast
>=20
> Since this file has not been changed recently, I suspect that this was
> caused by commit b7f080cfe223 ("net: remove mm.h inclusion from
> netdevice.h").
>=20
> I have left the build broken for now since it is also broken for other
> reasons.

I am still getting these, is there a fix pending?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__27_Jun_2011_15_35_22_+1000_PG1115==keTrKek0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOCBaaAAoJEDMEi1NhKgbsBfcIAKLSIowpnsalVOdo8ytKEw3R
pok9RIOUUhXc56F26jW6Ac/v6FlHxPMWRAJITk+8o8CSvEZ5ub6dQj+Pi0UTedsP
eYGTTltE21cQstFzDP6nKf5r4ChZAxb6K+ROMCrHgInDbN+KPW/c3PoELiWOmjmS
c/wzV/a0twgnFG7UXABFcKoAjaGavbO5uvPfb5stCfQmzt9QRx8qqomCv50qh2XT
g6ByEIJLdzK6g3GMpA+J7QDnlwfehCfHH9gFEDoP/elRbi2/rDvz4rZH4d03/7ii
WAT9HKcMHfcvvZ+gw8pUzQgs2Qjk8U2izNl1va7Tspjp45pUNOniDgk4uXQym1U=
=ZBJV
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Jun_2011_15_35_22_+1000_PG1115==keTrKek0--
