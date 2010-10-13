Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab0JMHi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 03:38:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50230 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab0JMHiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 03:38:25 -0400
Message-ID: <4CB561DD.2030304@pengutronix.de>
Date: Wed, 13 Oct 2010 09:38:05 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
CC: qi.wang@intel.com, chripell@fsfe.org, kok.howg.ewe@intel.com,
        morinaga526@dsn.okisemi.com, joel.clark@intel.com,
        socketcan-core@lists.berlios.de, yong.y.wang@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        margie.foster@intel.com, sameo@linux.intel.com,
        andrew.chih.howe.khor@intel.com, David Miller <davem@davemloft.net>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [MeeGo-Dev][PATCH v3] Topcliff: Update PCH_CAN driver to 2.6.35
References: <002e01cb6486$2ed72cc0$66f8800a@maildom.okisemi.com>	<20101005.114506.184852374.davem@davemloft.net>	<000b01cb6503$962bc7f0$66f8800a@maildom.okisemi.com>	<20101005.200904.71120150.davem@davemloft.net>	<4CAC3D94.9010408@grandegger.com> <000c01cb69dc$5d2aaab0$66f8800a@maildom.okisemi.com> <4CB414A2.8020202@pengutronix.de> <000701cb6a8e$60de6900$66f8800a@maildom.okisemi.com>
In-Reply-To: <000701cb6a8e$60de6900$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAB261C5061DAF079BE82C155"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAB261C5061DAF079BE82C155
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/13/2010 06:23 AM, Masayuki Ohtake wrote:
> On Tuesday, October 12, 2010 4:56 PM, Marc Kleine-Budde wrote :
>> I just had a small peak at the datasheet. It seems you can implement t=
he
>> same scheme for rx as on the at91, if you enough rx buffers. In the at=
91
>> driver I use 8+4 =3D 12 buffers for rx. Have a look at the driver, the=
 rx
>> path is documented.
>=20
> Thank you for your suggestion.
> This is valuable for us.
> It seems the at91's Hw benabior similar to ours.
> Using this method, we will implement and test.

Feel free to ask if you have questions regarding the algorithm or the
code or have some code to review.

cheers, Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigAB261C5061DAF079BE82C155
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAky1YeEACgkQjTAFq1RaXHP3UgCeIF/iojFe/jKvr/KdcEsOn4vV
/+IAnRjFtweclJronxQedEdt5TA3xCfS
=hSIz
-----END PGP SIGNATURE-----

--------------enigAB261C5061DAF079BE82C155--
