Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751096Ab1ADXFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:05:11 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41166 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab1ADXFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:05:09 -0500
Date: Wed, 5 Jan 2011 00:05:08 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 0/2] Annotate gpio-configuration with __must_check
Message-ID: <20110104230508.GA18363@pengutronix.de>
References: <1294159868-4989-1-git-send-email-w.sang@pengutronix.de>
 <20110104202718.GA31444@suse.de>
 <20110104212916.GA14436@pengutronix.de>
 <20110104213414.GA6774@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <20110104213414.GA6774@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > should fail if it cannot be requested. Or not. Things get worse for
> > architectures I never used before. This is why I think it is really bet=
ter to
> > let people do the fixups who have/understand the hardware in question.
> > Otherwise the fixups could indeed be more harmful than helpful.
>=20
> Sure, they could be more harmful, but at least try.  Make the patches
> up, submit them to the maintainers, and if they are wrong, they will be
> the best to fix it up properly.

Well, I could generalize all cases and always issue a WARN() if the request
fails. But this would just move a compile-time warning into a runtime warni=
ng.
Also, I have my doubts that even the arch/mach-maintainers know all the boa=
rds
and their peculiarities. There are thousands of them.

Kind regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk0jp6QACgkQD27XaX1/VRsTzwCgin8EKY94gE24ZiTNIGcVJn83
u6YAnjlOwk889mitgaMRwjVsxG5p+66E
=4/6t
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
