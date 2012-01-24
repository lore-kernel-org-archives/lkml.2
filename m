Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab2AXVJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 16:09:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33672 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab2AXVJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 16:09:39 -0500
Date: Tue, 24 Jan 2012 22:09:24 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, Kevin Wells <kevin.wells@nxp.com>
Subject: Re: LPC32xx status (Re: [PATCH] Correct bad gpio naming)
Message-ID: <20120124210924.GD8502@pengutronix.de>
References: <4F1C4E25.6070801@antcom.de>
 <20120124155921.GH2609@pengutronix.de>
 <4F1EDD15.7010704@antcom.de>
 <20120124192545.GB8502@pengutronix.de>
 <4F1F16A8.7010407@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wLAMOaPNJ0fu1fTG"
Content-Disposition: inline
In-Reply-To: <4F1F16A8.7010407@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wLAMOaPNJ0fu1fTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Unfortunately, I currently don't have a phy3250, but can check
> tomorrow with colleagues.

Shouldn't matter that much, or? Once the core support is back and works for
your board, others could test with their boards.

> I guess the work92105_defconfig is only useful once the drivers
> currently missing in mainline are merged. Or is there an arm specific
> tree I should update from?

You can keep the work92105_defconfig in your tree, but we'd need to introdu=
ce a
lpc32xx_defconfig. That should start with a minimal (but working) config and
can be extended once the drivers are in place.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--wLAMOaPNJ0fu1fTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8fHgQACgkQD27XaX1/VRsoRgCffgo9rwt65Bl7sZKk5hQ23OCj
jzMAn2GhgA27GFLYOWzDG5tl8uMq1vJY
=c6pk
-----END PGP SIGNATURE-----

--wLAMOaPNJ0fu1fTG--
