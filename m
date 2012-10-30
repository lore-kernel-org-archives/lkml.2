Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab2J3SjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:39:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33229 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751903Ab2J3SjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:39:02 -0400
Date: Tue, 30 Oct 2012 18:38:54 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V3] spi: tegra: add spi driver for SLINK controller
Message-ID: <20121030183854.GY4511@opensource.wolfsonmicro.com>
References: <1351580645-17260-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eGyD7iWN192kf2IJ"
Content-Disposition: inline
In-Reply-To: <1351580645-17260-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eGyD7iWN192kf2IJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 30, 2012 at 12:34:05PM +0530, Laxman Dewangan wrote:
> Tegra20/Tegra30 supports the spi interface through its SLINK
> controller. Add spi driver for SLINK controller.

Applied, thanks.

--eGyD7iWN192kf2IJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkB61AAoJELSic+t+oim9EooP/0R/oRRf3wGWstupukKFYu3S
vxM4fqK7QRgt+pYjBWjbAxtA+ImaA8BhigHi1r5lWTttme+xk7g4UAOiKMI7BylW
2wmAZvHwNBg5mTts1ZwYWDpMUdtedP+sxQSv73YauDOrzsgibR20lTg+7VN4y3sR
2hD/qYGwsJkFt+yYoZfbS7pYA0eUticOKwt+tOm+XwqdvIvP3Do5Rz/Y37QRAtIr
USVmLpTtNMHMSGJRG0hTBLyEGECluh7GqqaMoIzFzwyGmdBBIpXZ70dhtx0fnde0
SVGlb1MTivIH0qcLG/FP4YHXbf/stHtrPfqjcO9SB2YN+Rwi2bTOGgFcUT4J6/W2
go870ZgXwKsFipF5gAxWTXIdGh6KKMK71xgKOxzPTOQh3qeu+figDw+rwyjH7oz/
aUDi5E5M6hNIUXEo6lUDoshISdaA/pATAKo+ylL/1UQMRqOOwB8gdFX9QR2OSoC/
ZbDvm9zH7y9XXP8zopUanJqioYZFUKERSo3bbwQrGWJZM0WFCnnEcX1nhYvHZJD+
9uvvKHf38l2X54hdHq9h/utpLUDjC/lRhnoK7N8q9NcmNFMuyP8eUqWsdVBsvPLi
By8bq+JzD7OPL3bcDzaisRbxauhw9XRjCTMQYXYnaJKhjYCH0OfjUhbQc2zv+qb+
pIsIHdIn5NweegwrnorI
=bNUq
-----END PGP SIGNATURE-----

--eGyD7iWN192kf2IJ--
