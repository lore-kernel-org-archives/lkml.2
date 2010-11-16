Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972Ab0KPIOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 03:14:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39803 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215Ab0KPIOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 03:14:36 -0500
Message-ID: <4CE23D5A.5080606@pengutronix.de>
Date: Tue, 16 Nov 2010 09:14:18 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, andrew.chih.howe.khor@intel.com,
        qi.wang@intel.com, margie.foster@intel.com, yong.y.wang@intel.com,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Add Flow
 control,
References: <4CE0EFA7.9020007@dsn.okisemi.com> <4CE0F92A.40308@pengutronix.de> <001401cb854d$b46e13c0$66f8800a@maildom.okisemi.com>
In-Reply-To: <001401cb854d$b46e13c0$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7FF810E18DA6D1AC9D6D4A36"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7FF810E18DA6D1AC9D6D4A36
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/16/2010 06:18 AM, Tomoya MORINAGA wrote:
> On Monday, November 15, 2010 6:11 PM, Marc Kleine-Budde wrote:
>> Please make it one patch per topic. A review of your patch will follow=
=2E
>=20
> It's too late now.
> This is difficult to separete patch per topic from current our CAN driv=
er.
>=20
> Next time posting another patch, I will do like so.

Sorry, but there is little chance to get a "this patch changes about 10
things" into the kernel, please try to split up the patch.

regards Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig7FF810E18DA6D1AC9D6D4A36
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkziPWAACgkQjTAFq1RaXHP8dgCfbDbriNp1NHjBsjsVQ/6B4cSt
T8MAn05EZ0MDiSUI81Fqg36vH26ooAfd
=znnS
-----END PGP SIGNATURE-----

--------------enig7FF810E18DA6D1AC9D6D4A36--
