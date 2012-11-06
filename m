Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab2KFLo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:44:28 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34196 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab2KFLo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:44:27 -0500
Message-ID: <5098F7FF.1090100@pengutronix.de>
Date: Tue, 06 Nov 2012 12:43:59 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Chuansheng Liu <chuansheng.liu@intel.com>
CC: wg@grandegger.com, linux-kernel@vger.kernel.org,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Subject: Re: [PATCH 5/7] can: janz-ican3: Fix the usage of wait_for_completion_timeout
References: <1352222317.15558.1584.camel@cliu38-desktop-build>  <1352222480.15558.1587.camel@cliu38-desktop-build>  <1352222555.15558.1589.camel@cliu38-desktop-build>  <1352222894.15558.1595.camel@cliu38-desktop-build> <1352223097.15558.1599.camel@cliu38-desktop-build>
In-Reply-To: <1352223097.15558.1599.camel@cliu38-desktop-build>
X-Enigmail-Version: 1.4.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig33D4E66B0263FF929BF15C72"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig33D4E66B0263FF929BF15C72
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/06/2012 06:31 PM, Chuansheng Liu wrote:
>=20
> The return value of wait_for_completion_timeout() is always
>> =3D 0 with unsigned int type.
>=20
> So the condition "ret < 0" or "ret >=3D 0" is pointless.
>=20
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>

Thnx, applied to can-next. Please put linux-can@vger.kernel.org on Cc
next time.

regards, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig33D4E66B0263FF929BF15C72
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlCY+AUACgkQjTAFq1RaXHOobgCfUHoVe2BsdBTAA+j903cmJwhY
vusAoIZO2mqf5qFcqUmzIeNOTUlqnOB1
=VepF
-----END PGP SIGNATURE-----

--------------enig33D4E66B0263FF929BF15C72--
