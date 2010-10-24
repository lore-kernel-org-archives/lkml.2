Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051Ab0JXWFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 18:05:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38330 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938Ab0JXWFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 18:05:41 -0400
Message-ID: <4CC4ADA5.8@pengutronix.de>
Date: Mon, 25 Oct 2010 00:05:25 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: masa-korg@dsn.okisemi.com, andrew.chih.howe.khor@intel.com,
        sameo@linux.intel.com, margie.foster@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, socketcan-core@lists.berlios.de,
        kok.howg.ewe@intel.com, wg@grandegger.com, morinaga526@dsn.okisemi.com,
        joel.clark@intel.com, yong.y.wang@intel.com, chripell@fsfe.org,
        qi.wang@intel.com
Subject: Re: [PATCH net-next-2.6 v1] can: Topcliff: Update PCH_CAN driver
 to 2.6.35
References: <4CB8506C.3060600@dsn.okisemi.com> <20101024.144312.104048720.davem@davemloft.net>
In-Reply-To: <20101024.144312.104048720.davem@davemloft.net>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD10F051E7E369ACAD92D1E86"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD10F051E7E369ACAD92D1E86
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/24/2010 11:43 PM, David Miller wrote:
> From: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
> Date: Fri, 15 Oct 2010 22:00:28 +0900
>=20
>> CAN driver of Topcliff PCH
>>
>> Topcliff PCH is the platform controller hub that is going to be used i=
n
>> Intel's upcoming general embedded platform. All IO peripherals in
>> Topcliff PCH are actually devices sitting on AMBA bus.=20
>> Topcliff PCH has CAN I/F. This driver enables CAN function.
>>
>> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
>=20
> Applied, thanks.

IMHO this driver needs some improvements. There are some open points
from Wolfgangs and my review. On the other side, it's a new driver and
there's some time left before it hits mainline.

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigD10F051E7E369ACAD92D1E86
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzErakACgkQjTAFq1RaXHNQMQCcCDwCm/Z6wvIYDjDIr0ep3aXY
GmIAoI7dy6vzR8gSozKDnU6Hmaqj63Qd
=2uoL
-----END PGP SIGNATURE-----

--------------enigD10F051E7E369ACAD92D1E86--
