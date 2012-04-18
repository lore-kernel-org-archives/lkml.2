Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab2DRKzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 06:55:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52730 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab2DRKzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 06:55:36 -0400
Date: Wed, 18 Apr 2012 12:55:29 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: ben-linux@fluff.org, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        kyungmin.park@samsung.com, hskinnemoen@gmail.com,
        bigeasy@linutronix.de, dirk.brandewie@gmail.com,
        linux@arm.linux.org.uk
Subject: Re: [PATCH v2 0/2] i2c: Don't assume bus nr 0 if none was specified
Message-ID: <20120418105529.GA21955@pengutronix.de>
References: <1332839428-29705-1-git-send-email-k.lewandowsk@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <1332839428-29705-1-git-send-email-k.lewandowsk@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 27, 2012 at 11:10:26AM +0200, Karol Lewandowski wrote:
> Changes since v1:
>  - Dropped reduntant i2c-octeon change
>=20
> i2c controller drivers used to assume bus number 0 when none (-1) was
> specified.
>=20
> This worked on non-device tree systems, where one could explicitly
> specify bus number via platform data.  On DT-enabled systems bus
> number is always -1.
>=20
> This patchset reworks few remaining drivers to use dynamic bus
> allocation when no id has been provided.

Thanks, both applied.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+OnaEACgkQD27XaX1/VRsEjQCaA6liUIwu127RZSud9mMPKjGY
p5kAn0k0kak9WIGmCFthJRMTv2V7OX70
=S+8z
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
