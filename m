Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab1DDJ4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 05:56:47 -0400
Received: from smtp209.alice.it ([82.57.200.105]:54816 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab1DDJ4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 05:56:46 -0400
Date: Mon, 4 Apr 2011 11:56:31 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-mmc@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
        Daniel Ribeiro <drwyrm@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Chris Ball <cjb@laptop.org>, Grant Likely <grant.likely@secretlab.ca>,
        Ernst Schwab <eschwab@online.de>, Sonic Zhang <sonic.zhang@analog.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        openezx-devel@lists.openezx.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] mmc_spi: Add support for regulator framework
Message-Id: <20110404115631.67b1f317.ospite@studenti.unina.it>
In-Reply-To: <1300733202-27316-1-git-send-email-ospite@studenti.unina.it>
References: <1300733202-27316-1-git-send-email-ospite@studenti.unina.it>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; x86_64-unknown-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__4_Apr_2011_11_56_32_+0200_4LkaBDdw3mLxoal1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Apr_2011_11_56_32_+0200_4LkaBDdw3mLxoal1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Mar 2011 19:46:38 +0100
Antonio Ospite <ospite@studenti.unina.it> wrote:

> Hi,
>=20
> this patchset has the purpose of adding support for the regulator framewo=
rk to=20
> the mmc_spi driver. The first three patches are preparatory cleanups to m=
ake=20
> the fourth one more straightforward.
>=20
> Maybe the fourth patch can be improved, I am open to any suggestions abou=
t it.
>

Ping. I forgot to Cc spi-devel-general on this series, should I resend
it?

> These changes take strong inspiration from the pxamci driver; they have b=
een=20
> tested on a Motorola A910, which uses a regulator to powerup the MMC card=
=20
> connected to the SPI bus, a test from a current user of the mmc_spi drive=
r=20
> would not hurt just to be sure no regressions have been introduced.
>=20
> Thanks,
>    Antonio
>=20
> Antonio Ospite (4):
>   mmc_spi.c: factor out the check for power capability
>   mmc_spi.c: factor out the SD card shutdown sequence
>   mmc_spi.c: factor out a mmc_spi_setpower() function
>   mmc_spi.c: add support for the regulator framework
>=20
>  drivers/mmc/host/mmc_spi.c |  194 +++++++++++++++++++++++++++++---------=
------
>  1 files changed, 129 insertions(+), 65 deletions(-)
>=20

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Mon__4_Apr_2011_11_56_32_+0200_4LkaBDdw3mLxoal1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2ZldAACgkQ5xr2akVTsAHKIQCeL58ZVn17aOb6tKRjo7QdBA0Z
CioAn1lsItDi+7N74H/2C47j9n+OfEcs
=TNs2
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Apr_2011_11_56_32_+0200_4LkaBDdw3mLxoal1--
