Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab2LQP0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:26:11 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58808 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598Ab2LQP0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:26:09 -0500
Date: Mon, 17 Dec 2012 17:18:48 +0200
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Felipe Balbi <balbi@ti.com>, Paolo Pisati <paolo.pisati@canonical.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>, Liam Girdwood <lrg@ti.com>,
        <linux-kernel@vger.kernel.org>,
        Robert Nelson <robertcnelson@gmail.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: if voltage scaling fails, restore
 original voltage values
Message-ID: <20121217151848.GC22590@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1355389980-5532-1-git-send-email-paolo.pisati@canonical.com>
 <1355389980-5532-2-git-send-email-paolo.pisati@canonical.com>
 <20121213094715.GA1916@arwen.pp.htv.fi>
 <20121214153943.GA3306@luxor.wired.org>
 <20121214154030.GD18233@arwen.pp.htv.fi>
 <20121215141519.GA22033@opensource.wolfsonmicro.com>
 <20121215145738.GB15606@arwen.pp.htv.fi>
 <20121217141536.GF4985@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HWvPVVuAAfuRc6SZ"
Content-Disposition: inline
In-Reply-To: <20121217141536.GF4985@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HWvPVVuAAfuRc6SZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 17, 2012 at 02:15:36PM +0000, Mark Brown wrote:
> On Sat, Dec 15, 2012 at 04:57:38PM +0200, Felipe Balbi wrote:
> > On Sat, Dec 15, 2012 at 11:15:20PM +0900, Mark Brown wrote:
>=20
> > > It's perfectly OK to omit this unless there's an awareness that the
> > > backport won't work on some kernels.
>=20
> > that's not what Greg says, but fair enough. Won't discuss it...
>=20
> Uh, no.  Think about this for a minute - we want bug fixes backporting,
> we don't want to be putting process blockers in the way of that
> especially not in the cases where fixes apply to all the stable kernels
> that are currently active.

then omit the  # v3.x, v3.y  part, but Cc: stable@vger.kernel.org should
still be there

--=20
balbi

--HWvPVVuAAfuRc6SZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQzzfYAAoJEIaOsuA1yqREtEYQALId5AFMrEwxMYtcsqOG299D
uEwo9i3Pq+GkGDBC7rmPVaXLDIxz1z8y6wobR+tfmbFRNWLwerjNOtbgn+QZcB4R
yHEvRWZ6ZWfm8NTTPCRMANElfKuPAcKZmypI2EM1uyMy9S+G1qLTdZi8kMyxh+4l
Rfb0690l3IWRyfNmkXxcTXPsZpeP8CbyUtYQ549L9t/lScBNacSWZP98rkUTM5uj
eqcI59nieaf7OyzDhB2508OBrTkoXBlsVmyLJtZfmx4dtaEXMcavBWHrImH5mFwk
5eRu7tDW5c07TM66WUmYUoH9BdI0LZZ44XBcbZGv+9Rf3gDCQxwWmoP8KqdWDobU
m/pdUYx87/ZmeTqgOaInrDwGFoRtnDOR5bqi0kmQjjs1Zyucro5OQi5NBIxFlSwS
H8z0+fDGPHMYqJKo5zlzytT1kmBfUsWRKxKfrdgv97PViaFC7PoBQ8N/lm2ygtHs
S0MLLLv/GYIIPOXtP4gt7HG8t4Mkndlv0iPc2C2tr6usJXQcV3entEZ/fqoy23DQ
9BZO3kjmoiZ1GUNqAnUi8PLkCKKMkL8TkBNEhEpYvGthEmplW+3EqWyqbYpqPDrD
RVdrcxT5GygVmg9mXpadYHL2pW3r54XwTY9LlIrrulfz5/bRhrv1NjzxrvJ7ycxj
1zgelfaXMB+CXmPJ/0LD
=LpXH
-----END PGP SIGNATURE-----

--HWvPVVuAAfuRc6SZ--
