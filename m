Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab1ECUeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:34:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45302 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab1ECUeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:34:22 -0400
Date: Tue, 3 May 2011 22:34:12 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Michal Simek <monstr@monstr.eu>
Cc: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        hjk@hansjkoch.de, arnd@arndb.de
Subject: Re: [PATCH v4] uio/pdrv_genirq: Add OF support
Message-ID: <20110503203412.GA2119@pengutronix.de>
References: <1304319115-32745-1-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <1304319115-32745-1-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 02, 2011 at 08:51:55AM +0200, Michal Simek wrote:
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

[...]

> +		/* alloc uioinfo for one device */
> +		uioinfo =3D kzalloc(sizeof(*uioinfo), GFP_KERNEL);

kfree in remove?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk3AZsQACgkQD27XaX1/VRvr3ACeOaGboYXohsqIqkX2f3Fy+PzR
CaMAniiz7f9MDArwGEHEa66/TiM+2LJt
=Odmy
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
