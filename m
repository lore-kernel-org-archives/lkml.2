Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab3ACNDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 08:03:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54853 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752378Ab3ACNDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 08:03:22 -0500
Date: Thu, 3 Jan 2013 13:03:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: core: Fix comment for regulator_register()
Message-ID: <20130103130319.GJ4627@opensource.wolfsonmicro.com>
References: <1357218107.4914.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YQEH9CATo+4lan7A"
Content-Disposition: inline
In-Reply-To: <1357218107.4914.1.camel@phoenix>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YQEH9CATo+4lan7A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 03, 2013 at 09:01:47PM +0800, Axel Lin wrote:
> regulator_register() does not return 0 on success, fix the comment.

Applied, thanks.

--YQEH9CATo+4lan7A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ5YF5AAoJELSic+t+oim9fOMP+wQ7wSsffcN7w5IoLwCa1r+/
uEePnwvNBcbYiWFrLUf309RbICNr+w5viI+DAA2ohTTy1SlFP2jBXKM/MrRZBRAQ
xzXSV0TF3XzGw6y8oqqkBUBiENSeJXDbmrGRZhUq++XQ2zfOtqGg00b/y25MBlUY
FRgzHDOPJUfU1YRpcBohjIpCL34XdSgiMJdNKnM+ORf86DhtanJ+bV1M8eRd5VIC
QRKC2o3QcaQiSEe4i084RoxP6K0jH6QZspc5wbuwuuhEp6ow/k0i8OmQ8qL9OdBU
osjDzyjN8IOQIijMvoarEztsxFTPLMEH14+cMWGOuHgnswfToOWHXP3k1BKX+70J
CKRBN0Xx32qVM/W6y7SC2/7fHUsCkInKrKNEa3Bh/oh1bs0bEj7v/uDj8AIkSU3b
1d820umSaxi8lB+1EuXCZe1lPJCZHzaG6jOT6FXB5dDfqP7xi5nqqTrFtOkGn7Ro
qPXgNW1eQOoYZ0JKsc5hSnmHo7hdSQGOw0WkKGBHxtO7ROZ5NFnJfJeveG9+ajr/
bxebxc9ul1ctxvVI6kGLu0CnT3y1EDA3iBNWdzD3DP5nVVWMoqvuGm82DcPF7Vxb
MXfE/TSAhjkG4AVIip5HfMHdbjjaOkbqsjMcYvA4e19nleIXtrkCZ1AD5P+J92m9
pGkgfrlOcFRn/lKeAmyg
=TChT
-----END PGP SIGNATURE-----

--YQEH9CATo+4lan7A--
