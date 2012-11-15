Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768012Ab2KOOKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:10:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47861 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767863Ab2KOOKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:10:09 -0500
Date: Thu, 15 Nov 2012 15:10:06 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, jbe@pengutronix.de
Subject: Re: [PATCH] gpio: gpio-max710x: Support device tree probing
Message-ID: <20121115141006.GB22896@pengutronix.de>
References: <1352987980-5112-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
Content-Disposition: inline
In-Reply-To: <1352987980-5112-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 15, 2012 at 02:59:40PM +0100, Roland Stigge wrote:
> For probing via device tree, we need to support the case without platform=
_data.
> In this case, chip.base is set to -1 for automatic numbering.
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Aren't there bindings for pullup configuration, top? Besides that:

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlCk974ACgkQD27XaX1/VRuC+ACfTet5xIBtULFR3kkrZXnkn1ic
7AUAn2TV2/W3I7LKNRKZhTZ7sG0ZGGVV
=mLkH
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
