Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2DCQrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 12:47:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56306 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab2DCQrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 12:47:03 -0400
Date: Tue, 3 Apr 2012 18:46:59 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Ivo Sieben <meltedpianoman@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Chris Wright <chrisw@sous-sol.org>, gregkh@linuxfoundation.org
Subject: Re: [PATCH-v3] Support M95040 SPI EEPROM
Message-ID: <20120403164659.GB2477@pengutronix.de>
References: <1333434302-14897-1-git-send-email-meltedpianoman@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jq0ap7NbKX2Kqbes"
Content-Disposition: inline
In-Reply-To: <1333434302-14897-1-git-send-email-meltedpianoman@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jq0ap7NbKX2Kqbes
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 03, 2012 at 08:25:02AM +0200, Ivo Sieben wrote:
> Updated the generic SPI EEPROM driver AT25 for support of an additional a=
ddress
> bit in the instruction byte. Certain EEPROMS have a size that is larger t=
han the
> number of address bytes would allow (e.g. like M95040 from ST that has 51=
2 Byte
> size but uses only one address byte (A0 to A7) for addressing.) For the e=
xtra
> address bit (A8, A16 or A24) bit 3 of the instruction byte is used. This
> instruction bit is normally defined as don't care for other AT25 like chi=
ps.
>=20
> Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>

Thanks for keeping at it!

Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

I could also pick it up (since I am looking after at24, so that fits someho=
w),
but Greg's tree is maybe the more obvious place.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--jq0ap7NbKX2Kqbes
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk97KYMACgkQD27XaX1/VRugaQCfUPBaL4HFGOWl38WXAkHxV6kF
G98AoK8xGZgPpS17QaXewWJSqIjViosC
=HjAB
-----END PGP SIGNATURE-----

--jq0ap7NbKX2Kqbes--
