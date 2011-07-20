Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab1GTNsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:48:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44232 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab1GTNs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:48:28 -0400
Date: Wed, 20 Jul 2011 23:48:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 20
Message-Id: <20110720234817.fdc50eadf3ae775e89642689@canb.auug.org.au>
In-Reply-To: <20110720130220.GA2406@sirena.org.uk>
References: <20110720180041.5774ca335e6697c17374dca5@canb.auug.org.au>
	<20110720130220.GA2406@sirena.org.uk>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Jul_2011_23_48_17_+1000_yc6NyIy1S2gZZqQz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Jul_2011_23_48_17_+1000_yc6NyIy1S2gZZqQz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Wed, 20 Jul 2011 14:02:21 +0100 Mark Brown <broonie@opensource.wolfsonmi=
cro.com> wrote:
>
> On Wed, Jul 20, 2011 at 06:00:41PM +1000, Stephen Rothwell wrote:
>=20
> > The regmap tree lost its conflict.
>=20
> What was the conflict, OOI?  I didn't notice anything.

It was just a simple conflict against the spi tree in
drivers/spi/Makefile that I probably didn't even report.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Jul_2011_23_48_17_+1000_yc6NyIy1S2gZZqQz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOJtyhAAoJEDMEi1NhKgbsym0H/A00FTvY/Lp9Ov6W5kC72yDi
l708UBbOLDyzbX/h7kw0ts5h58KgSPqtiJaTF9q+Pd4uWqum9GBcuXsOIme98BbB
o1s1LKXaV2RqjN9emYvDoN9FsgGFJy+rPzi4ER6W5PatglL5aKUd1ifHOf7UNUF8
TkXKOn02E6tMniQ39sHR0fm+4grRf8UJ+2WocXFDZkqPSt2mZWMHh4gqCNcuW5qi
vuUPPNmCWZ/gl/m6UR74hIr8SEfWCkU75kD3xKk/DztgPO8QhHB81b9UKsPswJAD
sRq2ez9LXIQFRiDG5P5gIB5Yz2Uxmtse6t4q7jYFFDnCdigFripUvON64jG/LoQ=
=+Fkl
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Jul_2011_23_48_17_+1000_yc6NyIy1S2gZZqQz--
