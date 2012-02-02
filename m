Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab2BBQtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 11:49:42 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54723 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab2BBQti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 11:49:38 -0500
Date: Thu, 2 Feb 2012 17:49:20 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: bangaragiri.g@nxp.com, srinivas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 6/7] LPC32xx: clock.c: USB PLL fix
Message-ID: <20120202164920.GC3219@pengutronix.de>
References: <1327939327-7799-1-git-send-email-stigge@antcom.de>
 <1327939327-7799-6-git-send-email-stigge@antcom.de>
 <20120131103401.GJ2471@pengutronix.de>
 <4F293DAF.4050402@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2/5bycvrmDh4d1IB"
Content-Disposition: inline
In-Reply-To: <4F293DAF.4050402@antcom.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2/5bycvrmDh4d1IB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> Thanks for reviewing my patches! I collected (and applied) all your
> suggestions and will re-post the series as a patch update for applying
> to the mainline tree.

Yes, please repost this series with the updates. And without USB & MMC
updates. Those updates should be in later series, when we actually add
support for these devices.

> What do you think about mainline-integrating it?

See my comment there.

First step, I'd suggest: After you repost this series, I'll create a
branch with the relevant patches (defconfig, buildfixes, clock fixes)
and send a pull-request to Arnd/Olof. You can decide which issue you
want to tackle next. I'd think MMC or USB are more of the lower hanging
fruits, but I leave that to you.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--2/5bycvrmDh4d1IB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8qvpAACgkQD27XaX1/VRtpPwCeJOTT/dJaFEcLsBa/tP7GRk3h
t94An39xHKslism8sCLvuBQKj/l8yCVN
=A6r4
-----END PGP SIGNATURE-----

--2/5bycvrmDh4d1IB--
