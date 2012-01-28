Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab2A1I0i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 03:26:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49169 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2A1I0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 03:26:37 -0500
Date: Sat, 28 Jan 2012 09:26:30 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH 1/15] sound/soc/mxs/mxs-saif.c: add
 missing iounmap
Message-ID: <20120128082630.GA2509@pengutronix.de>
References: <7FE21149F4667147B645348EC605788508FBDB@039-SN2MPN1-013.039d.mgd.msft.net>
 <alpine.DEB.2.02.1201241828480.1779@localhost6.localdomain6>
 <20120124202203.GD1135@opensource.wolfsonmicro.com>
 <alpine.DEB.2.02.1201242144580.1998@hadrien>
 <20120126110506.GB2611@pengutronix.de>
 <alpine.DEB.2.02.1201261220460.1851@localhost6.localdomain6>
 <20120126112242.GA9401@opensource.wolfsonmicro.com>
 <alpine.DEB.2.02.1201261439460.1851@localhost6.localdomain6>
 <20120126135135.GD2611@pengutronix.de>
 <alpine.DEB.2.02.1201261504200.1851@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1201261504200.1851@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> >You can skip checking 'iores', too. I also did that in the example, but
> >a lot of people seem to miss it.
>=20
> I can try to do that, but it seems a little bit unintuitive.
> Perhaps it would be easier for people to remember to put in error
> handling code when they need it if they always have to do it?  If I
> remove it, there will be one call that has no test and then another
> call a few lines later that does.

I see your point. I would still like to get rid of the duplicated code
(then it can't be forgotten as well). Maybe I should have named the
function something alike devm_check_and_request_and_ioremap()? Then I
could have also introduced a similar function for requesting irq. Will
think about this a bit more. Thanks for updating your patch!

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8jsTYACgkQD27XaX1/VRt8OgCePH65/3s0DqfK4LgBBIBCOwMX
a84AniM02n49P99Vp9eG8P6QC8BiYarn
=qxKx
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
