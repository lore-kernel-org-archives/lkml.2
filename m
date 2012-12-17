Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab2LQPpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:45:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46239 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753001Ab2LQPpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:45:14 -0500
Date: Mon, 17 Dec 2012 15:45:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Paolo Pisati <paolo.pisati@canonical.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, Robert Nelson <robertcnelson@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] regulator: core: if voltage scaling fails, restore
 original voltage values
Message-ID: <20121217154512.GI4985@opensource.wolfsonmicro.com>
References: <1355389980-5532-1-git-send-email-paolo.pisati@canonical.com>
 <1355389980-5532-2-git-send-email-paolo.pisati@canonical.com>
 <20121213094715.GA1916@arwen.pp.htv.fi>
 <20121214153943.GA3306@luxor.wired.org>
 <20121214154030.GD18233@arwen.pp.htv.fi>
 <20121215141519.GA22033@opensource.wolfsonmicro.com>
 <20121215145738.GB15606@arwen.pp.htv.fi>
 <20121217141536.GF4985@opensource.wolfsonmicro.com>
 <20121217151848.GC22590@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbfcI4OLZ4XW0yH2"
Content-Disposition: inline
In-Reply-To: <20121217151848.GC22590@arwen.pp.htv.fi>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbfcI4OLZ4XW0yH2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 17, 2012 at 05:18:48PM +0200, Felipe Balbi wrote:
> On Mon, Dec 17, 2012 at 02:15:36PM +0000, Mark Brown wrote:

> > Uh, no.  Think about this for a minute - we want bug fixes backporting,
> > we don't want to be putting process blockers in the way of that
> > especially not in the cases where fixes apply to all the stable kernels
> > that are currently active.

> then omit the  # v3.x, v3.y  part, but Cc: stable@vger.kernel.org should
> still be there

Oh, yes - that's needed.  Sorry, I thought it was the v3.x bit you were
complaining was missing.

--VbfcI4OLZ4XW0yH2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQzzuqAAoJELSic+t+oim9QmsP/AnyeGe83BKMFL1JYAYj9dFZ
yUMqRieupU2d5rqKGU0zPutc6I6jnciv8J2y7oo6y5AugtGasgW7XS/bptuar8bw
aTEWbO1VAtVXpB/OScTHxgeopnyrZmDvMrPr2j1YbXm/Tt2MSruARVo/z31g5u4C
SzvDHWdFSckenSunLOkaBT0aqHBkmECe1EpZ6sZAV2237c6WpLSz/AHlR3ZlJ8kn
Ndthj5ATdMOjdqoAS5Cb0I8BBBhiioiGvYeW+YQ7uXtJeXqbmow6BP5DD9SEgvRs
mEfBYaiYahPDOanlAeZKG9l8889XCZPg4kuwf2q4lO9mG0lpveEjwQvXWKNnhEP4
yJUs0QpviOyHAGfbrHJ0QxSZBJYuF0/X7uenf3BYtAXvjwXPO1ZSILjx7ZzpAyAY
mIZPoKyjyQ6Ocb++K1kIEUWN8A+uSWCbc99+vAzGutYRNwZfRbYcThYP+d9L5x+Z
uGFRmpbQatri5qpHG08Kc3OP7NsNSZOV9qYYnDrY1KjSm7FGU7XokA7GB8toKcA9
SP9hYi3BRCCfwxFDc0O3zagJoxDa+yYQlkqARtvmHkPSjht74R1VRViL0N1tthFX
goEF2Pb+Tjcp8GM8kwPi0hgHs7VGgkyvr1JH40mEImlKPKVtvQsnALmawkxngP1z
RqNLp/3Aas5l/qvU4mdO
=qg6i
-----END PGP SIGNATURE-----

--VbfcI4OLZ4XW0yH2--
