Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050Ab2EPSDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:03:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43380 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757840Ab2EPSDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:03:31 -0400
Date: Wed, 16 May 2012 19:03:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: mc13xxx: Core should not be user visible
Message-ID: <20120516180327.GF26337@opensource.wolfsonmicro.com>
References: <1337190669-29328-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120516180154.GL22395@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IDYEmSnFhs3mNXr+"
Content-Disposition: inline
In-Reply-To: <20120516180154.GL22395@pengutronix.de>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IDYEmSnFhs3mNXr+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 16, 2012 at 08:01:54PM +0200, Uwe Kleine-K=F6nig wrote:

> If you change the logic in this way please change

> 	tristate "MC13xxx SPI interface" if SPI_MASTER
> 	default SPI_MASTER

> to

> 	tristate "Freescale MC13783 and MC13892 SPI interface"
> 	depends on SPI_MASTER

> and similar to the i2c part. IIRC only MC13892 supports i2c.

I don't care that much about randconfigs; I just thought it was quicker
to post a patch than describe the fix.

--IDYEmSnFhs3mNXr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPs+vlAAoJEBus8iNuMP3dYj0QAINTEITZkwaFq1tRgniTQ/yK
DEPVkIu4h5e5EAoPUXI6tA5eDNXPkSzHWhlP9j/EeZsLldJDyEiUvjVAiSQfuqnj
HOjQWxWNhh5aVKsrPvi/DGmLiDntgDfDTbJNzFy/Dn40qwdA/kWt6tSzE/u4pODy
reU8TgsIPUuB2Pl/nC0GoXJi9u0GRBHmM1bQ9fgmjEliaS2swwS7wR/Oj4vjHikD
ucrotL02Xp70kW8wddzSpLAqFCBVoT1Mk49+uhkF8jNicGB8vfVcJ4vICQf2Jglf
yWFq5VrJWpKFFhs+//HtDZyowbMmCadQJJRnWMEuhjrkBRgN9iQ+kI7ysgYLllxW
TkWByw96Kdn/OGb7aQpkTTstTnb+VbUBKIr7NeIjNvggbK23qFqPRAx0Gf9vCqSG
jnzu1X1SPe+NNhmwLg5TtSzTtDdyeyaC7dbQBcrqKGi/0tx1sx+MBEfg4FaVv/qq
j9uu6QMeMACQzEq2osyAHcLVY6O1LJWD86zl3qQcgTHp7FfAsn3BYy4cLC/FPMGk
kWQ47nWSqyIYkEy1LbAiFT3Hf8AzxA95bwOJFwWKm+hSLjR+mEToSJhOAVVBGl9r
/XIjxEX9a/xR/11NTLIX8lv7QJESeIikNit4Cmoi+WCxNvI5uZMGLBih23bZTIX4
lWCA6RBkWpAK5V5Iiggm
=3RMB
-----END PGP SIGNATURE-----

--IDYEmSnFhs3mNXr+--
