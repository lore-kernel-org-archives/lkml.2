Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab2CZGh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 02:37:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41107 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab2CZGh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 02:37:56 -0400
Date: Mon, 26 Mar 2012 08:37:48 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        Ralf Baechle <ralf@linux-mips.org>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] watchdog: Fix build error in txx9wdt.c
Message-ID: <20120326063748.GA24023@pengutronix.de>
References: <1332738134.10660.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <1332738134.10660.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 26, 2012 at 01:02:14PM +0800, Axel Lin wrote:
> we need to get clk_get_rate(txx9_imclk) before using WD_MAX_TIMEOUT.
>=20
> This patch fixes below build errors:
>   CC      drivers/watchdog/txx9wdt.o
> drivers/watchdog/txx9wdt.c:104: error: initializer element is not constant
> drivers/watchdog/txx9wdt.c:104: error: (near initialization for =E2=80=98=
txx9wdt.max_timeout=E2=80=99)
> make[2]: *** [drivers/watchdog/txx9wdt.o] Error 1
> make[1]: *** [drivers/watchdog] Error 2
> make: *** [drivers] Error 2
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9wDrwACgkQD27XaX1/VRvn3QCfSqSPwwJPED639BA233+CQDz+
UlIAn2mJjQn0tzM5hO8wdKzyz6zFIZs3
=kDVw
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
