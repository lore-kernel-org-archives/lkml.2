Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab2FCLzr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 07:55:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34883 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834Ab2FCLzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 07:55:46 -0400
Date: Sun, 3 Jun 2012 12:55:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 2/2] ARM: dt: tegra: cardhu: register core regulator
 tps65911
Message-ID: <20120603115529.GF4258@opensource.wolfsonmicro.com>
References: <4FBBC830.2060802@nvidia.com>
 <4FBBCA8F.3050903@wwwdotorg.org>
 <4FBBD33C.8020802@nvidia.com>
 <4FBBDA97.6000006@wwwdotorg.org>
 <4FBBDE06.5080806@nvidia.com>
 <4FC916AC.4060804@wwwdotorg.org>
 <20120601204052.GB4258@opensource.wolfsonmicro.com>
 <4FC92990.5030104@wwwdotorg.org>
 <20120601210451.GC4258@opensource.wolfsonmicro.com>
 <CAOesGMgYAR938F8PnVWaymzMBQwDKeAiUgEP81bv2nN14NmLGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhtSGe8h3+lMyY1M"
Content-Disposition: inline
In-Reply-To: <CAOesGMgYAR938F8PnVWaymzMBQwDKeAiUgEP81bv2nN14NmLGg@mail.gmail.com>
X-Cookie: You may be recognized soon.  Hide.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhtSGe8h3+lMyY1M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 02, 2012 at 02:19:57PM -0700, Olof Johansson wrote:

> naming dependencies to only be under the regulators in question. In
> particular, for things such as fixed regulators, they can be located
> at other places in the device tree.

I'm sorry, I can't parse this at all.  What "naming dependencies" are
you talking about?  This is purely an issue for multi-regulator chips.

--zhtSGe8h3+lMyY1M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPy1C2AAoJEBus8iNuMP3dsYsP/i1U6p0kOYBZ4EyFstVpfKUv
RpzPtvqsBdbEfqAnp0LlW3/DHOJsA8UiD4EJsB5cKnOwNi7Rru53fBMoXbWmIq+P
MydTj1opKkifb8BhPG86reGUDlWfTYLpHWPeLMqaQuULfK9HBijPUsZVZ8JaPnAL
6yps1o4TrmDrSQIhoNKAyfTGZxWPFwk1D7sXfx/WMv5I7Eh8H0C3Vv4/Cn4LPswm
w99nNdX57gRKogqUjCMGl294XdWHvLsImPFBDESH0vjr7TadYyZdxrd4sIi9h+Yn
61xR9bw4nXE11SNoGtGr9zk8dONqq698FOmHRXmiz17vbjDms58COmLgRuVa8xvD
Vi5L+NwyCNXeu7bmw7hPjFdkJcOUDeaEdLK0wp3zLm5Io7zdMBSQQ/biLOdRRpaQ
3T7DnKfy/eg/4SqsnOi50kw9IwrXx3sab95Y/SGn33Gbp9rlJsdeBJHWmVtVQ8x5
NQzmOk+2MGkrZfJqHW42g5vy4irAWLmE9/BEMy9YOhrMthH1IRL4+o0m3h9d2EiM
XzB0y+195zdb6jQ0ZlKfC+rlkDV9HFzKLCTJrpsKExhDBitFm/j8d8Umidmh4ARY
PPw6i56iWl+p875/l3yGlRo/298bASkQLAaHc4ZcjAyTZuQcS9qRHJ56b0EWLtH6
wEV0ZjbK+PbWIbhKp5vS
=BFIC
-----END PGP SIGNATURE-----

--zhtSGe8h3+lMyY1M--
