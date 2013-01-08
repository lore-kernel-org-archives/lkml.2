Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab3AHLCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:02:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35871 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755776Ab3AHLCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:02:31 -0500
Date: Tue, 8 Jan 2013 11:02:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com, chao.bi@intel.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 05/11] spi/pxa2xx: make clock rate configurable from
 platform data
Message-ID: <20130108110228.GM4544@opensource.wolfsonmicro.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
 <1357555480-24022-6-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FxlYARId5dseejUu"
Content-Disposition: inline
In-Reply-To: <1357555480-24022-6-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FxlYARId5dseejUu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 07, 2013 at 12:44:34PM +0200, Mika Westerberg wrote:
> If the architecture doesn't support clk framework (like x86) we need a way to
> pass the SSP clock rate to the driver. This patch adds a field in the platform
> data 'fixed_clk_rate' that allows passing the rate.

No, the way to do this is to fix x86 to enable the clock API there.  The
x86 maintainers couldn't be bothered when I submitted a patch and
getting anyone to take a patch to make it available by default appears
to be unreasonably hard but perhaps if someone from Intel tries the x86
maintainers might take a patch...

We shouldn't be adding special case code to every driver that might need
a clock that gets used on an Intel system.

--FxlYARId5dseejUu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ6/y9AAoJELSic+t+oim9JDAP/3ALQoN2ACL97j9fWDk4EPph
11/zlNAMJfeltgqj9VqvsEClZRZLwI07mq/ULDk2PVtE32hhFaZhtl4fxasbTq+v
0VNF5V+sBzcIDOYiJat1qO5jDDVpzhWrmNzA/wYJJpJ1npux+7dSUuNSuRo2JzxC
jO9FScRFk5By/Z/M0n0VKOHKboQcDIsBtpDWA72hbqMVxitIUwyWukJpH4e+epn8
3EM13VXSP9Kiomyv7F0PMj72n+YLL+Q5TSlpuCdkwzMN9qX8iAJKKRjA5L3Lw9Uk
Dk3+1E984sB70Ouu4zMcd5a37cOiQQdWW5bUyTonVZ9YFRfQxqhzrfJzkgkMQlMu
T9yPx4zq3X1WWoBAMfFIRn8rHMn6OUMzq/58Uvc8ToxwJJAN/dJ72fgMU7a9ky+s
ehbgCF1j/CIMZ6UnDcX6G1l2kN3kLUMJli/KKTkKBkPvdzPDJlJ1qBhqyGNxSHvr
r9XGDCn96zEVo7PDUE7J2y4fXwkWj6c8OfzZcJKcUXLwlWKHIjWmhtKyLS0a2O4A
RXqWBFxlp3KzhsBbuN4oCUt5jqzHkQalkXEvd5yNTTc0Jle5abpUk/iLcfPDnRvn
pa5cbx8eIHe/prVyM8R02TZmRc/glm7nKHly8Mhg7zs2Tg4y5Fy7H+UobfsQclNE
JE/KajaF2mK9Vo8ZGlIW
=rgzU
-----END PGP SIGNATURE-----

--FxlYARId5dseejUu--
