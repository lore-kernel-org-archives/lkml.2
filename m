Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab1LLIzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 03:55:32 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59397 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab1LLIza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 03:55:30 -0500
Date: Mon, 12 Dec 2011 09:55:23 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: rtc-linux@googlegroups.com, a.zummo@towertech.it, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] rtc: Kconfig: Place RTC_DRV_IMXDI and RTC_MXC under
 "on-CPU RTC drivers"
Message-ID: <20111212085523.GB3485@pengutronix.de>
References: <1323548042-25432-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
Content-Disposition: inline
In-Reply-To: <1323548042-25432-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> +config RTC_MXC

RTC_DRV_MXC for consistency while we are here?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7lwXsACgkQD27XaX1/VRsbAgCdH5xIoCRCc/d7O9aF6URML0Hq
urgAoI0u3Z21N0I6IvABQOm04ZNLC/+d
=Epby
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--
