Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab2DDTVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 15:21:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34914 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932292Ab2DDTVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 15:21:06 -0400
Date: Wed, 4 Apr 2012 20:21:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clkdev: Implement managed clk_get()
Message-ID: <20120404192102.GA10787@opensource.wolfsonmicro.com>
References: <1333403385-24133-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120402215341.GL24211@n2100.arm.linux.org.uk>
 <20120402215927.GG3160@opensource.wolfsonmicro.com>
 <20120404174828.GA27171@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <20120404174828.GA27171@avionic-0098.adnet.avionic-design.de>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 04, 2012 at 07:48:28PM +0200, Thierry Reding wrote:

> The kerneldoc comment for devm_clk_put() also needs updating in case you
> haven't fixed it already.

Got that, thanks.

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfJ8WAAoJEBus8iNuMP3dJwYP/R5yzU1f1jUxOu2aok5mvHUz
9Hl0Wr6PhSggsDeFelEThR+s1d1UI06iOuJgdG3UnVdB1ltpCqodAXJsW56AyObX
iJddh60t0r1VuR5+K1VVqYV6zIBtHP7x0t31mPqTyucMysmRnlUgFGh3Bz6rYfLZ
F/hYn2UHHAdg3rYq/sY76Ju1atYxs+vtidJacukCqRYyomzZ53bKO34MOGSWOvap
K/MLOimd2Pz75JvARi07xnkN7elldYl2SHCu0NgJc6AmP6G3FzVH8D9glfeBBLv2
+fOK42nW04tw75buJroEMPZ6nrREcSJ4bAI3b/bE2eEt6Jh/c18EeELOD/u0egP9
7vIE7lGHzpk5dDqwfzkJ+lIb/Eg8ufdo81gtoclZ9KPTPty7/yM0wfSOf5pgyIqY
kTroz9f0UVma0NF1Nqe44lAQ0F4wXTcJzfC9uPITencxkeTod90TLP57xdsYcei1
JsEy+VRluH+CS9cTGahWHmKAlFmQ6bbs4U7/7AzsjpIFOnqZX6vJeQ6WX9MrPkES
puScypdYmeVJom1nbfP+mQhLBSzOtC+JeikrxTG9JPVgQTYy7+1G3nJNGcQmQPAS
r+eT1KJ+p6H6WJq2pHXOBeNVQaEzLgVZfWjHp/qvZPqTyGFkIHf5TeTILyHorR+Z
vD9k49Wa3ff4l62maFxX
=ZKb9
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
