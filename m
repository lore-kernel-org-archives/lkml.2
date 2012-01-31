Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab2AaK1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:27:44 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50456 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab2AaK1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:27:43 -0500
Date: Tue, 31 Jan 2012 11:27:40 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: bangaragiri.g@nxp.com, srinivas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 7/7] LPC32xx: clock.c: Fix mutex lock issues
Message-ID: <20120131102740.GI2471@pengutronix.de>
References: <1327939327-7799-1-git-send-email-stigge@antcom.de>
 <1327939327-7799-7-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7SrMUQONj8Rl9QNG"
Content-Disposition: inline
In-Reply-To: <1327939327-7799-7-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7SrMUQONj8Rl9QNG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 30, 2012 at 05:02:06PM +0100, Roland Stigge wrote:
> This patch fixes the mutex issue in clock.c, as done in Kevin Wells' orig=
inal
> driver update:
>=20
> In some cases, the clock drivers could grab a mutex twice in an improper
> context. This patch changes the mutex mechanism to a simple irq lock/unlo=
ck
> mechanism and removes un-needed locks from some functions.
>=20
> (See also git.lpclinux.com)
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Tested-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--7SrMUQONj8Rl9QNG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8nwhwACgkQD27XaX1/VRvV7wCfeOAiQN2CAQmKoMzL+JoGA//K
2usAniqHR3h9tbHtqvJ9z8ln/9FHkJiW
=rMVq
-----END PGP SIGNATURE-----

--7SrMUQONj8Rl9QNG--
