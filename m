Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab1DRP0C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 11:26:02 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46100 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab1DRPZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 11:25:57 -0400
Date: Mon, 18 Apr 2011 17:25:51 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Michal Simek <monstr@monstr.eu>
Cc: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        hjk@hansjkoch.de, arnd@arndb.de
Subject: Re: [PATCH v2] uio/pdrv_genirq: Add OF support
Message-ID: <20110418152551.GB23814@pengutronix.de>
References: <1302774106-32764-1-git-send-email-monstr@monstr.eu>
 <20110414165931.GA19228@pengutronix.de>
 <4DABF744.4010209@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline
In-Reply-To: <4DABF744.4010209@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> >>+
> >>+		/* Multiple IRQs are not supported */
> >>+		if (pdev->num_resources > 1) {
> >>+			struct resource *r =3D &pdev->resource[1];
> >
> >Are you sure the irq-ressource is always [1]?  (Similar question for the
> >if()-block above). Try platform_get_irq().
>=20
> I wasn't aware about platform_get_irq. You are right.
>=20
> What "if()-block above" are you talking about?

The one I quoted: if (pdev->num_resources > 1)

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2sV/8ACgkQD27XaX1/VRtc6wCeJDxfInwzBQ1w0qRZAsd5NfMy
55sAoKnvHBjRPSeUYsag2haZYp1flpAL
=wM4i
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
