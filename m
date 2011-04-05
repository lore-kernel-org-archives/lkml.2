Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab1DEIoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 04:44:06 -0400
Received: from smtp204.alice.it ([82.57.200.100]:60128 "EHLO smtp204.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab1DEIoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 04:44:04 -0400
Date: Tue, 5 Apr 2011 10:43:47 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-mmc@vger.kernel.org, Daniel Ribeiro <drwyrm@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Chris Ball <cjb@laptop.org>, Ernst Schwab <eschwab@online.de>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        openezx-devel@lists.openezx.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] mmc_spi: Add support for regulator framework
Message-Id: <20110405104347.0f93ab97.ospite@studenti.unina.it>
In-Reply-To: <20110405030543.GC29522@ponder.secretlab.ca>
References: <1300733202-27316-1-git-send-email-ospite@studenti.unina.it>
	<20110404115631.67b1f317.ospite@studenti.unina.it>
	<20110405030543.GC29522@ponder.secretlab.ca>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; x86_64-unknown-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Apr_2011_10_43_47_+0200_z7N73p8uiIR.ADUz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Apr_2011_10_43_47_+0200_z7N73p8uiIR.ADUz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 4 Apr 2011 21:05:43 -0600
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Mon, Apr 04, 2011 at 11:56:31AM +0200, Antonio Ospite wrote:
> > On Mon, 21 Mar 2011 19:46:38 +0100
> > Antonio Ospite <ospite@studenti.unina.it> wrote:
> >=20
> > > Hi,
> > >=20
> > > this patchset has the purpose of adding support for the regulator fra=
mework to=20
> > > the mmc_spi driver. The first three patches are preparatory cleanups =
to make=20
> > > the fourth one more straightforward.
> > >=20
> > > Maybe the fourth patch can be improved, I am open to any suggestions =
about it.
> > >
> >=20
> > Ping. I forgot to Cc spi-devel-general on this series, should I resend
> > it?
>=20
> Not a bad idea.  It doesn't go via my tree since it is an mmc patch,
> not an spi one, but I don't mind taking a look at the spi bits.
>=20

Grant you were on Cc from the start so you should have the patches
somewhere; please tell me if you don't.
I'd avoid resending if not strictly necessary.

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Tue__5_Apr_2011_10_43_47_+0200_z7N73p8uiIR.ADUz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2a1kMACgkQ5xr2akVTsAHgCwCeLlslXpMUNWY1y3U2oGqF2IM9
EoIAoJwgDQ7vYXZulTip4xWMQ31NVVaE
=3yV6
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Apr_2011_10_43_47_+0200_z7N73p8uiIR.ADUz--
