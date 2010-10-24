Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab0JXWPe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 18:15:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56791 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933062Ab0JXWPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 18:15:31 -0400
Message-ID: <4CC4AFF9.90009@pengutronix.de>
Date: Mon, 25 Oct 2010 00:15:21 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: andrew.chih.howe.khor@intel.com, socketcan-core@lists.berlios.de,
        sameo@linux.intel.com, margie.foster@intel.com, netdev@vger.kernel.org,
        chripell@fsfe.org, linux-kernel@vger.kernel.org, yong.y.wang@intel.com,
        masa-korg@dsn.okisemi.com, kok.howg.ewe@intel.com,
        joel.clark@intel.com, morinaga526@dsn.okisemi.com, wg@grandegger.com,
        qi.wang@intel.com
Subject: Re: [PATCH net-next-2.6 v1] can: Topcliff: Update PCH_CAN driver
 to 2.6.35
References: <4CB8506C.3060600@dsn.okisemi.com>	<20101024.144312.104048720.davem@davemloft.net>	<4CC4ADA5.8@pengutronix.de> <20101024.150905.39179588.davem@davemloft.net>
In-Reply-To: <20101024.150905.39179588.davem@davemloft.net>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF19D9FFDB3F1EE694E8482CE"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF19D9FFDB3F1EE694E8482CE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/25/2010 12:09 AM, David Miller wrote:
> From: Marc Kleine-Budde <mkl@pengutronix.de>
> Date: Mon, 25 Oct 2010 00:05:25 +0200
>=20
>> On 10/24/2010 11:43 PM, David Miller wrote:
>>> From: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
>>> Date: Fri, 15 Oct 2010 22:00:28 +0900
>>>
>>>> CAN driver of Topcliff PCH
>>>>
>>>> Topcliff PCH is the platform controller hub that is going to be used=
 in
>>>> Intel's upcoming general embedded platform. All IO peripherals in
>>>> Topcliff PCH are actually devices sitting on AMBA bus.=20
>>>> Topcliff PCH has CAN I/F. This driver enables CAN function.
>>>>
>>>> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
>>>
>>> Applied, thanks.
>>
>> IMHO this driver needs some improvements. There are some open points
>> from Wolfgangs and my review. On the other side, it's a new driver and=

>> there's some time left before it hits mainline.
>=20
> When people have more than a week to review and provide feedback,
> and don't, I have zero sympathy especially this early in the
> release cycle.

Let me see....Crap, it's my fault, I just replied to the socketcan
mailinglist ;( [1]

> So if adding it to the tree is what I have to do to get you guys to
> post your comments and suggest fixes, then that's what I am going to
> (continue) to do. :-)

=2E..or to learn how to reply properly :)

regards, Marc

[1]
https://lists.berlios.de/pipermail/socketcan-core/2010-October/004757.htm=
l
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigF19D9FFDB3F1EE694E8482CE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzEr/0ACgkQjTAFq1RaXHNN1QCgic3MJusAQnGIGNIFqgpl7oR3
5QMAn0VvKXyVl/IUFVQDZRcE9l5M4SlM
=qrqH
-----END PGP SIGNATURE-----

--------------enigF19D9FFDB3F1EE694E8482CE--
