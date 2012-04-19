Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2DSLHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 07:07:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51812 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2DSLHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 07:07:12 -0400
Date: Thu, 19 Apr 2012 13:07:10 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Zhao Chenhui <chenhui.zhao@freescale.com>
Cc: linux-i2c@vger.kernel.org, leoli@freescale.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c-mpc: avoid I2C abnormal after resuming from deep
 sleep
Message-ID: <20120419110710.GD2206@pengutronix.de>
References: <1334829094-22048-1-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C+ts3FVlLX8+P6JN"
Content-Disposition: inline
In-Reply-To: <1334829094-22048-1-git-send-email-chenhui.zhao@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 19, 2012 at 05:51:34PM +0800, Zhao Chenhui wrote:

> When entering deep sleep, the value in the registers I2CFDR and
> I2CDFSRR are lost. This causes I2C access to fail after resuming.
>=20
> Add suspend/resume routines to save/restore the registers
> I2CFDR and I2CDFSRR.
>=20
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>

Applied to next. Thanks!

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--C+ts3FVlLX8+P6JN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+P8d4ACgkQD27XaX1/VRsG8wCgs3R+gYTdS4A/rb13SgOSGHU8
2gIAoIXaq/jRSp5AhEvtNnhFDug6T4WE
=EOcj
-----END PGP SIGNATURE-----

--C+ts3FVlLX8+P6JN--
