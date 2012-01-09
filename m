Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466Ab2AIWRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:17:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52545 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab2AIWRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:17:13 -0500
Date: Mon, 9 Jan 2012 23:17:10 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Austin Boyle <Austin.Boyle@aviatnet.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rtc: ds1307: generalise ram size and offset
Message-ID: <20120109221710.GA15336@pengutronix.de>
References: <1326144071.3096.25.camel@pc786-ubu.gnet.global.vpn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <1326144071.3096.25.camel@pc786-ubu.gnet.global.vpn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Austin,

> Is the git tree you created for the ds1307 still active? How do you go ab=
out getting
> those patches merged into linux-next?

Well, yes, I was "actively" waiting for the rewritten NVRAM handling ;) (ha=
ve I
missed a patch meanwhile?) I will review and pick up the patch in the next =
days
and then send a pull-request to Andrew.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8LZ2YACgkQD27XaX1/VRtOLQCeKGgQ7uznwHUWNtQlFl3kSMuY
67YAoJOx1DFe43Tkl6MeUl2+kFc/Nn3g
=+gl8
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
