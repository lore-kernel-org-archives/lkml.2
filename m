Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab1LGUeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 15:34:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37636 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757396Ab1LGUeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 15:34:05 -0500
Date: Wed, 7 Dec 2011 21:33:48 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: grant.likely@secretlab.ca, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH -resend 1/1] SPI: disable CONFIG_SPI_FSL_ESPI=m build
Message-ID: <20111207203348.GB2526@pengutronix.de>
References: <1323289096-13599-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b5gNqxB1S1yM7hjW"
Content-Disposition: inline
In-Reply-To: <1323289096-13599-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 07, 2011 at 09:18:16PM +0100, Jiri Slaby wrote:
> When spi_fsl_espi is chosen to be built as a module, there is a build
> error because we test only CONFIG_SPI_FSL_ESPI in declaration of
> struct mpc8xxx_spi in drivers/spi/spi_fsl_lib.h. Also some called
> functions are not exported.
>=20
> So we forbid CONFIG_SPI_FSL_ESPI to be tristate here.
>=20
> The error looks like:
> drivers/spi/spi_fsl_espi.c: In function 'fsl_espi_bufs':
> drivers/spi/spi_fsl_espi.c:232: error: 'struct mpc8xxx_spi' has no member=
 named 'len'
> ...
>=20
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Acked-by: Kumar Gala <galak@kernel.crashing.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---
> Maybe Grant is back already?

I just picked it up in the for-linus branch I am preparing while Grant
is away.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--b5gNqxB1S1yM7hjW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7fzawACgkQD27XaX1/VRtpxQCgwyLXks2mr1yGcO3fyIQyknX2
XxcAnRTjzECWSWEGOaZsyw6cMOt2tSzP
=UflB
-----END PGP SIGNATURE-----

--b5gNqxB1S1yM7hjW--
