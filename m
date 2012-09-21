Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab2IUVwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 17:52:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54333 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab2IUVwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 17:52:40 -0400
Message-ID: <505CE19C.6030205@pengutronix.de>
Date: Fri, 21 Sep 2012 23:52:28 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: netdev@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org
Subject: Re: [PATCH] net/can:  rename peak_usb dump_mem function
References: <1346577700-8156-1-git-send-email-geert@linux-m68k.org> <504393A7.8040007@xenotime.net> <505CDF3F.6040009@xenotime.net>
In-Reply-To: <505CDF3F.6040009@xenotime.net>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2AA0C284398B8F2C9039A6D3"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2AA0C284398B8F2C9039A6D3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/21/2012 11:42 PM, Randy Dunlap wrote:
> On 09/02/2012 10:13 AM, Randy Dunlap wrote:
>=20
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> Rename generic-sounding function dump_mem() to pcan_dump_mem()
>> so that it does not conflict with the dump_mem() function in
>> arch/sh/include/asm/kdebug.h.
>>
>> drivers/net/can/usb/peak_usb/pcan_usb_core.c: error: conflicting types=
 for 'dump_mem':  =3D> 56:6
>> drivers/net/can/usb/peak_usb/pcan_usb_core.h: error: conflicting types=
 for 'dump_mem':  =3D> 134:6
>>
>> Not tested.
>>
>> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Cc: Stephane Grosjean <s.grosjean@peak-system.com>
>> Cc: Wolfgang Grandegger <wg@grandegger.com>
>> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
>=20
>=20
> ping.

The patch is already part of can-next and will be included in the next
pull request to David.

regards, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig2AA0C284398B8F2C9039A6D3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBc4aAACgkQjTAFq1RaXHPbhQCePg2HuWElNS93vdHQ4N5K7+pd
4nkAmwXrsPnaYoxU8piVfPbSY4wffjNj
=0vrN
-----END PGP SIGNATURE-----

--------------enig2AA0C284398B8F2C9039A6D3--
