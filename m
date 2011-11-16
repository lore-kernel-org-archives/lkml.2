Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab1KPJKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 04:10:37 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48897 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab1KPJKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 04:10:35 -0500
Date: Wed, 16 Nov 2011 10:10:27 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Denis Kuzmenko <linux@solonet.org.ua>
Cc: Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: add flags to export GPIOs when requesting
Message-ID: <20111116091027.GB2596@pengutronix.de>
References: <1321397074-6526-1-git-send-email-w.sang@pengutronix.de>
 <4EC2F035.3060705@solonet.org.ua>
 <74CDBE0F657A3D45AFBB94109FB122FF1740805F1A@HQMAIL01.nvidia.com>
 <4EC371FE.5010402@solonet.org.ua>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
In-Reply-To: <4EC371FE.5010402@solonet.org.ua>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> >> #define GPIOF_EXPORT			(1 << 2)
> >> #define GPIOF_EXPORT_DIR_CHANGEABLE	(3 << 2)
> >=20
> > Then you won't have a single flag to check if the dir is changeable.

I played with both versions you mentioned and came to like this one
better, for this reason...

> > direction; just get rid of the two _DIR_ flags. That said, Wolfram's
> > patch seems to follow the conventions already in the file.
>=20
> Your truth.

=2E..and this reason :)

> > Dong Aisheng posted patch "gpio: introduce gpio_export_array to ease
> > export for gpio arrays". Which should we pick; it doesn't seem like we
> > need both mechanisms.
>=20
> I vote for GPIOF_* variant (this one) since it can deal with different
> settings for each gpio pin in array.

Huh? I really missed Aisheng's one, otherwise I would have responded to
that. I also think my version is less intrusive and I surely need the
option that some pins may change directions and others may not.

BTW I didn't CC Grant, because he is on sabbatical right now, so Stephen
you are taking care of GPIO?

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7DfgMACgkQD27XaX1/VRswGgCgosAxgcgRneJrb/WDlZmEIe8v
v3gAn0GuyyMuz1FbaZ71/vBpDaXz4WPE
=l2K2
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
