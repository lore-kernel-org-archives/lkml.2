Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901Ab2JWJrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:47:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33178 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932811Ab2JWJr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:47:28 -0400
Date: Tue, 23 Oct 2012 10:47:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Ralf Baechle <ralf@linux-mips.org>,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: Make the generic clock API available by default
Message-ID: <20121023094726.GT4477@opensource.wolfsonmicro.com>
References: <1350910970-9095-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <50856CC6.7010403@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BfbbJsf3thGkpLcA"
Content-Disposition: inline
In-Reply-To: <50856CC6.7010403@wwwdotorg.org>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BfbbJsf3thGkpLcA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 22, 2012 at 09:56:54AM -0600, Stephen Warren wrote:

> Since v3.7-rc1, Tegra uses common clock, so I don't think the change
> above is right is it?

No, updated.  It really shouldn't take multiple kernel releases to get
something like this done...

--BfbbJsf3thGkpLcA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhmd7AAoJELSic+t+oim9NygP/3BZNo0hOvHe/erUrjFum8wo
xd0mchVp1nUxdz7p6bVY80ab7EBYTxW/6UjB6N3RIDECmHTrj85wziVo+LdTYJCw
FjO+AGlZY725ETE9s9ua4jw/2dSrzaQmeXw5SHGsE/wGDBCckM9doIa8AT9gJjyn
MciV6sxak/7hSCxYRpFlCZHwUaoSTiBNkZ/xztHNLnsU+jFrneeB0uNYrzk26S65
ndfGe/xKjIx74/4xk1LuR0+vttsg7tPzL2Jq9VEThb+445I3XfnaazLPgMIYAfaE
OPZuatK1ZfrQ4xrfxBmGLt4Ogmilb4u8QGMm3m1GFKIuCAWxJ1V0qDyREMTlkD7j
G5h77woM4FdpB+LFbhPXmQghU7X90p4J8BTyGyPieuyDd/HUI7BFFImMoqxeSHOE
9tjYyeOwka5YPyXFJ6m4hoSNHSaRqKJ37tGKMz3S+UssYmuJvNxIktA0mHR+TipC
1+k4el6jbuwI1gxOomSChg2uyz667DFFw2vwZEVT8unNzt2KXazuCip8rQixFw9m
lJieUC2AV4jpwY/TGpeLcZLE81IucW/YhU9LQqG+/jCLk1i67dDtdjBuI6c7o/fG
j+xwIfx+Xo37yFaYA1jjcivilC/9f4y/kYIie6bKUfv5t6bC8lFWDQ9BCe3SVa8s
mPaJ9q0Ol1rCTR79Q2uM
=u/M+
-----END PGP SIGNATURE-----

--BfbbJsf3thGkpLcA--
