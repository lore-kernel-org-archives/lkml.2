Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab1CYLHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:07:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60930 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab1CYLHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:07:03 -0400
Message-ID: <4D8C7750.5070102@pengutronix.de>
Date: Fri, 25 Mar 2011 12:06:56 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: multiple definition of `show_mem'
References: <4D8B6140.4020300@pengutronix.de> <alpine.DEB.2.00.1103241522230.26730@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1103241522230.26730@chino.kir.corp.google.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig31BA9E0CA8209B8AD42B4FE8"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig31BA9E0CA8209B8AD42B4FE8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/24/2011 11:22 PM, David Rientjes wrote:
>> current mainline (v2.6.38-7210-gb81a618) on ARM/mxs has the following =
build failure:
>>
>>> lib/lib.a(show_mem.o): In function `show_mem':
>>> .../linux-2.6/lib/show_mem.c:67: multiple definition of `show_mem'
>>> arch/arm/mm/built-in.o:.../linux-2.6/arch/arm/mm/init.c:82: first def=
ined here
>>> make: *** [vmlinux.o] Error 1

[..]

> Sorry about that, Marc.  I have a patch at
>=20
> 	http://marc.info/?l=3Dlinux-kernel&m=3D130100511521954
>=20
> which should fix the issue for you (and I tested it with my arm cross=20
> compiler).

\o/ - the patch is already in mainline, boots like charm on my mx28evk.

regards, Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig31BA9E0CA8209B8AD42B4FE8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk2Md1MACgkQjTAFq1RaXHNqrQCeNpsveSZK342Li8frdc696D8+
umcAoJGrX/OO/dLbTtxJCza/wnQRMqD6
=j1Kd
-----END PGP SIGNATURE-----

--------------enig31BA9E0CA8209B8AD42B4FE8--
