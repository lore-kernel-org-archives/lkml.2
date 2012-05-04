Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab2EDVwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:52:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45270 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129Ab2EDVwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 17:52:35 -0400
Date: Fri, 4 May 2012 22:52:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Wolfgang Denk <wd@denx.de>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-embedded@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Igor Grinberg <grinberg@compulab.co.il>,
        Olof Johansson <olof@lixom.net>, Lee Jones <lee.jones@linaro.org>
Subject: Re: Handling of modular boards
Message-ID: <20120504215230.GS14230@opensource.wolfsonmicro.com>
References: <20120504185850.GO14230@opensource.wolfsonmicro.com>
 <201205042039.25794.arnd@arndb.de>
 <20120504205441.D293120645E@gemini.denx.de>
 <201205042103.34285.arnd@arndb.de>
 <4FA4457F.1010900@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LkYZvX65tyO4RZtj"
Content-Disposition: inline
In-Reply-To: <4FA4457F.1010900@wwwdotorg.org>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LkYZvX65tyO4RZtj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 04, 2012 at 03:09:19PM -0600, Stephen Warren wrote:
> On 05/04/2012 03:03 PM, Arnd Bergmann wrote:

> > Sure, there are a lot of things that the boot loader can use from the
> > device tree, but I'm not sure if the LCD panel connection fits into
> > the same category as the devices that Mark was thinking of.

> A board I have sitting on my desk right now has separate boards for (and
> multiple options for each of):

> * Motherboard
> * CPU+DRAM
> * PMU/PMIC
> * Display (LCD)
> ... and many more.

> Interaction with the PMU/PMIC is required for at least some of the boot
> media options.

Yeah, similar setup for our boards except the PMICs are soldered down
onto other boards.  We've got a mainboard, three audio boards of various
kinds, a random non-audio components board and a CPU/DRAM board.

There's good solid engineering reasons for doing this.  CPUs and RAMs
tend to be very high density devices with lots of pins and be difficult
enough to route to require large numbers of layers (and ideally you want
the PMIC to be physically close to them since long traces tend to become
electrically interesting for CPU style loads, especially when routed
through connectors) all of which leads to an expensive board which you
pay for by area.  With reference boards with large form factors it's
worth the effort to have a separate, smaller, board manufactured to meet
these requirements - even in very low volumes the cost wins are
noticable.

--LkYZvX65tyO4RZtj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPpE+VAAoJEBus8iNuMP3dFoQQAJLhLauyyrv0tqZ/07cMNMa4
zREYjnCc9V43IZkja7225fUxgvBdbGcCbLy0pPnEhRFa2CjeJkxTM193abzKF9LO
gw2+RoKwAQeP6Jl9lZk+XUnN/4yE6VrriDC8vDCa1bEikBwRzq7jRrq5i9xglxG5
tUsWmv6cdMUkQNf5OzYqFUDvuZb8qEIf2JKkjmPp6utOquC7kqPgkGvnTbioBL9X
BhjackNDA5uo1J8hq6m0Pxxplx+usKuPHbEiOyx52G1QSXzhIeEPdnpwACYgIkdb
srNS+sgs8ZkpsahytYogsfkvnybJd1QILmG0Bt58pfcF1yRmJl2b13qLW+BaNSJG
gXbdf/0ZaHdvy9OMpQdzBsU9QptR9tvL+jKCG4u0LeVUNhXdyVJoaJqkoYmaF+ad
DlCFhAPBVppUmvHFfZKc21gPsY3UMDLDuUNZ/957daU6mXenEt9+aGSj4/j70ugo
4EqHf8YD81xfqGTQWrmxZwDM64FOXYjXjhcHBGTSvrgCCqMMMxz3VBvC9JYkxhnz
WLReRih9FfHz4dKysIO1cgV0Rudoce7uC9gQr2cSO7vIc++okSJEOQIDh8utRbgp
3XjZdSi2JIPHQ+Zd36Gx562GjJlGTEn7WQZctFSR9XBJT5sY8K01qmaJWsca8ooM
VNWpIbeLEeva8eaE0+3+
=7/jL
-----END PGP SIGNATURE-----

--LkYZvX65tyO4RZtj--
