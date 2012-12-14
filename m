Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab2LNVcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 16:32:31 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37787 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456Ab2LNVc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 16:32:29 -0500
Message-ID: <50CB9ADF.6050400@pengutronix.de>
Date: Fri, 14 Dec 2012 22:32:15 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: linux-next: Tree for Dec 14 (net/can)
References: <20121214184216.e05d715c71468f475d8bcfeb@canb.auug.org.au> <50CB7BAD.9040805@infradead.org>
In-Reply-To: <50CB7BAD.9040805@infradead.org>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8648F8A4665292D82D70378F"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8648F8A4665292D82D70378F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/14/2012 08:19 PM, Randy Dunlap wrote:
> On 12/13/12 23:42, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20121213:
>>
>> Lots of conflicts are migrating between trees.
>>
>=20
> on X86_32:
>=20
> drivers/net/can/sja1000/sja1000_of_platform.c: In function 'sja1000_ofp=
_probe':
> drivers/net/can/sja1000/sja1000_of_platform.c:124:13: error: 'NO_IRQ' u=
ndeclared (first use in this function)
> drivers/net/can/sja1000/sja1000_of_platform.c:124:13: note: each undecl=
ared identifier is reported only once for each function it appears in
> make[5]: *** [drivers/net/can/sja1000/sja1000_of_platform.o] Error 1

Thanks. Fixed, I'm going to send a pull-request to David Miller.

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig8648F8A4665292D82D70378F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlDLmuIACgkQjTAFq1RaXHMY+wCeI6hjAK6Y03IlsbQSmlLtQKwR
DUAAn0nGWOBhGT41I88aBih9i431LYtB
=/tNH
-----END PGP SIGNATURE-----

--------------enig8648F8A4665292D82D70378F--
