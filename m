Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab0C3M1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 08:27:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48503 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384Ab0C3M1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 08:27:43 -0400
Date: Tue, 30 Mar 2010 14:26:44 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH 01/24] mtd/maps/pismo: remove dangling pointer and a
	leak
Message-ID: <20100330122644.GC29472@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de> <1269094385-16114-2-git-send-email-w.sang@pengutronix.de> <20100320145729.GA5399@flint.arm.linux.org.uk> <20100320153146.GB5515@pengutronix.de> <20100320154113.GB14470@flint.arm.linux.org.uk> <1269160241.4028.9777.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wxDdMuZNg1r63Hyj"
Content-Disposition: inline
In-Reply-To: <1269160241.4028.9777.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wxDdMuZNg1r63Hyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 21, 2010 at 08:30:41AM +0000, David Woodhouse wrote:

> > Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
> >=20
> > David, are you going to pick this up?=20
>=20
> http://git.infradead.org/mtd-2.6.git/commitdiff/395b2288

Thanks. The handling of the dangling pointer will be handled differently fr=
om
2.6.35 on, but I will prepare the necessary fixup then. The fixed leak was
good to have, I think.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--wxDdMuZNg1r63Hyj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkux7gQACgkQD27XaX1/VRtZqgCgw6MZ9rJru+nE6a2mkxJ98Cco
khMAoJrN2JlWKWJeHTzq/t9FwLMVUq7t
=S2Us
-----END PGP SIGNATURE-----

--wxDdMuZNg1r63Hyj--
