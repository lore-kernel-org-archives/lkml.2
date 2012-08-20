Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab2HTT7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:59:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53703 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754292Ab2HTT65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:58:57 -0400
Date: Mon, 20 Aug 2012 20:58:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH] regulator: max8907: Properly set pmic pointer in
 max8907_regulator_remove()
Message-ID: <20120820195855.GR26991@opensource.wolfsonmicro.com>
References: <1345271585.7986.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZaW/dtY/7oMe/vLp"
Content-Disposition: inline
In-Reply-To: <1345271585.7986.0.camel@phoenix>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZaW/dtY/7oMe/vLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 18, 2012 at 02:33:05PM +0800, Axel Lin wrote:
> Add missing platform_get_drvdata() call in max8907_regulator_remove(), this
> fixes below build warning:

Applied, thanks.

--ZaW/dtY/7oMe/vLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQMpb2AAoJEFJkBDiqVpZ4A9sP/3sOo0PIkifHBvQhPziWSUNf
7sSNA6n0yx3EzX4IPyTPzOGXMRQeSo21IooeM5XcOUbjhsVAa+Dud0hOtmPPcjR4
gIUrepmuP9VfPzCbfD0S/hVAk2cQeFs6Szb77pv/qJAX57JF+nd+hyf7FximnvYH
2l4v/dXYhqtlLN45SVxWCc+rm6g0M/4BadWPCtC975e5ym4e5eLZ87cR2kcvLNYU
GREKRMHaHVasNWaIA4EHRqPOfXuG8jQqRRewps2i+/D42cqGLUEDMVL5041YBHxH
WqSEGJA84B9ZzTtQLJAWgj0ZSC0L9qJEDP0FfwIzWk/RNcd6D2y3cVkE/jcuMrWl
SNSt3tDy4QHsxhuqEelkx9qKLJZ0scnxkDtd33/Cc/utAFzbDBDsRS/uJcyqbxoG
4isNyBgTDTkvwC2RLksw+YFesgwfm12qC8mdyoMHIUKOU98uGHJpeuXkHCxqR8jN
/uHvhQwNkJOYVjyktDbZa2j01utkVcrp/S1+hrUOw8yxBvo0R6AS8vJxYZPPK1oT
SexadgCuL4v/2x7yBH7NlRFYYnDHi73f6g25BvzHLQRqg0NiG2pJBVVJF4kitDYz
uSuphPm+/LM0eP50m8QZx60cniLnqk/KK4GBxKB8TGHDaWE9wFoYP5SA4AKfTxPq
rCNwm9VqjUa9VQWXECOZ
=bLRL
-----END PGP SIGNATURE-----

--ZaW/dtY/7oMe/vLp--
