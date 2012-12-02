Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab2LBPSO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 10:18:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53697 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484Ab2LBPSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 10:18:13 -0500
Date: Mon, 3 Dec 2012 00:18:08 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, grant.likely@secretlab.ca,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: omap2-mcspi: Fix the redifine warning
Message-ID: <20121202151807.GC17981@opensource.wolfsonmicro.com>
References: <1353307349-4611-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MvEh5MSbieV/1Yst"
Content-Disposition: inline
In-Reply-To: <1353307349-4611-1-git-send-email-shubhrajyoti@ti.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MvEh5MSbieV/1Yst
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 19, 2012 at 12:12:29PM +0530, Shubhrajyoti D wrote:
> Fix the below warning
> drivers/spi/spi-omap2-mcspi.c:336:34: warning: symbol 'tx' shadows an earlier one
> drivers/spi/spi-omap2-mcspi.c:327:12: originally declared here

Applied, thanks.

--MvEh5MSbieV/1Yst
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQu3EpAAoJELSic+t+oim9ZYoP/0s+dbPordwOq92RB2QuDj8S
2EX72Md6vaSG5JPL0pVH8xLdBmX5pTp1qzX+vKGfYjpbQWBkcjGXxmqZm3uHoB/r
lkwJRAaWGyFZg+23xIybgxfwWMWc6ZPP3rCzd87PmVC9qrvcVjHPq59Pdd6mB9Bc
ATw42QkoDN3FhZiFDVpwIL4tZ3SpHtye7GcryM1CeIw0k1OA5oEn7q7FXIiDC2eX
L0d9HXncbBf3/xxcsbVzm9QKB/IL0a7/8BmD8AZVNeg5r8fMx4xS78bMWaT3miwv
yQVdEH5yJqUY2bFvftzI43Tcii9UsPujFnyo9MJgVZhhwl8RUOvMzGWPgXHFzaSL
l7fq4Xt7YYhu4/rK43JnTguUG7MB+aqyuokmmWlAsDpEWyDqkcD6eo7Gu9K/otdI
ldQ2W/A4tgiAmy69BIebIIzTn5N4WqjQJ1Hc0RP9tE2rezivjSmyqrsAtRQu5Vrq
JGCNnbhw1xaCGsPjVx3g3sbKrGU5ucZRzMM0k9cFsE9+jlJdyL/jOQSuI7FnwMTx
tCM4ClTZWHIe+w+m474aMQkxWW5yYDf93TyIc7d63o+CiAZgJ1dNh6inQYLVmJ/T
UsSvFaWolxdZDYBS9X7bi9uT1Z6ZCyurka1B/CPBBxXjHfYmFollCKq9vvCRkFXE
5NNCxMtT+yKz9ZwiluOL
=qBGT
-----END PGP SIGNATURE-----

--MvEh5MSbieV/1Yst--
