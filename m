Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab2A3Pea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:34:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57225 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab2A3Pe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:34:28 -0500
Date: Mon, 30 Jan 2012 16:34:27 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [RFC 2/2] regmap: make use of cached entries in debugfs
Message-ID: <20120130153427.GH15596@pengutronix.de>
References: <1327932497-28319-1-git-send-email-w.sang@pengutronix.de>
 <1327932497-28319-2-git-send-email-w.sang@pengutronix.de>
 <20120130145627.GJ4882@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqCDj3hiknadvR6t"
Content-Disposition: inline
In-Reply-To: <20120130145627.GJ4882@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqCDj3hiknadvR6t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 30, 2012 at 02:56:28PM +0000, Mark Brown wrote:
> On Mon, Jan 30, 2012 at 03:08:17PM +0100, Wolfram Sang wrote:
>=20
> > -		if (!regmap_readable(map, i))
> > +		if (map->cache_type =3D=3D REGCACHE_NONE && !regmap_readable(map, i))
>=20
> This isn't quite what you said in the changelog

Sorry, I reread and can't find the diff?

> and isn't going to play nicely with sparse register maps

sparse =3D=3D RBTREE? What does "play nicely" mean here? Too slow?

> - it should be
>=20
> 	if (regmap_cached(map, i) || regmap_readable(map, i))
>=20
> or so (regmap_cached() doesn't exist at present but it seems reasonable
> that it should).

Sigh, I have to give up for now. Sadly, I am already way beyond my
schedule regarding the amplifier driver and need to work on other things
now.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--AqCDj3hiknadvR6t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8muIMACgkQD27XaX1/VRvhcQCeJOcpzfC0HPn9Bp/51aWMiKqx
NYQAoKLzYZbj7WLmbp5KfPbNGUhW3jBJ
=Yhib
-----END PGP SIGNATURE-----

--AqCDj3hiknadvR6t--
