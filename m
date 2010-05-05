Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912Ab0EEH7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 03:59:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44308 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab0EEH7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 03:59:42 -0400
Message-ID: <4BE1255E.2090109@pengutronix.de>
Date: Wed, 05 May 2010 09:59:26 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
       Kevin Cernekee <kpc.mtd@gmail.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Roel Kluin <roel.kluin@gmail.com>, linux-kernel@vger.kernel.org
References: <1272537664-21603-1-git-send-email-mkl@pengutronix.de>	 <1273036359.3702.35.camel@localhost> <1273036482.3702.37.camel@localhost>
In-Reply-To: <1273036482.3702.37.camel@localhost>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig086463D8969395408A6E84BD"
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: mkl@pengutronix.de
Subject: Re: [PATCH] ubi: init even if mtd device cannot be attached, if built
 into kernel
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig086463D8969395408A6E84BD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Artem Bityutskiy wrote:
> On Wed, 2010-05-05 at 08:12 +0300, Artem Bityutskiy wrote:
>>> +#ifdef CONFIG_MTD_UBI_MODULE
>>> +static inline int ubi_is_module(void) { return 1; }
>>> +#else
>>> +static inline int ubi_is_module(void) { return 0; }
>>> +#endif
>> I really hate these ifdefs. Dunno why, but they feel disgusting.
>>
>> I understand your issue and agree that is should be fixed. And I canno=
t
>> really see a better solution. So if no-one complains, I'll accept your=

>> patch.
>>
>> However, for consistency with other UBI code (see debug.h), please, do=

>> this like
>>
>> #ifdef CONFIG_MTD_UBI_MODULE
>> #define ubi_is_module() 1
>> #else
>> #define ubi_is_module() 1
>> #endif
>=20
> Err, of course the second one should be 0, not 1. I can actually do thi=
s
> modification myself, or you can re-send your patch.

I'll resend a patch.

Cheers, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig086463D8969395408A6E84BD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkvhJWMACgkQjTAFq1RaXHPszwCfYk9/tt0FKmJ8REW2pCNBI2Zl
C/gAoJeRJby4s/ZRtO3Wb6QCJWmoK4aY
=/bA1
-----END PGP SIGNATURE-----

--------------enig086463D8969395408A6E84BD--
