Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562Ab2CGSQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:16:49 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50058 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab2CGSQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:16:48 -0500
Date: Wed, 7 Mar 2012 19:16:31 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Feng Tang <feng.tang@intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c-eg20t: Rework pch_i2c_wait_for_bus_idle to reduce
 wait time
Message-ID: <20120307181631.GC1130@pengutronix.de>
References: <1329725656-32715-1-git-send-email-alexander.stein@systec-electronic.com>
 <20120301101502.GB2535@pengutronix.de>
 <CANKRQniA2icHddFG22r7VtLTuoefbK61tpcUQnXgShFHuffUuA@mail.gmail.com>
 <2041940.hOTQq1CLVz@ws-stein>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ghzN8eJ9Qlbqn3iT"
Content-Disposition: inline
In-Reply-To: <2041940.hOTQq1CLVz@ws-stein>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ghzN8eJ9Qlbqn3iT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > Alexander's patch looks good.
> > Did Alexander test i2c-eg20t driver with this patch ?
>=20
> Yes, I did test it.

Applied to for-3.4, thanks!

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ghzN8eJ9Qlbqn3iT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9Xpf8ACgkQD27XaX1/VRtKqgCeKEQt9C9HEGEWQplDoz44gncA
SMQAn1xMID0ybya2qjwtggb3fUez6tDt
=ADwC
-----END PGP SIGNATURE-----

--ghzN8eJ9Qlbqn3iT--
