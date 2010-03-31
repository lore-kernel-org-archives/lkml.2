Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab0CaJsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 05:48:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41406 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757480Ab0CaJsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 05:48:43 -0400
Message-ID: <4BB31A6A.1000503@pengutronix.de>
Date: Wed, 31 Mar 2010 11:48:26 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Anders Darander <anders.darander@datarespons.se>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jpirko@redhat.com>,
       Erik Waling <erik.waling@konftel.com>,
       Patrick McHardy <kaber@trash.net>,
       Grant Likely <grant.likely@secretlab.ca>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1270025218-7245-1-git-send-email-anders.darander@gmail.com> <4BB31345.5050101@pengutronix.de> <20100331093956.GI4837@datarespons.se>
In-Reply-To: <20100331093956.GI4837@datarespons.se>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE182812377EC455E0692276B"
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: mkl@pengutronix.de
Subject: Re: [PATCH][V2] MACB: Set PHY address in kernel parameters
X-SA-Exim-Version: 4.2.1 (built Sat, 01 Aug 2009 12:09:26 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE182812377EC455E0692276B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Anders Darander wrote:
> * Marc Kleine-Budde <mkl@pengutronix.de> [100331 11:18]:
>> We're using phy_mask in one of our projects, it's still using 2.6.29,
>> though. I think it's worth testing if it's still working.
>=20
> Well, that was obviously something I overlooked / misinterpreted when I=

> tried to solve our problem!
>=20
> As I understand it, phy_mask is a bitfield for setting which PHYs shoul=
d
> be enabled... Then this should have worked OK for us!

Yes, it's a bitmask of PHYs that should be probed.

>> static struct at91_eth_data __initdata p298_macb_data =3D {
>>        .is_rmii        =3D 0,
>>        .phy_mask       =3D ~(1 << 8),
>> };
>=20
>> at91_add_device_eth(&p298_macb_data);
>=20
> I've not tested it, but it should probably have worked.

Cheers, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigE182812377EC455E0692276B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkuzGm0ACgkQjTAFq1RaXHP/LwCffHp5r4vbIXqApoISTtG0iEvH
XOAAoIikIu69SmyOExQt6vXU2UWsXR9X
=k7tM
-----END PGP SIGNATURE-----

--------------enigE182812377EC455E0692276B--
