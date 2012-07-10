Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab2GJJD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 05:03:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55414 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752398Ab2GJJD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 05:03:27 -0400
Date: Tue, 10 Jul 2012 10:03:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Axel Lin <axel.lin@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20120710090324.GC3918@opensource.wolfsonmicro.com>
References: <20120710153210.45caf9cf0644898ab3d1c70b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B4IIlcmfBL/1gGOG"
Content-Disposition: inline
In-Reply-To: <20120710153210.45caf9cf0644898ab3d1c70b@canb.auug.org.au>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B4IIlcmfBL/1gGOG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 10, 2012 at 03:32:10PM +1000, Stephen Rothwell wrote:

> Caused by commit 01eaf2458773 ("extcon: Convert extcon_gpio to
> devm_gpio_request_one").  devm_gpio_request_one is not currently exported
> to modules.

A patch for this has been in -next for most of this release cycle and
really should've been sent to Linus by now - this issue is cropping up
an awful lot and there's further patches not getting applied due to the
dependency on this.

I *think* the patch is sitting in Andrew's tree at the minute.

--B4IIlcmfBL/1gGOG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP+++cAAoJEBus8iNuMP3dvo0P/3IkDRd/5SGQvuiGWyBVVwqx
hbPueTZT1S2Pk9cAhC6kANxZkWOC6VNw7hGNjSBNUNPFtUrSxu/SoyrcW/r0oT8B
LwJRuqr1goJyKgnU/Q6PPYdVG2Uumtk4AvCFuYNIwX1SOH5+DNvdmxiI+37RETSs
oI5NXtV8UDgsV9be6bNlY/5ffBwnNmE+PkvG6pFijLeqgfmn+WzAlIuKqSKJcVZ7
c3busdii76R13/Cu0tfujVVm0HT7XsSbfGuZqGrPKo/k3d0FZC8GqKjIeZw9dDz6
w+Z6qQS/DOHjOCHwihnNs18Lkbpd/M3aqXuULoSqNbkYMRVz1VWqCKx9got8yTQb
Nz87GciCHcSfJgznOs10IHHv/S4MazFYiBtGknbqmFEMyIBe+GSV5sqVJSJmhS+a
IR4Baa9GLGGnBbbEB9nPQZLSas2LpJ1ljRrrhjpYa7EkVLMR7NrR+0a++18yhtcT
2jgEiOZOg7jukvzHqX4cX4Zl8SXouRy366IZXSvIP0EaXbqYfEnN/q75Dph2icFO
p+WMxAwgPu8Xx2oMkeUI5sZVfqj9HrlcYID7GVskY5k8r1K+5/LF7iJ72IzmYr7v
WkTqWLmtn/dgrpJw1D4j/+asi0mbAXFXK8DnDJKtAM7P9NvdZmhnhjn7qmTqDijI
M6HqXwxNp2at6NusPRGz
=ul2m
-----END PGP SIGNATURE-----

--B4IIlcmfBL/1gGOG--
