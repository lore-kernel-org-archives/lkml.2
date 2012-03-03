Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab2CCM45 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 07:56:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49229 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789Ab2CCM44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 07:56:56 -0500
Date: Sat, 3 Mar 2012 12:56:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Estevam Fabio-R49496 <r49496@freescale.com>
Subject: Re: [PATCH 1/4] regulator fixed: Do not report enumaratable voltages
 if there are none
Message-ID: <20120303125652.GA16289@opensource.wolfsonmicro.com>
References: <1330774804-7310-1-git-send-email-s.hauer@pengutronix.de>
 <1330774804-7310-2-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <1330774804-7310-2-git-send-email-s.hauer@pengutronix.de>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 03, 2012 at 12:40:01PM +0100, Sascha Hauer wrote:
> If used as a dummy voltage provider the fixed regulator should
> not set n_voltages to make the core accept the device.

Applied, thanks.

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPUhUNAAoJEBus8iNuMP3d5Q0QAIcI/P8vSz7ERJmDVG+kZjGm
Yn86aYoXSS6uYpeYdZdXoHqw6BdSsBFuvyN5FED+Hg8Jo3fe8c2sPrfsu84ymVTe
X72DIU3BVA6fPIeu7Tc7W5n25T5pKwxy+E5gZ9CzN4w33PRAruDJ/PxYG6ZkKo5O
X+c5iMC+GcF4l6fsTgRoAzXifO6Y1pQQa2fj69hBgXDFXxinPPwPuQHmJimNpxEt
NlFl826qk890NhmGmBJoWrRTc7WLAv3nP3c03NhKKiRWIA+w72bNWlOmKgJjtQat
4pGLGBlEgXpOcqhhcjeETimgimKKv9k5AkZbUyTS+DeOYyXZE7p9GYEazV5bxHoc
5VCnM8dKwtHf2/Nv3TMzmefdHX1hpfrtupaKc20FC7AbZ6sWTeu8ZQ3GwSGEpOCM
ajjF9uvSKP3AWAGfDHPLgCA3Wf/sB+J7cRjrnYvDQhC9+TsrsQeyxAEibR4iCKfU
dQL6Jcy3Q2AOhV5pMahJg47D72sIUwI13zEEFCt9JWH1rmTLIuJn4iciaf4lEgJh
+5jh1gW9tufBGWYC6mkl3ryzh/m9HbjWN1QT1EBSgVpq/7dar9cNZ2zTDVFpvJF0
K2xetxXiJYWNHAHJD6erzRS4HNBMMikwUl6DtuN3+50p2CNz+k5F5aznQhfFfJWg
MX/uZMir4BgT6a3zx4qU
=SQRE
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
