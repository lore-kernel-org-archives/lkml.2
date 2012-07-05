Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab2GEMM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:12:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57176 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751400Ab2GEMM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:12:57 -0400
Date: Thu, 5 Jul 2012 13:12:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, rob.herring@calxeda.com, grant.likely@secretlab.ca,
        arnd@arndb.de, linus.walleij@linaro.org, lee.jones@linaro.org,
        swarren@wwwdotorg.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4] regulator: dt: add policy to have property
 "regulator-compatible"
Message-ID: <20120705121255.GW4111@opensource.wolfsonmicro.com>
References: <1341472984-1503-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/eSpIzx5LyAe5lwl"
Content-Disposition: inline
In-Reply-To: <1341472984-1503-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/eSpIzx5LyAe5lwl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 05, 2012 at 12:53:04PM +0530, Laxman Dewangan wrote:
> Add the policy for regulator DT such that if device have multiple
> regulator and its binding contains a child node that describes each
> regulator then each regulator child node must have the property
> "regulator-compatible" which matches with regulator name of their
> hardware counterparts.

Applied, thanks.

--/eSpIzx5LyAe5lwl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9YTAAAoJEBus8iNuMP3dULwP/3DYfhS+PWsR7J6Cvxu9ebz9
ECIb1o0UOO2alrj7MmL2xDD6tjTNGa1pT79KeOgX+D/OY3hLk7/zuRei7/LYDkbM
iRuemgOFXrLxMIyt3GCSPg/Y+6XEuKPSUZGlulIC6NWgtPbcD7ZJOnY0ZcannRfh
u73k+qPGsOqkvsVYPZCw5FP4yfNFfSP92TwY8RqUa/h1vafrA6OQhpGI3yyKYWGo
h9zAuCGcYDhDTThbUosUMKBg7jKKYOTR4wUd0txeJXIgpxNlA5ggjhsIf5+ITGKf
FwV1Jwu3l7/SARlIK+1xQ3LoHwwriU5Kbb+HD67UJ1Qq0Ili3P8IZq3+Me0YebeL
ZAK7MlZO88ySirYa6vugBNqW3vpDtEDa3Y096+XB0RCHdrIxE0FNbp3vi5O/GxZg
P+iIz8jK0fBQ0eP4uoCDHzLMGvDCJHLP/kNrU22BoPBvht4CSgjOO2hi7+kh+nEQ
Z7yGtCXNwxBwHSWmD4Sr9N0JGWfm/PJ0woJ3iFc4on7xQnHTnijPmrjuakvW15Pz
nF7FF0v75ozf6/IE/aLK0pJ68/72lNva4UHacjKixdyYLFprXEhobslt52jOGIP+
9ifD7JYlH7Fmha1AiRp+Qv/Pj0HrtjWgzfHEOZF+xKQhxv+2bz30B2f3Qu196lwa
d3SOOQCgkOzGIYB3mpxL
=guHf
-----END PGP SIGNATURE-----

--/eSpIzx5LyAe5lwl--
