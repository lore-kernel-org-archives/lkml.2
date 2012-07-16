Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab2GPUDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 16:03:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53239 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845Ab2GPUDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 16:03:04 -0400
Date: Mon, 16 Jul 2012 21:03:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        swarren@nvidia.com
Subject: Re: [PATCH V2 3/6] mfd: tps6586x: cache register through regmap
Message-ID: <20120716200302.GF10774@opensource.wolfsonmicro.com>
References: <1342421510-10638-1-git-send-email-ldewangan@nvidia.com>
 <1342421510-10638-4-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X3gaHHMYHkYqP6yf"
Content-Disposition: inline
In-Reply-To: <1342421510-10638-4-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X3gaHHMYHkYqP6yf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 16, 2012 at 12:21:47PM +0530, Laxman Dewangan wrote:
> To cache the interrupt mask register, use the regmap RB_TREE
> cache-ing mechanism in place of implementing it locally.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Can you use regmap-irq?

--X3gaHHMYHkYqP6yf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBHNvAAoJEBus8iNuMP3dfiQP/RrBNdCAoCGFCMKTTE4COTDN
oNHCpXC1WxMznvLwP+FfYtgzZlk/xwS9fD23JnGDd1m4hsNFIHhUdzWHuIJkJm1X
1e41tFzaPuDkOmnbXsuoBFqgNG2OXEplSQ0iuhYLPkNMFkvbbC+RtOvrRvIBFXhO
RkDgSHsyCXwXeeFdiPY/6zggkBy/OAkaxNcE8YoT+gL/q2yPgayfNo02wLuoypRe
icapp/fyMFVikdIt/6/DVlB1yw2tOL1YYp7RuS7bYFdCxKcqrf9/+wZD2Rlw5ag4
StcdalmB/56OJ5uRDEiven1BH37cxGYnkp7AyStmHLy4wY+oNs3iY4pISAMajOIP
l5tcs2sMQ0vM/cF+hTC9ZzEgEK+5kaFLZ3Aw0/dowJtLarKo5hrK5s2gfFbW/9Pl
ywFlu3apD7I2MsRNCiYg/x9yjwTlwdSSoITi1z4yReJ8M+BHdWIz+5Ep9S9zuWLH
MubzVeaLw2jogzbAJc4+1Gqe9bIfbaoYbmogj8UgKgQ3kPytHB4BT+HdmV4bSFlx
pi1mrQIwH9vXDAN58p7jrB1SjESwR0fZ8IlwcET6pCTairLwsxdF2UTQ4Q4VPDda
/AYf3fFkeIlVtThOsVJPAftEtf48BJZ4GrXtpvb78qQ62c/zlGnEMf59MY6gMqKd
fBnY7HBp1sggosN7W0qK
=iw/v
-----END PGP SIGNATURE-----

--X3gaHHMYHkYqP6yf--
