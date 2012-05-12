Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab2ELOLc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 10:11:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44527 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2ELOLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 10:11:30 -0400
Date: Sat, 12 May 2012 16:11:14 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1 2/2] i2c: tegra: notify transfer-complete after
 clearing status.
Message-ID: <20120512141114.GJ20673@pengutronix.de>
References: <1336373179-12739-1-git-send-email-ldewangan@nvidia.com>
 <1336373179-12739-3-git-send-email-ldewangan@nvidia.com>
 <20120512130756.GI20673@pengutronix.de>
 <4FAE6932.7070605@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KZLWU/9q3evlN4nQ"
Content-Disposition: inline
In-Reply-To: <4FAE6932.7070605@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KZLWU/9q3evlN4nQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> It is  fine to stable tag on this change.

Done.

> >Side note: If you see a way to handle the BUG invocations more
> >gracefully, that would be appreciated.
> >
> Ok, I will work towards that.

Thanks!

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--KZLWU/9q3evlN4nQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+ub4IACgkQD27XaX1/VRuN7ACgkY+YR0aXyGlTnT5/HHQjta6t
Mx4An29ofzvxY/MlR2FXKmzq6vD1aI2w
=fU8X
-----END PGP SIGNATURE-----

--KZLWU/9q3evlN4nQ--
