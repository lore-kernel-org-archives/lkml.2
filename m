Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab2EDKeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 06:34:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43334 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754698Ab2EDKeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 06:34:01 -0400
Date: Fri, 4 May 2012 11:33:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: dd diasemi <dd.diasemi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anthony Olech <Anthony.Olech@diasemi.com>
Subject: Re: Linux 3.4-rc2 register mapping and paging on I2C device.
Message-ID: <20120504103358.GD14230@opensource.wolfsonmicro.com>
References: <CAEqHmAstczdi2seTHFE0-jLK9fJaKosHjJyo4AJ7E9UKYBrVsg@mail.gmail.com>
 <20120430214718.GB4414@opensource.wolfsonmicro.com>
 <CAEqHmAsyJntRMqX+7NbQN0OmDXz6ZGh0LzAMp5KB=-cAMgpsJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OROCMA9jn6tkzFBc"
Content-Disposition: inline
In-Reply-To: <CAEqHmAsyJntRMqX+7NbQN0OmDXz6ZGh0LzAMp5KB=-cAMgpsJA@mail.gmail.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OROCMA9jn6tkzFBc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 04, 2012 at 11:35:58AM +0200, dd diasemi wrote:

> Below you can find my proposition of API for regmap paging support. It
> is sufficient for my driver needs.
> If you are OK with this proposition or you find any issues with it, let me know.

Please submit an actual patch, this needs to be supported by things like
the cache infrastructure as well.  One thing that's not obvious with
just this is how things like register defaults and iterating all the
known registers will work.

> +config REGMAP_PAGING
> +       bool

No, this needs to work with both paged and non-paged devices.

--OROCMA9jn6tkzFBc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPo7CNAAoJEBus8iNuMP3ddQcP/iInY+NvOySlOpTJyTClVtJp
4BcNjt5UotGyvfMuFN7RhZCQVH4l674S3zyv48x3iFumj5c9BQdsf4BxW1a5cswf
ACSWjymqWxNKNTrdXFGoM+ko49AzWq/gutCobL3Z3ITM8Ax6kEr28Edb6aaamQzk
Acu+TCDd1kVAYL/aJSQWb/Z9eHeti4YxrSAiHgACskrkSOaYktvURjlc+A2w/Fit
P4jaqKvYaToCNsGRV4DSS3qqMykwrmZ+4etQyqIS5bbVWxZpk8JOhwLqItiWGVl5
Y5YKWG9SWRWAQvEyJ+9R2UtXvOBZqyGCrOOEKJRmp21AW+jRLKyS01BYB8H+PRFa
DqzzcCiPxZjJRLv3jMSMGQzMlAJG+6Tex5hwSgT+CBs+asq22IJEfYRsBswrL9Zu
/vags3fgWMiLf9q0kBrQOqCwZlR+WvDynHe4NbZVfg0dJ2aVPxWSFXfdBPDxFumT
FRIzC7xNIY137DnV9QPv5Wb7f+lCerD8fWtkTRqwR3wswCI+fu/dM1B22QPkpjbn
MSME0flhUdCN1uA7abiztRy6/h7e19RTzSPex6/FB8ExLjBHvwzJWUCTuc5HF1Rd
ARkzVSaIxVm3Lcuy0NNFWreBo2sW8XkqZAnOHL6IoTOb+sLxOQX+mQ4XkDlSBJ5f
TtEdiffxiQFknh7kRlbG
=SNoi
-----END PGP SIGNATURE-----

--OROCMA9jn6tkzFBc--
