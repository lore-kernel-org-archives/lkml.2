Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab0KZMpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 07:45:19 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43170 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab0KZMpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 07:45:17 -0500
Message-ID: <4CEFABBE.7060605@pengutronix.de>
Date: Fri, 26 Nov 2010 13:44:46 +0100
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
        andrew.chih.howe.khor@intel.com, qi.wang@intel.com,
        margie.foster@intel.com, yong.y.wang@intel.com, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [PATCH net-next-2.6 12/17 v3] can: EG20T PCH: Fix bit timing
 calculation issue
References: <4CED037F.6060306@dsn.okisemi.com> <4CED0BF1.1060305@pengutronix.de> <000901cb8cfd$c667d860$66f8800a@maildom.okisemi.com>
In-Reply-To: <000901cb8cfd$c667d860$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF06C29FE98870E19055CAD5F"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF06C29FE98870E19055CAD5F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/26/2010 01:06 AM, Tomoya MORINAGA wrote:
> On Wednesday, November 24, 2010 9:58 PM, Marc Kleine-Budde wrote :
>> Masking here shouldn't be necessary but won't hurt, better play safe.
>=20
> EG20T's baud rate pre-scalar register  is divided to 2 register BITT an=
d BRPE.
> Thus, This mask is necessary.
> In fact, deleting this mask, it couldn't communicate correctly.

You're right.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigF06C29FE98870E19055CAD5F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzvq8EACgkQjTAFq1RaXHNEOwCeIRrb2OHxMl87hj58Zf0z89O2
gZwAn1CaQGo8na79HAbyeZsSGdnevFRb
=EWFk
-----END PGP SIGNATURE-----

--------------enigF06C29FE98870E19055CAD5F--
