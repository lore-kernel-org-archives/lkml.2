Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab1K2KVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:21:42 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47125 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab1K2KVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 05:21:39 -0500
Date: Tue, 29 Nov 2011 11:21:37 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Marc Vertes <marc.vertes@sigfox.com>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Dimitry Andric <dimitry.andric@tomtom.com>,
        Ben Dooks <ben@simtec.co.uk>
Subject: Re: [PATCH] watchdog: fix nowayout setting in s3c2410_wdt
Message-ID: <20111129102136.GB5455@pengutronix.de>
References: <4ed026d9.TvJLr8ihQ2VtvqPD%marc.vertes@sigfox.com>
 <20111126102915.GA7517@pengutronix.de>
 <20111129095643.GH23376@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xgyAXRrhYN0wYx8y"
Content-Disposition: inline
In-Reply-To: <20111129095643.GH23376@infomag.iguana.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> +/* Use the following function to set the nowayout feature */
> +static inline void watchdog_set_nowayout(struct watchdog_device *wdd, in=
t nowayout)
> +{
> +	if (nowayout)
> +		set_bit(WDOG_NO_WAY_OUT, &wdd->status);
> +}

Yes, this is better in case we might need to add something later.

> but: .status =3D WATCHDOG_NOWAYOUT_INIT_STATUS, is also a nice one to hav=
e.
>=20
> I propose to add both options and to document them in the documentation.
> Objections anyone?

Sounds good to me.

So, I'll drop NOWAYOUT-related patches from my STMP-series?

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--xgyAXRrhYN0wYx8y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7UsjAACgkQD27XaX1/VRs+dACgw0IWeSvXFeO5NsiGo4RnDEwM
wpEAoI4C0tUCLQdzJO8bhXBBdEzXhHxo
=5uqh
-----END PGP SIGNATURE-----

--xgyAXRrhYN0wYx8y--
