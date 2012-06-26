Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab2FZDZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 23:25:17 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36915 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237Ab2FZDZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 23:25:15 -0400
Date: Tue, 26 Jun 2012 13:25:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        broonie@opensource.wolfsonmicro.com, rnayak@ti.com,
        viresh.kumar@linaro.org, amit.kucheria@linaro.org,
        linus.walleij@stericsson.com, shawn.guo@freescale.com,
        mkl@pengutronix.de, sr@denx.de, pawel.moll@arm.com,
        maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
        arnd.bergmann@linaro.org, olof@lixom.net
Subject: Re: linux-next: adding the common clk tree
Message-Id: <20120626132502.7584f6acbfc23bdc3d6a8f8e@canb.auug.org.au>
In-Reply-To: <20120626015551.GW4402@gmail.com>
References: <20120626015551.GW4402@gmail.com>
X-Mailer: Sylpheed 3.2.0beta9 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Jun_2012_13_25_02_+1000_0uTydTIMCuCrFgJ0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Jun_2012_13_25_02_+1000_0uTydTIMCuCrFgJ0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Mon, 25 Jun 2012 18:55:51 -0700 Mike Turquette <mturquette@ti.com> wrote:
>
> Would you please add the clk-next branch of the common clock tree to
> linux-next?
>=20
> git://git.linaro.org/people/mturquette/linux.git clk-next
>=20
> Thanks much!
>=20
> For all of those Cc'd, I just wanted to say that I'm changing the way I
> manage clk-next.  The clk-next branch now WILL be rebased, and it's only
> purpose is to make it easy to test things in linux-next.  You can base
> work on it, but be prepare for breakage and shifting commit ids.
>=20
> If you don't want breakage and shifting commit ids then you might want
> to use my clk-fixes branch (stable) and my clk-3.x branch (stable).  As
> patches go through the linux-next cycle and appear stable I'll migrate
> them over to clk-3.x which won't ever be rebased.  This is the branch
> I'll send to Linus.  clk-next is simply comprised of merging clk-fixes,
> clk-3.x and whatever unstable patches I have laying around.

Maybe you have misunderstood the point of linux-next (is is an
integration testing tree, not a development tree)?  I am wondering if, in
particular, the clk-3.x branch (or something near that) may be more
appropriate for linux-next inclusion (and maybe the clk-fixes branch in
my "fixes to the current release" section)?

This is what I tell everyone:

You will need to ensure that the commits in your tree have been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell	sfr@canb.auug.org.au

--Signature=_Tue__26_Jun_2012_13_25_02_+1000_0uTydTIMCuCrFgJ0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP6SuOAAoJEECxmPOUX5FEu9kP/2GfFO2lzsL8he1W8Td2Tgjo
vYaZLvjfbZ+v8PHxoRpw2NJP/Trq8gFFG9HYoDbsKL5eaUy6w19239hbRS6UB1VE
fyoIjyXRxLzoF1xkYFC4jsVtABrRXYk6+M6j/iEH5ayEd2V9POdSRBZp83naHkON
rB5E6wO1B9pV8Apj1O+8/7ebmOCza0DiBKhDBucyaRQmwEtitIEeaqafNMpJjOel
2jv0Bf8ys0HKXIWrNdNljHRAWEVCSZS88TI05b5J7ukEkf7Mi2xjeuAgmlVyUR8M
pqwt0Dh4wM7wVygP+r/ZtbJ8i9tQFCyDFoSFouaTWbRDM7onG9qEJxykZEFRw4Bt
jvvAQdrdGHkJCung/mxC2YKlp/0WLTa6EbM4OrsBJW85GGtd02nRx0eNYDHW7aZ7
y/4DcrupahikJL3OX9l8ilz+dvn+Cgs/S1kn7782I5Qq6yEBZjx/E2p6lwp7GvMR
sSodK2Bdw4U0n+j/Zy74Lk4YadAn6/ni8beYGQQjeFDttRsQqa892ZTYdMsjYqRT
ApF/dVqqjjQqV0V5zM+Qfg620A1eU6Gc2Ltw8EDOq/2G97/qx5y/1w/CA+bmYTOI
ubUFRwsMGiwDvbU5+hZ25d/PfEeCrkN6dTC8hkqOOOj9jR4RVjotC7Z1WVMO/DO6
RH3fBFuClI45nUEZsW3P
=sD/D
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Jun_2012_13_25_02_+1000_0uTydTIMCuCrFgJ0--
