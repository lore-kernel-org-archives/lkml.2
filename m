Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0KYMkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 07:40:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51922 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab0KYMkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 07:40:11 -0500
Message-ID: <4CEE5921.40304@pengutronix.de>
Date: Thu, 25 Nov 2010 13:40:01 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: andrew.chih.howe.khor@intel.com, socketcan-core@lists.berlios.de,
        Samuel Ortiz <sameo@linux.intel.com>, margie.foster@intel.com,
        netdev@vger.kernel.org, Christian Pellegrin <chripell@fsfe.org>,
        linux-kernel@vger.kernel.org, yong.y.wang@intel.com,
        kok.howg.ewe@intel.com, joel.clark@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Wolfgang Grandegger <wg@grandegger.com>, qi.wang@intel.com
Subject: Re: [PATCH net-next-2.6 v3] can: Topcliff: PCH_CAN driver: Add Flow
 control,
References: <4CE2434B.5050701@dsn.okisemi.com>	<4CE27796.2000206@pengutronix.de>	<007401cb87b1$a773b3d0$66f8800a@maildom.okisemi.com>	<4CE64167.2030405@pengutronix.de> <003201cb8a02$f05b15e0$66f8800a@maildom.okisemi.com> <4CEA2986.4080607@pengutronix.de> <000b01cb8b6b$d7542a90$66f8800a@maildom.okisemi.com> <4CED0650.7030004@pengutronix.de> <001b01cb8c98$d06aaa00$66f8800a@maildom.okisemi.com> <4CEE51CA.8010402@pengutronix.de> <002f01cb8c9d$103f7760$66f8800a@maildom.okisemi.com>
In-Reply-To: <002f01cb8c9d$103f7760$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6E75CF61E0C27555F9E3E1A4"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6E75CF61E0C27555F9E3E1A4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/25/2010 01:34 PM, Tomoya MORINAGA wrote:
> On Thursday, November 25, 2010 9:08 PM, Marc Kleine-Budde wrote :=20
>> Why do you Read-Modify-Write for TX? Naively speaking you just need to=

>> push your Data into a Mail/IF/Whatever and push the send button.
>=20
> I see.
> I will implement this.

With "naively speaking", I mean I haven't looked at the Datasheet, maybe
in the real world with real hardware it's needed to do a RMW.

regard, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig6E75CF61E0C27555F9E3E1A4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzuWSQACgkQjTAFq1RaXHPENQCfX9ZKMUdJta10BvLpRoHMeGOi
J6EAnjXWwCDjpS5loCFeSIfjZ2Oz1xd2
=tz/a
-----END PGP SIGNATURE-----

--------------enig6E75CF61E0C27555F9E3E1A4--
