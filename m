Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab2FWKik (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 06:38:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46559 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751680Ab2FWKij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 06:38:39 -0400
Date: Sat, 23 Jun 2012 11:38:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, lrg@ti.com,
        s-guiriec@ti.com
Subject: Re: [PATCH 3/3] REGULATOR: fix regmap offsets for enable/disable
Message-ID: <20120623103836.GQ4037@opensource.wolfsonmicro.com>
References: <1340368581-11882-1-git-send-email-gg@slimlogic.co.uk>
 <1340368581-11882-4-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrxji9MxLi9YGTOD"
Content-Disposition: inline
In-Reply-To: <1340368581-11882-4-git-send-email-gg@slimlogic.co.uk>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrxji9MxLi9YGTOD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 22, 2012 at 01:36:20PM +0100, Graeme Gregory wrote:
> I forgot to apply the offsets for the regmap helper functions for
> enable/disable on SMPS10 and the LDO regulators. This means regulators
> will not enable/disable correctly.

APPLIED, THANKS, after cleaning up the subject line.

--yrxji9MxLi9YGTOD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP5ZyDAAoJEBus8iNuMP3d/VEP/RNvPAhFKm+8atBwFb2qtrTm
NkeWU34Y5gm47qzyqWY/xYjD6JTVXvluJcZJvm64adxd5kbzU4N284YL2StYi/as
5Jb4MKQ+hnx88/HihAgeEucxeJyDp0pcowM7cQqsFciFNu1Rs5BJQylOakKMsDMz
8b19WsVwu53beJwfQBQYoTWKodZCXoCLQ5wNcvFbgYh5jE/AaGr855IcqdRb8fFv
NkEUNc7odkNdSE097bD+OgubjPWo6QXLAS8sexofFySeyqTqStkcPBHpAYqVxbXl
Jf4P+y8UGjFc+4HsUGwlAzl18ynA1/+gxcwdzAzwb2jz4MvsxWVboNFU1YV3kcag
wDSiwipf8xPzWfWcd8GDCUb7Tv8NKbKPz2p/bbJAD0RldD5LHmvePhJ5ZU+l41+b
LxNoSrLIYJ+tN+JFMn/9/oyBtlSWT8OCZT0BnPwnv1Q7JzG3736kLNDKU39kROog
nyJ7Ay6AtRTc2Q9vMDKqDGgK51T1Eeg2Bz14FntAS3oHCOpl1iARkwTUc0s7WEFK
YiyLuIlG7CcwPZNkJs3qULCQXLlbRguCwld23Ydh1xwyJbB1kPquHyL0MG8JdM9Y
cinibmZxe4TMTsSnhjf29g0PBh7nAnslvBEyMpki8rnK4qlftPbyLIWHriVQkThU
ogpubIIR5xmbdhq49+3y
=Ef66
-----END PGP SIGNATURE-----

--yrxji9MxLi9YGTOD--
