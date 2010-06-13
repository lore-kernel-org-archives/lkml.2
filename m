Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab0FMFtf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 01:49:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53123 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab0FMFtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 01:49:33 -0400
Date: Sun, 13 Jun 2010 07:49:32 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Joe Perches <joe@perches.com>
Cc: Fredrik Gustafsson <iveqy@iveqy.com>, apw@canonical.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch.pl skip long lines
Message-ID: <20100613054932.GB17012@pengutronix.de>
References: <20100612170944.GA9121@iveqy.com> <20100613010429.GA31692@pengutronix.de> <1276407372.1449.33.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <1276407372.1449.33.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > Instead of adding another command-line option, I'd suggest to just use =
CHK
> > instead of WARN, so this check will be enabled with --strict. I wonder =
if there
> > is already consensus on deprecating the 80-char-rule?
>=20
> Nope.  There's a vocal contingent that doesn't like it though.
> An earlier thread and suggested patch below.
> http://lkml.org/lkml/2009/12/18/3

Thought so. I like your approach, missed it back then. I'd vote for 132 cha=
rs
as the next limit, though.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkwUcWwACgkQD27XaX1/VRsV6ACfd8Kv9mnBkmVkBHnf1QF6Gckd
Z5IAn1g2IGW9cUzAfXcVQaFFfhcf7uNA
=FuBf
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
