Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab2BBNkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 08:40:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37880 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756077Ab2BBNkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 08:40:06 -0500
Date: Thu, 2 Feb 2012 13:40:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Maxime Coquelin <maxime.coquelin@stericsson.com>,
        Alex Macro <alex.macro@stericsson.com>,
        Michel Jaouen <michel.jaouen@stericsson.com>
Subject: Re: [PATCH 3/4] mfd/ab8500: parametrize IRQ masks and registers
Message-ID: <20120202134002.GP7428@opensource.wolfsonmicro.com>
References: <1328112568-32529-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rZHzn+A9B7nBTGyj"
Content-Disposition: inline
In-Reply-To: <1328112568-32529-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rZHzn+A9B7nBTGyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 01, 2012 at 05:09:28PM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>=20
> This makes the AB8500 state struct contain the IRQ mask and
> register offsets previously hard-coded so as to make room for
> more AB8500 variants.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

though devm_kzalloc() might be nice if you're respinning...

--rZHzn+A9B7nBTGyj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKpIsAAoJEBus8iNuMP3dQnIP/R53bGQJv4Ip4OPxiCst+dmo
o5BvROXo1Rnu+POaZvJs/BE5VNXdW9FQLaE4viIbYSH5jgFSAcn9WK81MUTKwqDh
x0b7QdxxjMNRMnAZhpnoSx11CMhWKPZNmUs9Sarnr98LA2jotoqgxKDsWr2ECuB/
+yep5v7Q9rOHBhwl0SGY5iA66QLyszxzobuxgI82yb2BgTepDu0IOTfDwbtTtxdc
v1Vt8tt48TwADoi+GE9YhDd5ufwhDMh8u+9+xFAzktkzBrPcHChdm6BADu4C6FQ7
uc0P4gGO3zUUuWzBFTY0zFM+h1P0NPaoW2b6svEkY6cl5mjWYbLgtColZ06rANfF
fIYHGDrgZfs/p5oV8UevwkLyGrKOBJKCqTapdT7E0PIzsHPdtGktPrveBzRFDAwR
NKsJACGLQqg3zFGHMiFHih7rj3mpHQnVA39bqs0SyWjagPryum7qOYA77GvO1w2h
bWum/ZIDhDffvkuGAOInAuB7H6nH0wLiq8X9qa0NVCcaGj0MyB+fjdsk48nZB63N
1BjF4hq29XnuBomBEWM0BB3ZS66y3cbyc2XBwos37yEnROrnre5AwBgKUKS64mZF
pvUlvNTUP1ZwoMOPq8ln7cb2CvAEgz+pn3Gg73xugANoJ6nhjrB45HplDLKYUGkO
4jzXNQbCOesT/zi/UFIc
=fYQ2
-----END PGP SIGNATURE-----

--rZHzn+A9B7nBTGyj--
