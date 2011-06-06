Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab1FFH1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 03:27:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42128 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab1FFH1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 03:27:48 -0400
Date: Mon, 6 Jun 2011 09:27:45 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] spi: reorganize drivers
Message-ID: <20110606072744.GB4132@pengutronix.de>
References: <20110606071829.10334.90865.stgit@ponder>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CUfgB8w4ZwR/yMy5"
Content-Disposition: inline
In-Reply-To: <20110606071829.10334.90865.stgit@ponder>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 06, 2011 at 01:18:29AM -0600, Grant Likely wrote:
> Sort the SPI makefile and enforce the naming convention spi_*.c for
> spi drivers.
>=20
> This change also rolls the contents of atmel_spi.h into the .c file
> since there is only one user of that particular include file.
>=20
> v2: - Use 'spi-' prefix instead of 'spi_' to match what seems to be
>       be the predominant pattern for subsystem prefixes.
>     - Clean up filenames in Kconfig and header comment blocks
>=20
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>


/me likes.

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--CUfgB8w4ZwR/yMy5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk3sgXAACgkQD27XaX1/VRtCaQCbBnnq9KDustylYR4kihXAla/5
tpwAn0IRBo8yQ+AUSDFsowb2sFaTowos
=udRD
-----END PGP SIGNATURE-----

--CUfgB8w4ZwR/yMy5--
