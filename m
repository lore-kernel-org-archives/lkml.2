Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab2ICJCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:02:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42941 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab2ICJCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:02:32 -0400
Message-ID: <5044721B.8030507@pengutronix.de>
Date: Mon, 03 Sep 2012 11:02:19 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: netdev@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org
Subject: Re: [PATCH] net/can:  rename peak_usb dump_mem function
References: <1346577700-8156-1-git-send-email-geert@linux-m68k.org> <504393A7.8040007@xenotime.net>
In-Reply-To: <504393A7.8040007@xenotime.net>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig53A119B1730FC3E6BD971FDC"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig53A119B1730FC3E6BD971FDC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/02/2012 07:13 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>=20
> Rename generic-sounding function dump_mem() to pcan_dump_mem()
> so that it does not conflict with the dump_mem() function in
> arch/sh/include/asm/kdebug.h.
>=20
> drivers/net/can/usb/peak_usb/pcan_usb_core.c: error: conflicting types =
for 'dump_mem':  =3D> 56:6
> drivers/net/can/usb/peak_usb/pcan_usb_core.h: error: conflicting types =
for 'dump_mem':  =3D> 134:6
>=20
> Not tested.

:) I've converted the users of peak's dump_mem() function, too. Now it
compiles. Should this go into v3.6, or is v3.7 early enough?

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig53A119B1730FC3E6BD971FDC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBEchsACgkQjTAFq1RaXHOxvgCeMgKpXKqbuvwjk5E1ztkdi2L0
bVgAoIVvPIsepqwIFp3CqGovX8OEWUu7
=s4ws
-----END PGP SIGNATURE-----

--------------enig53A119B1730FC3E6BD971FDC--
