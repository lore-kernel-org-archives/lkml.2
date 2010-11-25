Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab0KYLr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 06:47:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34997 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab0KYLr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 06:47:56 -0500
Message-ID: <4CEE4CE0.7050500@pengutronix.de>
Date: Thu, 25 Nov 2010 12:47:44 +0100
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
Subject: Re: [PATCH net-next-2.6 6/17 v3] can: EG20T PCH: Fix endianness issue
References: <4CED023E.1070009@dsn.okisemi.com>	<4CED13B5.5020309@pengutronix.de> <001c01cb8c91$6e93aef0$66f8800a@maildom.okisemi.com>
In-Reply-To: <001c01cb8c91$6e93aef0$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3B5C7D08EAD3B01DD426A040"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3B5C7D08EAD3B01DD426A040
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/25/2010 12:10 PM, Tomoya MORINAGA wrote:
> On Wednesday, November 24, 2010 10:31 PM,  Marc Kleine-Budde wrote :
>=20
>>> For easy to read, some sub-functions are created.
>>>
>>>
>>> Modify complex "goto" to do~while.
>> What about the next_flag in the rx_normal function? Can you get rid of=

>> it, too?
> Subsequent Patch (11/17 Delete unnecessary ...) deletes "next_flag" in =
the rx_normal function.

Thanks, I've found the patch myself.

cheers, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig3B5C7D08EAD3B01DD426A040
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzuTOQACgkQjTAFq1RaXHNhggCfQ3EkotrK6ihLFzrI168AtcfQ
dYIAn0sjuJhP++eNCf7BF2Lv6XjPLtb8
=DXbc
-----END PGP SIGNATURE-----

--------------enig3B5C7D08EAD3B01DD426A040--
