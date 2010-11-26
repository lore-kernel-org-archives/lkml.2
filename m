Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab0KZKFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:05:11 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33474 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab0KZKFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:05:10 -0500
Message-ID: <4CEF864B.6080207@pengutronix.de>
Date: Fri, 26 Nov 2010 11:04:59 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: andrew.chih.howe.khor@intel.com, Samuel Ortiz <sameo@linux.intel.com>,
        margie.foster@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, socketcan-core@lists.berlios.de,
        yong.y.wang@intel.com, kok.howg.ewe@intel.com,
        Wolfgang Grandegger <wg@grandegger.com>, joel.clark@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Christian Pellegrin <chripell@fsfe.org>, qi.wang@intel.com
Subject: Re: [PATCH net-next-2.6 01/19 v5] can: EG20T PCH: Separate Interface
 Register(IF1/IF2)
References: <4CEF150A.7080409@dsn.okisemi.com> <4CEF84BE.7000101@pengutronix.de>
In-Reply-To: <4CEF84BE.7000101@pengutronix.de>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig806125ABFA58D5ED8C3CC374"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig806125ABFA58D5ED8C3CC374
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/26/2010 10:58 AM, Marc Kleine-Budde wrote:
> On 11/26/2010 03:01 AM, Tomoya MORINAGA wrote:
>> Separate interface register from whole of register structure.
>>  CAN register of Intel PCH EG20T has 2 sets of interface register.
>>  To reduce whole of code size, separate interface register.
>>  As a result, the number of function also can be reduced.
>=20
> nitpick: it's unusual to have leading whitespace in the patch descripti=
on.

maybe it's a problem of your mailer.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig806125ABFA58D5ED8C3CC374
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzvhk8ACgkQjTAFq1RaXHPLMQCdHMJoL+mPEOplmIJ3tn2lupau
9ZEAoJOmg3aMKkP4Q73BjzLa5QOe8JW+
=cgNV
-----END PGP SIGNATURE-----

--------------enig806125ABFA58D5ED8C3CC374--
