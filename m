Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab0DVGbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 02:31:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41850 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab0DVGbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 02:31:41 -0400
Date: Thu, 22 Apr 2010 08:31:36 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Joe Perches <joe@perches.com>
Cc: Gustavo Silva <silvagustavosilva@gmail.com>, gregkh@suse.de,
       abbotti@mev.co.uk, devel@driverdev.osuosl.org,
       fmhess@users.sourceforge.net, linux-kernel@vger.kernel.org,
       silvagustavo@users.sourceforge.net
Subject: Re: [PATCH] Staging: Comedi: Drivers: Fix coding style issues in
	dt2801.c
Message-ID: <20100422063136.GJ24384@pengutronix.de>
References: <1271907971-8793-1-git-send-email-silvagustavo@users.sourceforge.net> <1271908811.1730.613.camel@Joe-Laptop.home> <20100422041338.GE24384@pengutronix.de> <1271910971.1730.637.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7PTD44AewjTsiSV"
Content-Disposition: inline
In-Reply-To: <1271910971.1730.637.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7PTD44AewjTsiSV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> KERN_WARNING.  Maybe kernel.h should add:
> #define pr_warn pr_warning=20
>=20
> so there would be symmetry between levels of
> pr_<level>, dev_<level>, netdev_<level>, and netif_<level>

I'd like the symmetry, haven't checked your approach, though.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--C7PTD44AewjTsiSV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvP7UgACgkQD27XaX1/VRuzRACgnNNW9VPJkoXaVRAt2Eg2p4t4
KeMAoKNZQXn3H6AQ4CpJBT6ptr9GO3MP
=g2ch
-----END PGP SIGNATURE-----

--C7PTD44AewjTsiSV--
