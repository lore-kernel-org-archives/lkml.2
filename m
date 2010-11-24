Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab0KXKvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 05:51:23 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36723 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab0KXKvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 05:51:20 -0500
Message-ID: <4CECEE1E.9030201@pengutronix.de>
Date: Wed, 24 Nov 2010 11:51:10 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, margie.foster@intel.com
Subject: Re: [PATCH net-next-2.6 8/17 v2] can: EG20T PCH: Change Copyright
 and module description
References: <4CECC07E.40804@dsn.okisemi.com>
In-Reply-To: <4CECC07E.40804@dsn.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF8EE888FFA995888BFE0095D"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF8EE888FFA995888BFE0095D
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: quoted-printable

On 11/24/2010 08:36 AM, Tomoya MORINAGA wrote:
> Currently, Copyright and module description are not formal.
>=20
>=20
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  drivers/net/can/pch_can.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
> index 5b7a392..3a39786 100644
> --- a/drivers/net/can/pch_can.c
> +++ b/drivers/net/can/pch_can.c
> @@ -1,6 +1,6 @@
>  /*
>   * Copyright (C) 1999 - 2010 Intel Corporation.
> - * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
> + * Copyright (C) 2010 OKI SEMICONDUCTOR CO., LTD.
>   *
>   * This program is free software; you can redistribute it and/or modif=
y
>   * it under the terms of the GNU General Public License as published b=
y
> @@ -1312,6 +1312,6 @@ static void __exit pch_can_pci_exit(void)
>  }
>  module_exit(pch_can_pci_exit);
>  -MODULE_DESCRIPTION("Controller Area Network Driver");
 ^^

Did your mailer spawn some extra spaces here? The header of your mail
tells me:
"User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.1.15)
Gecko/20101027 Thunderbird/3.0.10"
I strongly suggest to use git send-email.

> +MODULE_DESCRIPTION("Intel EG20T PCH CAN(Controller Area Network) Drive=
r");
>  MODULE_LICENSE("GPL v2");
>  MODULE_VERSION("0.94");

cheers, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigF8EE888FFA995888BFE0095D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzs7iIACgkQjTAFq1RaXHOtNQCfZxlM6esM/5w5B8x16TfKXg8d
GacAnjpX0crS3cxvJNY6ehTcaCN9LDB5
=V2Dp
-----END PGP SIGNATURE-----

--------------enigF8EE888FFA995888BFE0095D--
