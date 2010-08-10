Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab0HJJZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:25:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51948 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab0HJJZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:25:17 -0400
Date: Tue, 10 Aug 2010 11:25:09 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: rtc-linux@googlegroups.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kevin Wells <wellsk40@gmail.com>,
        Durgesh Pattamatta <durgesh.pattamatta@nxp.com>
Subject: Re: [rtc-linux] [PATCH 2/2] rtc: Add support in Makefile/Kconfig
 for the LPC32XX RTC
Message-ID: <20100810092509.GA4268@pengutronix.de>
References: <1281370650-29520-1-git-send-email-wellsk40@gmail.com>
 <1281370650-29520-3-git-send-email-wellsk40@gmail.com>
 <AANLkTim5HDRi7+ONM4kxKeKda3gZziUiuuK_ohnrwrAP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <AANLkTim5HDRi7+ONM4kxKeKda3gZziUiuuK_ohnrwrAP@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 10, 2010 at 09:45:49AM +0800, Wan ZongShun wrote:
> Hi Kevin ,
>=20
> 2010/8/10  <wellsk40@gmail.com>:
> > From: Kevin Wells <wellsk40@gmail.com>
> >
> > Enable build RTC support for the LPC32XX in makefile/Kconfig
> >
>=20
> I think you can intergrate two patches [PATCH 1/2 2/2] into one rtc
> driver patch.

+1. Also, please make proper use of tabs like the surrounding entries.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxhGvUACgkQD27XaX1/VRugGwCgtMCeneAJyJMzAofLsb51fjLV
rM0AmQHerHc0FJ0NvpDr5S0gAtbcRlS7
=NyDG
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
