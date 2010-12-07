Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0LGICq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 03:02:46 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60403 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab0LGICo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 03:02:44 -0500
Message-ID: <4CFDEA1A.6020806@pengutronix.de>
Date: Tue, 07 Dec 2010 09:02:34 +0100
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
References: <4CECC07E.40804@dsn.okisemi.com> <4CECEE1E.9030201@pengutronix.de> <EA73672426864370BC8119DE78037132@hacdom.okisemi.com>
In-Reply-To: <EA73672426864370BC8119DE78037132@hacdom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig93A2F7F10533C91968A7794E"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig93A2F7F10533C91968A7794E
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: quoted-printable

On 12/07/2010 01:46 AM, Tomoya MORINAGA wrote:
> On Wednesday, November 24, 2010 7:51 PM, Marc Kleine-Budde wrote:
>> Did your mailer spawn some extra spaces here? The header of your mail
>> tells me:
>> "User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.1.15)
>> Gecko/20101027 Thunderbird/3.0.10"
>> I strongly suggest to use git send-email.
>=20
> At last, I can use "git send-email".
> However, I have faced issue.
> In case single destination address is OK, but in case multiple address
> is set,
> I can see the following error.
>=20
> Relay access denied
>=20
> I show my failure command.
> git send-email --smtp-server xxx.com --smtp-server-port yyy --smtp-ssl
> -to aaa.com -to bbb.com -to ccc.com
> -cc ccc.com -cc ddd.com -cc eee.com -bcc fff.com -bcc ggg.com *.patch

According to my man page it's:

--cc=3D<address>
--to=3D<address>

> Do you have any information about the issue ?

Try the above parameter format, if it doesn't work talk to your IT guys.
Have the time stamp and involved addresses (to,cc,smtp-server) of a
working and not working git send-email attempt ready.

cheers, Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig93A2F7F10533C91968A7794E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkz96hoACgkQjTAFq1RaXHPbQACfbHEcfP5jy44qPVA5iAA7ELiD
834An0X8zTf+cwAqXQmoKO/dyWuPktGu
=n1bF
-----END PGP SIGNATURE-----

--------------enig93A2F7F10533C91968A7794E--
