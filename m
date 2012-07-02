Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab2GBXdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 19:33:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46245 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab2GBXdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 19:33:38 -0400
Date: Tue, 3 Jul 2012 09:33:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mike Turquette <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        broonie@opensource.wolfsonmicro.com, rnayak@ti.com,
        viresh.kumar@linaro.org, amit.kucheria@linaro.org,
        linus.walleij@stericsson.com, shawn.guo@freescale.com,
        mkl@pengutronix.de, sr@denx.de, pawel.moll@arm.com,
        maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
        arnd.bergmann@linaro.org, olof@lixom.net
Subject: Re: linux-next: adding the common clk tree
Message-Id: <20120703093321.d261f6a118f03d6296af54e9@canb.auug.org.au>
In-Reply-To: <CACRpkdayZUcA13p8iTRXLb4BestbAQhNP+a1nesYkcDEGFs=WA@mail.gmail.com>
References: <20120626015551.GW4402@gmail.com>
	<CACRpkdayZUcA13p8iTRXLb4BestbAQhNP+a1nesYkcDEGFs=WA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Jul_2012_09_33_21_+1000_RIvd0C9kk2u4oDAb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Jul_2012_09_33_21_+1000_RIvd0C9kk2u4oDAb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Sat, 30 Jun 2012 21:47:35 +0200 Linus Walleij <linus.walleij@linaro.org>=
 wrote:
>
> On Tue, Jun 26, 2012 at 3:55 AM, Mike Turquette <mturquette@ti.com> wrote:
>=20
> > Would you please add the clk-next branch of the common clock tree to
> > linux-next?
> >
> > git://git.linaro.org/people/mturquette/linux.git clk-next
>=20
> So I don't see this being pulled into -next, is it just a slip,
> I though the structure of the branch was agreed upon and all?

I am waiting for Mike to let me know its all ready to add ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__3_Jul_2012_09_33_21_+1000_RIvd0C9kk2u4oDAb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP8i/BAAoJEECxmPOUX5FE91wP/jdwwND2n79xLzufFrazX0TI
PAZZkrPw1ji7FL0TcMkXSoPAxolVxFOD+UCMr/6n5pp8cvTaqo9C3+fhX20V//a1
8aocZ/Nxd3SL9sI0svafo+s4xQ1h0D2NxHLidd9jjahKHT+KRrZI8htkkezFUITv
rQ9tOIH+YuTNmz54tM/ky/n9mFMM1tox4dmwd6PdikdY+/trjVuOkZbXX313xpUY
zYESrlrb2nIPnUmfshRzk6Q+ycUvB566X49eULo+VrZxoEPnHypMDywMTDSUOj8h
zC8D44SkTHcfAUz7Y0zjJ8NWcQdReGNXtdqyQ7oXSryUhokt8FtErCzOMk7MhNQ3
odEShwkV5zAmYrVDNFZDxjv4wtRK4R46goe4dofXdq/3yfw78soqMG/4uDy5D2e3
fACFPLk+ERMLdXR9vb1pcQubruVUuzmwuexelSSOYWDE6YbXIAyHobZHgAcbi0VN
r2G0oYq6meL9RM8i2a+0AZo2QzJFOvT+397viZxKiBQZ9zV2fejBzs7xBSJDFqZG
GIWV5qIG5zhQJWoad3sJWEDBqoA+LreKfx9v7aqndCqOU43WcB7sW4NowL0L2Dbg
c62veJhajsOb6hZW8XZ3naVCINvD4ZP9cxsMf/tbsyrnlB37ctsdnlrCINwzuQA3
2w7wEIMccdhn6OJ4pHeB
=r0VC
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Jul_2012_09_33_21_+1000_RIvd0C9kk2u4oDAb--
