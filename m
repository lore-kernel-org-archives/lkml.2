Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab2GQOW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 10:22:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39133 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753956Ab2GQOWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 10:22:25 -0400
Date: Tue, 17 Jul 2012 15:22:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@gnudd.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 i2c-embedded tree
Message-ID: <20120717142222.GE4477@opensource.wolfsonmicro.com>
References: <5003FB7C.4030509@linaro.org>
 <20120717130650.GB27595@sirena.org.uk>
 <500568D9.10805@linaro.org>
 <20120717133550.GC4477@opensource.wolfsonmicro.com>
 <50057058.2060002@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9crTWz/Z+Zyzu20v"
Content-Disposition: inline
In-Reply-To: <50057058.2060002@linaro.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9crTWz/Z+Zyzu20v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 17, 2012 at 03:02:00PM +0100, Lee Jones wrote:

> I'm sure sure this is relevant in the current case though, as the
> i2c properties proposed here are platform specific. What we're

I've not seen the specific example (though fankly it seems quite
surprising that there's anything other than bus speed that the platform
might want to configure for I2C...).

> discussing is some consolidation of property names, which I do
> support in theory. What I fear is that this driver will lack Device
> Tree functionality for yet another kernel version if it isn't
> resolved quickly.

Well, if checking the DT checky box is the important thing then just
adding an of_match_table ought to be enough?  It's fairly common for
platform data to have lots of stuff that's not used by most systems
so you can often cover 90% of systems with a very small subset of the=20
configurability.

--9crTWz/Z+Zyzu20v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBXTzAAoJEBus8iNuMP3dOPMP/3dtJMGzoYRNI0VqlMABFMS7
JND0hUCj2zwsBZyPVmMfU1vrmG9QTV1aQT52VlXAMcpdod6oP8go4wEaQXhX28ej
TR4T7XsilGCa7zvj2IzCQBpDZJXTVi58DzwDGGcVjyShnf4HL2YP+WvVSij7mCuN
btWiNhhHT6zi/Hj0EGA0GPUu8G8jZ7L/r4HzdTA3opLpCfVeWx+h6z/40xqTjEjN
Ye/f98XmVPbLU60u5HOrS//7VbREPb77LITNB59NzkjUo5TbC2WCZaMeIjDahRnC
IVxQMWzg+8BB5dtfNNNLohOfXo8y9bis9ly4IccRM4ml/sSMMnQQNnzj6NMzZC8/
PkbL65/h3IegdkMtZ/eug+x6jyW0ULMUxLXxcrllCQSCVSF/Hdjj5zI7soFooJNU
xtwe2sPtH8QvBbOcwMVHXp4WPPueKkYl1zueS6YTxkdQf66tzNnkaX+ZIK8RdQ5p
Bm4EeuMZ1Cyn3Uzh9ODNvyU8u2vlzRBXzKzfhMwl2E3VkAzQnMl/2kC5dhwk6J4K
cKXYJsP+Nr31gwMh3MuhPdlBE6k0MPYkvU5fF6D1t3ZAhgESS8znAjhEAN6+qCHG
rqUGgd1tT683BmF8aJuKqHycKdFrPCZgAivKLsLQEyR9kcLfxHADIKLaIOAv6xAI
ZPDM4sp5zeGmit4hP3lz
=aYF8
-----END PGP SIGNATURE-----

--9crTWz/Z+Zyzu20v--
