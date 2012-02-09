Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468Ab2BIXDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 18:03:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49602 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758351Ab2BIXDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 18:03:03 -0500
Date: Thu, 9 Feb 2012 23:03:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Miller <davem@davemloft.net>
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix mc13xxx regulator build on sparc64
Message-ID: <20120209230300.GP3058@opensource.wolfsonmicro.com>
References: <20120209.164301.1049075777681222673.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="51uid+Ur/3ko9cBW"
Content-Disposition: inline
In-Reply-To: <20120209.164301.1049075777681222673.davem@davemloft.net>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--51uid+Ur/3ko9cBW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 09, 2012 at 04:43:01PM -0500, David Miller wrote:

> Since mc13xxx-regulator-core.c and the actual drivers can get built
> into seperate modules, you have to export the DT support symbols
> "mc13xxx_get_num_regulators_dt" and "mc13xxx_parse_regulators_dt"
> otherwise the allmodconfig build fails on sparc64.

Applied with a little changelog fettling, thanks.

--51uid+Ur/3ko9cBW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNFA5AAoJEBus8iNuMP3d3QcQAIomvPfrWArsOCcm11FJuGQp
qTjCboA+a7XrcN1Z1HOcST6yMLWyeFFqtcSyZQK3gZzZCLh6JfosZWwE03UtRabk
8gw1Kupzqzo5gO3usguKo3Gcmo5/bIM8Xk+ElUENL3qJuS6w2T9T//xfiNu3YMvJ
B5tsqRvALo5eCFUnzaaZgO1/QT3i+IxDaoLVRD67ZInXZZzG1D2qLYboOuUjGpNX
4aNCyk/0hi0+L/63b3W25yLxX9dhzB3e/RfRtt5myBPvOdA4aYwNDMj+Qp7W98pi
6JwJawxkU8wH3Y0BbIzMR0giyEBLaXzeURfSqIIBV9aGqW/kZayU/Xp7Ff83CCAo
lHYa4OIMwBnmjeJX1FoDJ/jKosK27/AsVeeLYvEeuvto1RHE2n3EzYbiUb1jJmrA
oRCuPaujtVECrVyyTh+LUvG7ATkqHkLeXNc6P3IcEPY2xJLm0js0CJ1pjbVNXoIm
Xyk1Eu8j6d0g8H+cTcLvi4VtWy/lq4ICIwOXV4S/gpzLUqBp9ryPNvuIHJdSikzI
t+3HIhMkpxSjsMTz8jVVAQ8dPBQh1UabyVT0GqNQ/1Gc1KoP/9QiTFIiQ+V1EiVC
ek7PmOOHc8Y0eQcRVX5eDTeXizl6t0tYAlCQF/7vPwAJTEh5+kAh16Qh+e2h8Q3z
4qvRIC4MFKJyX25YH0WE
=v91B
-----END PGP SIGNATURE-----

--51uid+Ur/3ko9cBW--
