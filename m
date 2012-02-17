Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab2BQVjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:39:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60210 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752101Ab2BQVjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:39:02 -0500
Date: Fri, 17 Feb 2012 13:38:57 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@ti.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: U300: Don't specify regulator consumers by
 struct device
Message-ID: <20120217213856.GA21717@opensource.wolfsonmicro.com>
References: <1329449029.17110.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <1329449029.17110.1.camel@phoenix>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 17, 2012 at 11:23:49AM +0800, Axel Lin wrote:
> The dev field is remove from struct regulator_consumer_supply since commit
> 737f36 "regulator: Remove support for supplies specified by struct device".

Applied, thanks.

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPPsjUAAoJEBus8iNuMP3d3FEP/Rip0dN4ryOFL42HSMDWBRhR
cYkRvF2jn+H97PUCB/FK4S+VkwTavd5iiOkK3CT6lJhLmuxALdxY/THvrDPnx6u/
EKcyyROQDUpkHJrMMv3qiDd4afJ2qoiK1lvYCMOmkAJNdoN+yxR1yUzVUC8SP7Cb
nDUKJrM6G+Osf6bGi97qUU4UqoF7Svw4mHu0SSjqoB5fEB8UeIrywL6ehz37FmJ1
79xvgSHSfGMq+kRHx/yfQ22PnO/njfSViHM3ropHM4jKnh6kD/m/lYs8hfLh0Yb3
N6Db1RWE5ueCbeI6YsMr92a+Hb1OasTraUdKIwiYKfnkiElBeTj144x1tL24UJxm
bxjsBuNdiHA11BkJ1069aKgppy0Ll8oY6XPKsZIr85drwmYck3drZDIpCyxNx2Ur
JJ3DInBg7cQlW2QEzqMEY9vyaNPy3meTr1SgbDt4BzvHJqqpDTOdXXUPEM4MsM7V
TmQgLATHjoU/1x9r3vrmPnCx/Q9heGvOX9e/JUDwH32dumJfxpo4sOgpX5EbTISU
1tHLBL6upkaZ4u6AjTiZjOwA3rtL5EB0RoUaYmfOGTrbQA1WBNOalVrPLPjRKnhz
8v294nAk3EoAAGAu61x1HstdszXfRms6UER5+mHo8iSTK1ZD+j+YwU5ATZoPWOvW
uJtwsOgs7/itF+JTLvE3
=N+Bv
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
