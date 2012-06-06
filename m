Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899Ab2FFVww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:52:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53350 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab2FFVwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:52:51 -0400
Message-ID: <4FCFD112.1070106@pengutronix.de>
Date: Wed, 06 Jun 2012 23:52:18 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Wolfgang Grandegger <wg@grandegger.com>, kernel-janitors@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com,
        Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 7/7] drivers/net/can/cc770/cc770_platform.c: adjust suspicious
 bit operation
References: <1339018901-28439-1-git-send-email-Julia.Lawall@lip6.fr> <1339018901-28439-8-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1339018901-28439-8-git-send-email-Julia.Lawall@lip6.fr>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF0B5B7A6CB9E6AD33DD9FC5D"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF0B5B7A6CB9E6AD33DD9FC5D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/06/2012 11:41 PM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> CPUIF_DSC is 0x40, so it would seem that & is wanted rather than |.
>=20
> This problem was found using Coccinelle (http://coccinelle.lip6.fr/).
>=20
> Signed-off-by: Julia Lawall <julia@diku.dk>

Good catch, Joe Perches has already found and fixed that problem. It has
been fixed in:

    dc605db can: cc770: Fix likely misuse of | for &

The commit is currently in David's net/master, and scheduled for the
v3.5 release.

Regards, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigF0B5B7A6CB9E6AD33DD9FC5D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk/P0RUACgkQjTAFq1RaXHMcbQCgi/Wo716GQYPqfXM9K/0YXMeZ
84gAoIvJmxcoGBuSuklIYpbxP0e2zPyn
=8dej
-----END PGP SIGNATURE-----

--------------enigF0B5B7A6CB9E6AD33DD9FC5D--
