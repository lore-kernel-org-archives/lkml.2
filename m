Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab1ELRDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:03:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46940 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757988Ab1ELRDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:03:14 -0400
Date: Thu, 12 May 2011 19:03:11 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Michal Simek <monstr@monstr.eu>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        "Hans J. Koch" <hjk@hansjkoch.de>, Arnd Bergmann <arnd@arndb.de>,
        John Williams <john.williams@petalogix.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v5] uio/pdrv_genirq: Add OF support
Message-ID: <20110512170310.GA13751@pengutronix.de>
References: <1304577644-4024-1-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <1304577644-4024-1-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 05, 2011 at 08:40:44AM +0200, Michal Simek wrote:
> Adding OF binding to genirq.
> Version string is setup to the "devicetree".
>=20
> Compatible string is not setup for now but you can add your
> custom compatible string to uio_of_genirq_match structure.
>=20
> For example with "vendor,device" compatible string:
> static const struct of_device_id __devinitconst uio_of_genirq_match[] =3D=
 {
> 	{ .compatible =3D "vendor,device", },
> 	{ /* empty for now */ },
> };
>=20
> Signed-off-by: Michal Simek <monstr@monstr.eu>

Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3MEs4ACgkQD27XaX1/VRvb1QCgtfXA1rVtZ/l8vwzSbLiTvX5N
oNwAoKNLrSBNRGRUxWlO6ts4t5EYwcbd
=Fan0
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
