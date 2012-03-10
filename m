Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465Ab2CJSNa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 13:13:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48806 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab2CJSN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 13:13:28 -0500
Date: Sat, 10 Mar 2012 19:13:15 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Jeff Garzik <jgarzik@pobox.com>, kernel-janitors@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] drivers/ata/pata_mpc52xx.c: add missing kfree
Message-ID: <20120310181315.GA4139@pengutronix.de>
References: <1331402199-8000-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <1331402199-8000-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 10, 2012 at 06:56:39PM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> There is no need to call the devm cleanup functions on failure of a probe
> or remove function.
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Right. Only the subject is bogus and the maintainer for MPC5xxx is Anatolij
meanwhile :)

Other than that:

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9bmbsACgkQD27XaX1/VRufugCfUO9je0DnU1nSAfF+PY5LsvwG
4R0An2Aqo4Kuj3RH0it4yKh6syKdlDn9
=B1sM
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
