Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab1A3StZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 13:49:25 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34819 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1A3StY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 13:49:24 -0500
Date: Sun, 30 Jan 2011 19:49:14 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: David Brownell <david-b@pacbell.net>, Eric Miao <eric.y.miao@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: Make gpio_{request,free}_array gpio array
 parameter const
Message-ID: <20110130184914.GB12801@pengutronix.de>
References: <1296314481-28028-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
Content-Disposition: inline
In-Reply-To: <1296314481-28028-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 29, 2011 at 04:21:21PM +0100, Lars-Peter Clausen wrote:
> gpio_{request,free}_array should not (and do not) modify the passed gpio =
array,
> so make the parameter const.
>=20
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Looks good to me. What about the users of these calls (luckily there don't =
seem
to be many)?

Kind regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk1FsqoACgkQD27XaX1/VRv0UACdHOrPXtn5KX1Z6j7BDtPSgPya
BXcAoLnS/8dgbOndmh/Z+KbExcoKTEet
=Ej2p
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
