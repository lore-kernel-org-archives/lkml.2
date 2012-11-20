Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230Ab2KTFsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 00:48:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41952 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750823Ab2KTFsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 00:48:35 -0500
Date: Tue, 20 Nov 2012 14:48:27 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 5/5] mfd: arizona: Sync regcache after reset
Message-ID: <20121120054825.GA10560@opensource.wolfsonmicro.com>
References: <20121120044544.GF4483@opensource.wolfsonmicro.com>
 <1353386781-10468-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1353386781-10468-5-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <1353386781-10468-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 20, 2012 at 01:46:21PM +0900, Mark Brown wrote:

> +		ret = regcache_sync(arizona->regmap);
> +		if (ret != 0) {
> +			dev_err(dev, "Failed to sync device: %d\n", ret);
> +			goto err_ldoena;

This should be err_reset - the change appears to have been originally
posted based on older code, not upstream.  I'll post a fixed patch
shortly and have rebuilt the tag so pulling should work.

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQqxijAAoJELSic+t+oim9ez4P/3twoEKeBef02s1MgdA6tPT+
20KWZ4bAnSKRVZ4PwTWY/tHchgJ9/cXw/v1wb8Z3E/mzWSCGBe+kvFpn6cpYhSoe
GxqlBMwBjig1bAiERuMBHSc+G4Gekb11SyR3Ku/NeOopOzq+Ykjp1MIjW9jqnp4m
UY3xXr0Cggh1ix3rLnY1oPHtcGZg0MytAFzJ1gM+fdawfQSRiO0B2T2+4SFDZ0rT
b3CsrhJwjWrFVTlEK9+u8zpX1GMqKmgIN2UlFCPksV5YO7ugvHDnNzFPBIRBGugU
FbmzFvg32eBejo2eiWIF/kNv/iSKDUD5eHpmrlbxNjU6q8pfBJM41dC8dw/4hXsN
n/IIvudnzgIxKdFOKjse3uSAwVM2cT46kp6xPmg5TuZCqFYis+dhwxQj54p3lJZJ
MopQEPlwe4ogdKDOjGfnZLDBJXh4asLIRBOrWTwoRPHBMv5vxfdFZ2tvaNmuhNZj
tij8jqatuEfCSbsBp6pzfOwKZXRKmnD8JzTQgf7DDcdkixLD0Svfe1t2qWMf3Kij
DwvJHOTWKsOokOjhX4fCbKX6MsdvRRscoDrBBQWUNwvZtDeySBiu5c5O9KwSdtLi
lpMPvTZHIad9KVYIDwznkx2ayDKrSP1yEF/rO2fEa6DNFRceWeH+2tu961KNmxLf
P0XzBAA4Cu+u+9UVnixT
=EmAS
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
