Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab0LGKiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 05:38:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55651 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab0LGKiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 05:38:11 -0500
Message-ID: <4CFE0E8A.8000204@pengutronix.de>
Date: Tue, 07 Dec 2010 11:38:02 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: Wolfgang Grandegger <wg@grandegger.com>, socketcan-core@lists.berlios.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, margie.foster@intel.com
Subject: Re: [PATCH net-next-2.6 8/17 v2] can: EG20T PCH: Change Copyright
 and module description
References: <175BA60FBA444BE6B858D42E7B602A40@hacdom.okisemi.com>
In-Reply-To: <175BA60FBA444BE6B858D42E7B602A40@hacdom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig059707FAEA01E118B05AF22F"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig059707FAEA01E118B05AF22F
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: quoted-printable

On 12/07/2010 10:50 AM, Tomoya MORINAGA wrote:
>> In case single destination address is OK, but in case multiple address=

>> is set,
>> I can see the following error.
>> Relay access denied
>=20
> The above was not true.
> It seems in case destination mail domain is external, (except
> "@okisemi.com"),
> this error is occurred.
> In fact, in case multiple address with internal domain,
> it is success to send patch.
>=20
> Our smtp server may have restriction of something.
>=20
> It seems I must use mailer "thunderbird" again.

How do you send mail with thunderbord, then? I suppose you use smtp
there, too.

cheers, Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig059707FAEA01E118B05AF22F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkz+Do4ACgkQjTAFq1RaXHN+4wCdGRuESXPgRUMJiJN5dPgSR30b
cUQAn3QIHeLZkwJmBhYtX/134gqd5Foo
=xhyU
-----END PGP SIGNATURE-----

--------------enig059707FAEA01E118B05AF22F--
