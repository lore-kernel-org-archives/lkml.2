Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab2ELMga (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 08:36:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49679 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab2ELMgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 08:36:22 -0400
Date: Sat, 12 May 2012 14:36:10 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: davinci: Free requested IRQ in remove
Message-ID: <20120512123610.GG20673@pengutronix.de>
References: <1336053396-24974-1-git-send-email-marcus.folkesson@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DNUSDXU7R7AVVM8C"
Content-Disposition: inline
In-Reply-To: <1336053396-24974-1-git-send-email-marcus.folkesson@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DNUSDXU7R7AVVM8C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 03, 2012 at 03:56:36PM +0200, Marcus Folkesson wrote:
> The freed IRQ is not necessary the one requested in probe.
> Even if it was, with two or more i2c-controllers it will fails anyway.
>=20
> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>

Applied to current, thanks!

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--DNUSDXU7R7AVVM8C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+uWToACgkQD27XaX1/VRuoyQCfQxX5csD6HT6ELM7I3GXq6jOI
N3YAn3kFG838Juaxx9AbWY6TSnpnd4ej
=uJzO
-----END PGP SIGNATURE-----

--DNUSDXU7R7AVVM8C--
