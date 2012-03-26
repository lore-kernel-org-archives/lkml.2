Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab2CZGkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 02:40:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41116 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab2CZGkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 02:40:03 -0400
Date: Mon, 26 Mar 2012 08:39:56 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        Ralf Baechle <ralf@linux-mips.org>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] watchdog: Make TXX9_WDT select WATCHDOG_CORE
Message-ID: <20120326063956.GB24023@pengutronix.de>
References: <1332739713.15735.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Content-Disposition: inline
In-Reply-To: <1332739713.15735.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 26, 2012 at 01:28:33PM +0800, Axel Lin wrote:
> This is required after converting to watchdog core API.
>=20
> Fix below build errors:
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `txx9wdt_probe':
> txx9wdt.c:(.init.text+0x3530): undefined reference to `watchdog_register_=
device'
> drivers/built-in.o: In function `txx9wdt_remove':
> txx9wdt.c:(.exit.text+0x158): undefined reference to `watchdog_unregister=
_device'
> make: *** [.tmp_vmlinux1] Error 1
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

Can we simply fold this into the original patch?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9wDzwACgkQD27XaX1/VRvE5QCeKVJ0uyOCVqX/grcGYumNx/Gr
bI0An2xLF7DyLRkKJAx2W+7QPhlLHKn5
=FQmU
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--
