Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab1LLMs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 07:48:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58338 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab1LLMs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 07:48:57 -0500
Date: Mon, 12 Dec 2011 13:48:42 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: rtc-linux@googlegroups.com, a.zummo@towertech.it, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] rtc: Kconfig: Place RTC_DRV_IMXDI and RTC_MXC
 under "on-CPU RTC drivers"
Message-ID: <20111212124841.GF3485@pengutronix.de>
References: <1323548042-25432-1-git-send-email-festevam@gmail.com>
 <1323693187-3466-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0H629O+sVkh21xTi"
Content-Disposition: inline
In-Reply-To: <1323693187-3466-1-git-send-email-fabio.estevam@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0H629O+sVkh21xTi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 12, 2011 at 10:33:06AM -0200, Fabio Estevam wrote:
> RTC_DRV_IMXDI and RTC_MXC are on-chip RTC modules, so move them under=20
> "on-CPU RTC drivers" selection menu.
>=20
> While at it change the dependency of RTC_DRV_IMXDI from ARCH_MX25 to SOC_=
IMX25.
>=20
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--0H629O+sVkh21xTi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7l+CkACgkQD27XaX1/VRt0DACeKBJorxYdu1y5l/NK9EIZ0i8V
UqQAnRN0KOsWprRmSNPfkVm1FCcmvISJ
=uOvq
-----END PGP SIGNATURE-----

--0H629O+sVkh21xTi--
