Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab1AYU6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 15:58:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45362 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab1AYU6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:58:15 -0500
Date: Tue, 25 Jan 2011 21:57:54 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-i2c@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Jarod Wilson <jarod@redhat.com>, Joe Perches <joe@perches.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] drivers/staging/lirc: Remove obsolete cleanup for
 clientdata
Message-ID: <20110125205754.GB22589@pengutronix.de>
References: <1295865880-27672-1-git-send-email-w.sang@pengutronix.de>
 <1295865880-27672-4-git-send-email-w.sang@pengutronix.de>
 <1295914142.2420.29.camel@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline
In-Reply-To: <1295914142.2420.29.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 24, 2011 at 07:09:02PM -0500, Andy Walls wrote:
> On Mon, 2011-01-24 at 11:44 +0100, Wolfram Sang wrote:
> > A few new i2c-drivers came into the kernel which clear the clientdata-p=
ointer
> > on exit or error. This is obsolete meanwhile, the core will do it. Simp=
lify the
> > kfree() calls after that, the pointers don't need to be checked.
> >=20
> > Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> > Cc: Andy Walls <awalls@md.metrocast.net>
>=20
> Nak.
>=20
> In a module where I plan to do more cleanup and add reference counting
> to struct IR, IR_tx, and IR_rx objects, I'd like the explicit "NULL"s in
> pointer checks to stay in for now.

Okay, I will ignore this driver until it comes out of staging.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk0/OVIACgkQD27XaX1/VRthgACgnah2/2nSjroHHkLiFZ7bWoq1
NHwAoKCl7Ssi8OraQFvUPerNR30byc3j
=ZOSa
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
