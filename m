Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1AKPPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:15:31 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57539 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab1AKPPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:15:30 -0500
Date: Tue, 11 Jan 2011 16:15:28 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, Vincent Sanders <support@simtec.co.uk>,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH 12/16] mtd: mpc5121_nfc: don't treat NULL clk as an
 error
Message-ID: <20110111151528.GB25741@pengutronix.de>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
 <1294749833-32019-13-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eAbsdosE1cNLO4uF"
Content-Disposition: inline
In-Reply-To: <1294749833-32019-13-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 11, 2011 at 12:43:49PM +0000, Jamie Iles wrote:
> clk_get() returns a struct clk cookie to the driver and some platforms
> may return NULL if they only support a single clock.  clk_get() has only
> failed if it returns a ERR_PTR() encoded pointer.
>=20
> Cc: Vincent Sanders <support@simtec.co.uk>
> Cc: linux-mtd@lists.infradead.org
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--eAbsdosE1cNLO4uF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0sdBAACgkQD27XaX1/VRvKDACeJn3lvW2SQdz1ysVcRupikh5Q
/isAnir2WsLgJx0cTB1uXmP8YH4Sol+N
=4GrT
-----END PGP SIGNATURE-----

--eAbsdosE1cNLO4uF--
