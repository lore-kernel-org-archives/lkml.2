Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809Ab1GKORX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:17:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58027 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab1GKORV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:17:21 -0400
Date: Mon, 11 Jul 2011 16:17:12 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Cyril Hrubis <metan@ucw.cz>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, thommycheck@gmail.com,
        Marek Vasut <marek.vasut@gmail.com>,
        Russell King <rmk@arm.linux.org.uk>, arminlitzel@web.de,
        kernel list <linux-kernel@vger.kernel.org>, utx@penguin.cz,
        lenz@cs.wisc.edu, rpurdie@rpsys.net, omegamoon@gmail.com,
        Pavel Machek <pavel@ucw.cz>, eric.y.miao@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        zaurus-devel@www.linuxtogo.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: zaurus patches -- arm/pxa -- is Eric alive
Message-ID: <20110711141712.GD11153@pengutronix.de>
References: <20110711134150.GA15506@localhost.ucw.cz>
 <CALT56yM+fNs_2QorWK0=gr2um1H3vDX+HXPCi9bmKDdOdSvptA@mail.gmail.com>
 <20110711140303.GA32532@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vni90+aGYgRvsTuO"
Content-Disposition: inline
In-Reply-To: <20110711140303.GA32532@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vni90+aGYgRvsTuO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 11, 2011 at 04:03:03PM +0200, Cyril Hrubis wrote:
> Hi!
> > > There are some rather critical patches for zaurus C-3000 (spitz)
> > > available... with no response. What is going on?
> >=20
> > Eric seems alive. At least he've sent pull requests few days ago.
> > Maybe you can point to those patches, that you mention as critical?
>=20
> Perhaps the most critical one is:
>=20
> [PATCH] MAX1111: Fix race condition causing NULL pointer exception
>=20
> http://ns1.yosemitephotos.net/lists/arm-kernel/msg125356.html

Ahem, this one was opposed to. The right one seems to be:

http://ns1.yosemitephotos.net/lists/arm-kernel/msg125592.html

Note that it is a hwmon-driver and neither the apropriate list nor
maintainers have been CCed. Eric cannot take this patch. Check
MAINTAINERAS (or use scripts/get_maintainer.pl) to find the right people
and this will increase chances to get your patch upstream a lot.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--vni90+aGYgRvsTuO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk4bBegACgkQD27XaX1/VRtk9ACfeKehBPKmwhbipEkzrSkj1RAT
D60An14xCkXgGiL2XbNr7MLjHQt2GtRs
=0Ar8
-----END PGP SIGNATURE-----

--vni90+aGYgRvsTuO--
