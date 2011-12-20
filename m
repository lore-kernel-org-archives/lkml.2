Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab1LTDU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 22:20:56 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:54038 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1LTDUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 22:20:54 -0500
Date: Tue, 20 Dec 2011 14:20:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Dec 19
Message-Id: <20111220142048.eeccb51ed290d8223ba2c580@canb.auug.org.au>
In-Reply-To: <20111220015235.GB8290@sirena.org.uk>
References: <20111219185556.f07c1f43e28cfd594aaa5fe0@canb.auug.org.au>
	<20111220015235.GB8290@sirena.org.uk>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__20_Dec_2011_14_20_48_+1100_Ee3fqmksr.KacI2m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Dec_2011_14_20_48_+1100_Ee3fqmksr.KacI2m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Tue, 20 Dec 2011 01:52:35 +0000 Mark Brown <broonie@opensource.wolfsonmi=
cro.com> wrote:
>
> On Mon, Dec 19, 2011 at 06:55:56PM +1100, Stephen Rothwell wrote:
>=20
> > The regmap tree still has one build failure so I used the version of the
> > tree from next-20111214.
>=20
> Please tell maintainers if you're doing this.  What is the issue here?
> The only thing I can think of is the broken GPIO driver that got merged
> some time ago without its dependencies which you were (much more sanely)
> flagging as broken.

Its this:

> drivers/mfd/da9052-spi.c: In function 'da9052_spi_probe':
> drivers/mfd/da9052-spi.c:42:2: error: 'da9052_regmap_config' undeclared (=
first use in this function)
>
> Caused by commit cfe04478fa1b ("MFD: DA9052/53 MFD core module add SPI
> support v2").

Which I reported to you on Dec 15 (along with another build error in the
regulator tree that you have fixed).  You even created a patch to fix it
(Subject: [PATCH] mfd: Declare da9052_regmap_config for the bus drivers)
but that has not appeared in your tree yet.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__20_Dec_2011_14_20_48_+1100_Ee3fqmksr.KacI2m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7/8QAAoJEECxmPOUX5FE/DMQAJ1vg1af3Qti0d6n8ShjyiS/
XK3wrggsDmYyoRQr7IyiYYpSMI0ymaqGXeUX0Muy1U8yxY/3IzZfwdI0uSSo5k7N
8u4/Cb+LScot5/qjtuUKIodYZlJ3v8v8pBBGl0EKTxQ5ZuLsnIh0DMPmf/9uGu3z
fsy/tRL+TJqnC3iWWJ3El/8yAA1+Zljmee7W0NoAAoObkwH3mcIiZzBsGAb0u/jJ
Ly4YleZ2rivWYKi3FUR8tTCqB2qpQviCCaw979Ta1YK/OHUUv+Vf0avPuDgYgUeN
bGUC4ZIKE4X5+VMBdz/+5WcnYi84uVYi6AAAVlv4k2lHpeYF/SwBG1DxmKXNaR5h
jLI889ktW8h2c7KBTuDTy8CuumGcYo8j+Y32+x6yhyrQrzeB7n0r2ku0Ur/FkK9k
7C6qLMKwhzE+Nzav7ZtFrkcQyenY13DqGutTTUsPn5DOTFHMhFS21XzT2O3pL0sp
vDpt7YruOfBle4CdMlAHk8S8yJ7mqK1GB18yIcf6UEIGwC1iD7rfCMg7tRHy4mWW
umpMMoI07/qpd+E4bvysa42yNq9Wh5dcbZXYsQUxLgcXPPLXs2mLDGpUKbilA2BZ
EuJG7sMoZ/OG+UHGb++lhwyK7nVAkl/ajKio8MnW/WZoodxE4G1plmtapaQgclDv
XZdeUGFRXE1bMTeEMTwA
=5yDd
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Dec_2011_14_20_48_+1100_Ee3fqmksr.KacI2m--
