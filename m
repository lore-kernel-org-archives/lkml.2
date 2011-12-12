Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab1LLMtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 07:49:08 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58345 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab1LLMtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 07:49:05 -0500
Date: Mon, 12 Dec 2011 13:48:58 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: rtc-linux@googlegroups.com, a.zummo@towertech.it, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] rtc: Rename CONFIG_RTC_MXC to CONFIG_RTC_DRV_MXC
Message-ID: <20111212124858.GG3485@pengutronix.de>
References: <1323548042-25432-1-git-send-email-festevam@gmail.com>
 <1323693187-3466-2-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y/WcH0a6A93yCHGr"
Content-Disposition: inline
In-Reply-To: <1323693187-3466-2-git-send-email-fabio.estevam@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y/WcH0a6A93yCHGr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 12, 2011 at 10:33:07AM -0200, Fabio Estevam wrote:
> In order to keep consistency with other rtc drivers,rename CONFIG_RTC_MXC
> to CONFIG_RTC_DRV_MXC.
>=20
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

Thanks!

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Y/WcH0a6A93yCHGr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7l+DoACgkQD27XaX1/VRs6FQCfc/50AJxkLVZXoiNXWfY6mqMy
V74AoIUDzjMNjY0SJa5dYUtcZm71PSzD
=JeZx
-----END PGP SIGNATURE-----

--Y/WcH0a6A93yCHGr--
