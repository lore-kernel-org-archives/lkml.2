Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab2A2Vn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 16:43:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57235 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753346Ab2A2Vn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 16:43:27 -0500
Date: Sun, 29 Jan 2012 21:43:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Properly round reg_bytes and val_bytes
Message-ID: <20120129214323.GE2994@opensource.wolfsonmicro.com>
References: <1327713401-16236-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MnLPg7ZWsaic7Fhd"
Content-Disposition: inline
In-Reply-To: <1327713401-16236-1-git-send-email-w.sang@pengutronix.de>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MnLPg7ZWsaic7Fhd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 28, 2012 at 02:16:41AM +0100, Wolfram Sang wrote:
> For the upcoming 2/6-format, we don't see debugfs output otherwise,
> since the current division results in 0. I'd think 10/14 is broken
> currently, too.

Applied, thanks.

--MnLPg7ZWsaic7Fhd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJb11AAoJEBus8iNuMP3dNlkP/1sqbB2rhvnikcFqyWip4o1m
HbrtzCEX3ZNFkmDQPkDf5TgfrrbxL8Wef1s7g44E0Ye26l+DfXjM3sueRa7BVCDV
UDHPxg0N2UFjM7QM2fcD0MxXUGHij3v5/HrnbViGjuVSwWMVDPqZ+XT0Mavib1BO
14AftWSwP3K2mIEI+b2WV3wY0cL92yNG2qPp+bCbuXtE5qdULE7XihV8Xfr+JN04
RMoUhu0E86gAR4IsN4SrIkq6cnx/KEAih0sLiqsx5XgTsSQz/YxNL7fGRmAoFOBl
Y8bSi4rln4Q+lsIm/le4XvQMoK3H0AHoR2Pbw49QbALYil6UC/LUghDe4rWZ/TNV
yRNSWqq1YK6+vVYTljjxBmYwGRJoTfPu0bYH47QQjpLYtHqATwFvkKmdE+rLWe9Q
mTFvtJKCp/QRx5Wa1uzlRsELbhcZ+CiBBwKB0V6Zlp+IJMlk7c3rVPmPxy01W95i
J/9w8MBfLTbIk3rtjNPBhc7CJ4wwprs+sHrGRUB/4G622m285RI2BDNsrnnCtr/O
N7jD29rBINEtangcYX4rsHsAARAVhvaM4gJ4ltaD9sA2K6FuTt+YLCAAbNPRbbwV
h1w8gWD0kHyZbI+97WidjsFe8qa8sQO+wyAi8YwKbPF7IrOMTnjyRfD38ofxAJp8
HtNiLLdiBgdTOmFHzf5i
=r6dE
-----END PGP SIGNATURE-----

--MnLPg7ZWsaic7Fhd--
