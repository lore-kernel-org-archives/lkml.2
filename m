Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166Ab2C2L0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 07:26:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33709 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085Ab2C2LZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 07:25:58 -0400
Date: Thu, 29 Mar 2012 12:25:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@ti.com>, "Jett.Zhou" <jtzhou@marvell.com>
Subject: Re: [PATCH 1/4] regulator: Set list_voltage callback for 88pm8607
Message-ID: <20120329112555.GL3668@opensource.wolfsonmicro.com>
References: <1332917909.19101.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8cpS+6Cx+xtICsjy"
Content-Disposition: inline
In-Reply-To: <1332917909.19101.1.camel@phoenix>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8cpS+6Cx+xtICsjy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 28, 2012 at 02:58:29PM +0800, Axel Lin wrote:
> Current code implements pm8607_list_voltage but does not set the list_voltage
> callback function in pm8607_regulator_ops. Fix it.

Applied all, thanks.

--8cpS+6Cx+xtICsjy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPdEa9AAoJEBus8iNuMP3d9XEP/R//XnGpJ1DSiIrxAZQYm3tI
1WI+3dGTETdpOXXb7QZYlUwQ2qjngxFCNRcgVcICSE8JGlkg0X7erLcAGmCpZ/Ya
ViKn3ksuQbWUfpIKuy0izoiW+5Jkxj5bCQPr0FK57wME1DATQvHXihL516n8qJZT
zCyUrkxa2Na4Gbw78t/Yhnp/JVha0ZQ0b/4Yumj5/o++2JLmwDK+hV6yQIsH0zLR
JUdVqnc+yKoxPbl2QMPGh/FfhmtblTgFnITqbdgC57tGXigHGcXz6ak9xCzcFlqi
xw4H+byQbAGKt0H4PeOI7/mCdGTMCOfqqYMajf3unXSmaZBO6YUJZnf4YjbGwhRE
wwLl+BMzXyECLMPHCtg4gg7psW98rHElpqWhDIR9JbpsR7ZBPeM+htT1eGfXTF2z
DDD6yR6sgKvZ9xObm9QTsPRBk83hty860YKepIv9DWALhQd86ZGX3an2nvpD/YBR
ZXMsy859G96b4iIJTavobvG6v3Xc0iworl3Ym4peo2PEyv333Xsl5J3TMKC+LmIh
fVTYZI6Ae4TkcSfB32j9xthElfZpoVy9v80iZKqB222Z1cWzg4gwsKMcJ+MMaWT9
tzk8a3lkZFoHBqMyUbvqc/bWbmFcYWAtx3w8yzqHMPwXvKi4a6u61Dn/mKbBORXv
l+bIVi5TmxHapqKPF4Md
=MCnH
-----END PGP SIGNATURE-----

--8cpS+6Cx+xtICsjy--
