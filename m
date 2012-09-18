Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2IRIBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:01:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60304 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab2IRIA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:00:58 -0400
Date: Tue, 18 Sep 2012 10:00:37 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Greg Ungerer <gerg@snapgear.com>,
        dedekind1@gmail.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>, linux-m68k@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH] clk: Make the managed clk functions generically available
Message-ID: <20120918080037.GA15982@avionic-0098.mockup.avionic-design.de>
References: <1347202862-1617-1-git-send-email-lars@metafoo.de>
 <20120909235059.GA2643@sirena.org.uk>
 <20120910001524.GL13739@n2100.arm.linux.org.uk>
 <20120910002020.GB16249@opensource.wolfsonmicro.com>
 <20120910003913.GM13739@n2100.arm.linux.org.uk>
 <504F4E36.20309@metafoo.de>
 <1347375033.27206.3.camel@sauron.fi.intel.com>
 <504FE633.2090304@snapgear.com>
 <5050F3DB.1050202@metafoo.de>
 <20120915213151.GM12245@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <20120915213151.GM12245@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:+zmzm4n+YkrOBC7jeH6kLsPbaKJD2yiALDq71kuoxzl
 quI11+S63CMz4Qn5jrinT44xNxl2TZ8nOmOwB+WPWnYXOSW0B9
 1nkTj1LGEWtw29F1qnmv14/qe+Y1AQH2rd5Vs+3CgJxV4qTpj+
 xKE0zrWfYTEOb8+16ZZH++uynwJvzWcTBGsoGxWv3lxvkwbdFs
 dBcugim2UGMR21n5nHUjsURh/hwNTLcb6qkfTnyX4UKJvi0QSF
 AHaOzm5qFESOxqi2kejlE29s+wK4mye0pDQTMxX1C8r3/kZLzs
 Rm6B89g/3jsRyGRaKwpmYNszas6ySlJLNBRcKMX0mNT2K+cH5A
 gSD/gvyMa4KQDuNOE9sM72vlPVa0XyiftlW0Uip6QOE8UTQiS7
 W1h/lyvIfUlV3kT/Q4boya8Wj93TlzKouG4d0P7ZO++BA5uKwC
 awPS2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 15, 2012 at 10:31:52PM +0100, Russell King - ARM Linux wrote:
> On Wed, Sep 12, 2012 at 10:43:07PM +0200, Lars-Peter Clausen wrote:
> > I wouldn't mind having this merged sooner rather than later, there is a=
t least
> > one driver in next which is currently broken due to the missing devm_cl=
k_get.
> > Russell what's your plan for the patch? Maybe under the given circumsta=
nces it
> > makes sense to let it go through the m68k tree.
>=20
> Ok, I've merged it but there was no indication in the patch that it was
> supposed to be a fix... there's no cc: to stable.  Does it need to go to
> stable?  When was this brokenness introduced?  What's the story for the
> m68k bit?

What tree is this supposed to go through? I've checked your ARM tree as
well as Mike's clock tree but neither seem to carry this patch. The
reason I ask is because I want to take a patch series that converts the
Unicore32 PWM code to the PWM framework into linux-next but it depends
on this patch as well.

Thierry

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQWColAAoJEN0jrNd/PrOhbU0P/RLCwA0zeQ4Gd/sIZQzCNZCW
2CN3DF38rfKcxvCA2ijJ25zSDa4b2ZvKjPQqVSEowFxY1SIq78vNrkV0N928kesU
N1JVTViAs+eJGCc3OYKGgA4kzmcpeV+TWg2MDJFU5TsTCkzyoLyhAWQ098HScP+k
3FhTTn7FVzE3acz+VUPoN7erKVBVdUJdqlGK/OXvFF+pSW9HPu4wuZZT6UD6EXSA
FubNjIxgUNJeEGNQolPlpJswwUB7beKA8KaDd5a5xMfmkDmIoDjyHGwUwDDddNu8
zkM7juuUo1tlzVRW989GgzoX3ix1PEyuyp/rKfX6atBGQYPAulJuGQKnOsza21G5
IS5npDsmv8kM8Sy+0waxuXowhjr095Frez8g9+AIbtxJuERMHrDHBRvFbJpO1DGn
0id79pqRa28dnXd85FL/8ZNVu/Q3Qdy4LRTWQxXt+IOaXDFAoqEn8EDGByGlAsla
bc2eZWo/pK24PviJ2FjcYQJySGmTDZHzEzzL1x52QPZQ8Q/FAMvQokfBuxfojeuE
ecWR9dTti1hy2bJiSLB0UawqBNgCis2nmKZS09C8YfNJlhycghi6T8uwwW2GITYD
wDm0LQag+bQp7nNsUZQ4J1zGcyjVuoVTofm/jZkbKw2xLMyvkVf6iPbvJ3oMqQQo
DnwlJhEzfFqNRphG57d4
=Mzzu
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
