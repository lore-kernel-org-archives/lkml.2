Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab1BUJTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 04:19:24 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58425 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab1BUJTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 04:19:23 -0500
Date: Mon, 21 Feb 2011 10:19:16 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Eric Miao <eric.y.miao@gmail.com>,
        Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 1/4] gpiolib: Add "unknown" direction support
Message-ID: <20110221091916.GA2616@pengutronix.de>
References: <1297904216-15219-1-git-send-email-ptyser@xes-inc.com>
 <201102171321.47704.alexander.stein@systec-electronic.com>
 <4D5D1D3E.2020107@metafoo.de>
 <201102211009.31381.alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <201102211009.31381.alexander.stein@systec-electronic.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > Sharing GPIOs in read-only mode, is indeed something that is not covere=
d by
> > the GPIO API. It might be worth adding a gpio_request_shared, which wou=
ld
> > only permit setting the direction to input. Futher gpio_request_shared
> > calls would be allowed but gpio_request calls would fail.
>=20
> gpio_request_shared sounds interesting, but in this case an implicit=20

Can you name a use-case? One reason is that we won't need to implement
it if there is no user, another one is that it could potentially weaken
abstractions?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1iLhQACgkQD27XaX1/VRvpBACfbBfCnrvb/M0aZPpd/7di/yux
Xd8An1RDu0EuBZSbn1/XH/b+rnNkAdPn
=Jwgo
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
