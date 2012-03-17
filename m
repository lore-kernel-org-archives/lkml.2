Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab2CQTW0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 15:22:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59942 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab2CQTWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 15:22:23 -0400
Message-ID: <4F64E441.1010806@pengutronix.de>
Date: Sat, 17 Mar 2012 20:21:37 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Geoff Levand <geoff@infradead.org>,
        Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        Jens Osterkamp <jens@de.ibm.com>, Samuel Ortiz <samuel@sortiz.org>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        cbe-oss-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/2] drivers: net: Remove unnecessary line continuations
References: <1d738d4a4dd61978f969ed4a43f2dd3717f51a19.1332011552.git.joe@perches.com> <67ad900b6f6451b5b28b004def471c9a41b1ee24.1332011552.git.joe@perches.com>
In-Reply-To: <67ad900b6f6451b5b28b004def471c9a41b1ee24.1332011552.git.joe@perches.com>
X-Enigmail-Version: 1.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC13B6932E2237BCE0BF9A2C1"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC13B6932E2237BCE0BF9A2C1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/17/2012 08:14 PM, Joe Perches wrote:
> Line continuations are error prone so just remove them.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/can/usb/peak_usb/pcan_usb_pro.c  |    4 ++--
>  drivers/net/ethernet/micrel/ks8695net.c      |    4 ++--
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c |    3 +--
>  drivers/net/ethernet/toshiba/spider_net.c    |    4 ++--
>  drivers/net/irda/bfin_sir.c                  |    4 ++--
>  drivers/net/phy/et1011c.c                    |    9 +++++----
>  6 files changed, 14 insertions(+), 14 deletions(-)

For the peak_usb:
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigC13B6932E2237BCE0BF9A2C1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk9k5EYACgkQjTAFq1RaXHNvqACfcA8xYJdhqLIJuZ9UNECRiD6P
AdcAoJS+B5nTjsu/VOTdaegOYL8PeJJt
=QmIL
-----END PGP SIGNATURE-----

--------------enigC13B6932E2237BCE0BF9A2C1--
