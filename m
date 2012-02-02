Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab2BBXBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:01:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44151 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab2BBXBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:01:53 -0500
Date: Fri, 3 Feb 2012 00:01:50 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: bangaragiri.g@nxp.com, srinivas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 6/7] LPC32xx: clock.c: USB PLL fix
Message-ID: <20120202230150.GA22458@pengutronix.de>
References: <1327939327-7799-1-git-send-email-stigge@antcom.de>
 <1327939327-7799-6-git-send-email-stigge@antcom.de>
 <20120131103401.GJ2471@pengutronix.de>
 <4F293DAF.4050402@antcom.de>
 <20120202164920.GC3219@pengutronix.de>
 <4F2AE1F0.2070200@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <4F2AE1F0.2070200@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> I'd then first repost the GPIO fixes I posted previously and then look
> after USB if that's fine for you. :-)

Totally fine with me, it's all up to you :)

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8rFd4ACgkQD27XaX1/VRsLGwCgy6zqK0JQ4GdAlUZeV6yOjISH
zxUAn0TTc2YLUb8KCd1dt9iMqzEBvc0r
=CBxg
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
