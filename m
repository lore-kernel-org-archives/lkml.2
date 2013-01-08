Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab3AHHMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 02:12:53 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:57971 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3AHHMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 02:12:52 -0500
Date: Tue, 8 Jan 2013 08:12:34 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] spi: tegra: sequence compatible strings as per preference
Message-ID: <20130108071234.GB2171@avionic-0098.adnet.avionic-design.de>
References: <1352452052-13823-1-git-send-email-ldewangan@nvidia.com>
 <509D37B8.8020606@wwwdotorg.org>
 <20121109171008.GX23807@opensource.wolfsonmicro.com>
 <509D3D46.7060102@wwwdotorg.org>
 <20121110170741.GA17689@avionic-0098.mockup.avionic-design.de>
 <20121219170009.54EE83E0C34@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gj572EiMnwbLXET9"
Content-Disposition: inline
In-Reply-To: <20121219170009.54EE83E0C34@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:XdbkpVZ7iClKR/pxOKqKiR88nMZ+LCJwU/y9FBOp1ND
 EcthymCrxggIeZuN+gPYGWE42ZggnlXsHNOwoGofB50RTkVvMT
 2BMXDO/OJ+++lNdxEyRPLgZQKry9xurlvpp0XSBBnKS7iAyDc5
 e/LdlMog68vGMXVjyqbkHtS1k3byl7/o2tAAeX0BN/V57n7ffY
 LMY62jBwumQzKSHqi53sBu8mkswDZOTEWgti4MyPeVYNB3hqo5
 RCMl52FLq+J26Mq5g2chMU+k/wEc4xh0Dmdbt5DoPmuAMaEgyS
 I7v4dPx//sHbivyrcu+55B8RbEk31nLppK7j5/lQlrHdZe7Tur
 URNsBtn95VbzGrL7wKO4MfOa7hcArCpt3dH/Dr69+LK3Z4h9m/
 Gt9ftUVqfD3U5NskEMLZhHE0eFmQg5HUbM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gj572EiMnwbLXET9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 19, 2012 at 05:00:09PM +0000, Grant Likely wrote:
> On Sat, 10 Nov 2012 18:07:42 +0100, Thierry Reding <thierry.reding@avioni=
c-design.de> wrote:
> > On Fri, Nov 09, 2012 at 10:28:38AM -0700, Stephen Warren wrote:
> > > On 11/09/2012 10:10 AM, Mark Brown wrote:
> > > > On Fri, Nov 09, 2012 at 10:04:56AM -0700, Stephen Warren wrote:
> > > >=20
> > > >> However just FYI, it should not be necessary for correctness; The
> > > >> DT matching order is supposed to be driven purely by the order of
> > > >> the compatible values in the DT now, and not affected by the
> > > >> order of values in the table. (This wasn't always the case, but
> > > >> was a bug that was fixed IIRC by Thierry Reding).
> > > >=20
> > > > I guess the driver is being used backported in older kernels which
> > > > don't have that fix?
> > >=20
> > > That sounds likely. Laxman, it'd be a good idea to track down the fix
> > > to the DT matching code and backport it, so that hard-to debug issues
> > > aren't caused by the lack of that patch!
> >=20
> > Unfortunately the patch that was supposed to fixed this caused a
> > regression and was therefore reverted. Rob (Cc'ed) said there was a
> > patch to fix it properly and was supposed to go into 3.6 but it seems
> > that never happened. Rob, what's the status on this?
> >=20
> > The revert is here: bc51b0c22cebf5c311a6f1895fcca9f78efd0478
>=20
> Rob, ping on this. I think we talked about it on IRC, but I cannot
> remember what was said.... I must be getting old.

Any news on this one?

Thierry

--gj572EiMnwbLXET9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ68biAAoJEN0jrNd/PrOh6OYQALnxIcAYee7gi6zXv867rfCT
EYC1p6J8ZQGghHBSyYo0dsemfcwrddUMvkvmtmSl3eSgMEPQgPd8TOvDMF9HuMOU
I1KoP0l6tLSEn/+k9Mrlh2gOBa8lp73oF7jStyahZVaJcIfBsABVvFDHfU5zGBO+
y2vAHlAQnQ60ZX60DBRakYai5sxpTU32yRa7pvyLUz+Tz1MYsayxCbUIiHaZ8Rjo
SxsU8JhCiXEmbC6X9zJzggfbUGImKeWXCCIe87FH2lnj0iegHvRMEyzp3qddlXZ7
XXYyJGc2p8Gpftqw3TojoIPSEkS0v7PqJ4hdIXryv1IOie2MgyIP0CSldN/9LuZe
Us1AJiYx8YJX3nq0QfoVpa9a5sL4sNgd44l3QbKHCNL0IT+mP7x+fmjr2sF/43rQ
6KOrW4gkpDT6Mf5JNF+KbM0FA4LClQZEySN0zFnSwzL1XAGDII28JGWZQaw4zb82
6cWkMzevvsv9UPuRhIXvTl2gkS5BHEs7MzgU4kPznJ0d1zThAlcD+ar1YtS3PV4z
mzvXZfvMuheQigDVqT/vjBRJZkiuSROzPgbwsWpHK1jefA3VdOY1EIVLk0+UM5Oy
d6MymrE04SW2hBOcNy7sy7GhcQRaOOBsjT9KU63o2lH++LsigwLdwplKu6mbtk1Q
ptodw/yyZ3kDx3KePDzw
=0k4e
-----END PGP SIGNATURE-----

--gj572EiMnwbLXET9--
