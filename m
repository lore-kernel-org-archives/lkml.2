Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab2AXTZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 14:25:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37432 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab2AXTZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 14:25:57 -0500
Date: Tue, 24 Jan 2012 20:25:45 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, Kevin Wells <kevin.wells@nxp.com>
Subject: LPC32xx status (Re: [PATCH] Correct bad gpio naming)
Message-ID: <20120124192545.GB8502@pengutronix.de>
References: <4F1C4E25.6070801@antcom.de>
 <20120124155921.GH2609@pengutronix.de>
 <4F1EDD15.7010704@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZoaI/ZTpAVc4A5k6"
Content-Disposition: inline
In-Reply-To: <4F1EDD15.7010704@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZoaI/ZTpAVc4A5k6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > Since you are modifying LPC32xx :) Which kernel version do you run?
> > I was trying to get a board up with 3.0 (not booting) and 3.3-rc1
> > (build breakage). I even thought about removing that mach, since
> > vital parts seem to be missing (Net, NAND) or broken. So, I am
> > interested if there are still users.
>=20
> I'm actively maintaining an LPC32xx machine line (WORK Microwave GmbH
> devices) at http://git.antcom.de/ - feel free to merge from there.

Cool, best answer I could get \o/

> Expect the first one of the drivers to be submitted soon, I will do
> them one by one.

I think the first step should be adding a generic defconfig and make sure t=
his
builds and boots (I think I have a phy3250 somewhere, so I could test). Aft=
er
that new drivers would make sense. IIRC clock.c was pretty broken, we needed
hacks to get USB working with a 2.6.35. I also see that your tree modifies =
it.

Kevin: Are you with us?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ZoaI/ZTpAVc4A5k6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8fBbkACgkQD27XaX1/VRvu7gCdFH4bsuflYODA2YDNvsqppJ1z
/jwAnAyqEE+trIVoxLbVJVZETnbw5HOU
=xLI5
-----END PGP SIGNATURE-----

--ZoaI/ZTpAVc4A5k6--
