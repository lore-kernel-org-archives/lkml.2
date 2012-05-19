Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab2ESRl5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 13:41:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53914 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755646Ab2ESRl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 13:41:56 -0400
Date: Sat, 19 May 2012 18:41:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] regulator: tps65910: use devm_* for memory allocation
Message-ID: <20120519174153.GY4039@opensource.wolfsonmicro.com>
References: <1337438050-3707-1-git-send-email-ldewangan@nvidia.com>
 <1337438050-3707-5-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dnBRaVjvtun1Q0Od"
Content-Disposition: inline
In-Reply-To: <1337438050-3707-5-git-send-email-ldewangan@nvidia.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dnBRaVjvtun1Q0Od
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 19, 2012 at 08:04:09PM +0530, Laxman Dewangan wrote:
> use the devm_* apis for memory allocation.

Applied, thanks.

--dnBRaVjvtun1Q0Od
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPt9taAAoJEBus8iNuMP3dkYAP/icaBfbr/yLBDH8Tr0XOxTnZ
uogcAgmMrgd9wz7HjRsXBGAAEhNKSgwy/nzOiGCdzFkQtoLz2rQWYdgfj9FWJBkZ
DWpBVrs6B060Qh3q6/ARTaJyIvJyDirQxrLk9nf/vCZmG51rfLkQvW2DULeR33I6
i8sfcSpUu2nB7wGT8t1NhNERF36QCQgO2QKh56WLwqIK0tKP15opTbDImFYAj3fJ
ZrR/o1taGpq2YwDoYwQCGrUY1Vxjj6Y8bPnAMtDt+sBGG0QGkcCjQxGuykPrb7wN
lBrhARDdgfOEhz1YetM2A4LSUef6W71x8gMIj68MSlXGHBQsInDzHozKZ4vSD8Ys
sE6B2Vg4xmfpzdrRwALdAa1yTHSMubtvgUE8jLfvfXe2cILrBwMfhUmQ4gSP8KHC
dfiUVzU0GbOxfZ6j4WGNq8dbY08PEwEFGRF/kKfrBRzSy0E5D8rfZ+mwyEko5xZd
T+3fAZyh36yktQLT5HaOjq9gllX7kd7DIDv1k4U8mjeHxCeSAY1bOIniS0vsh7AB
YAzxnbIYn78OeTDqEkhs6sotMcBIcrB5EkVBoEmPG/cqXkzbM9YpHGVue5ygvQ1W
yWKlexaZUtNQ3+8yX6A+qrsCJ+NFeZZTcuwLQDMtFpy3rOkzH3EY43utc7tuoAMN
ToG224u2GXLwxo/hFZGP
=keTc
-----END PGP SIGNATURE-----

--dnBRaVjvtun1Q0Od--
