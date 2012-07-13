Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030560Ab2GMQev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 12:34:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48932 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030182Ab2GMQeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 12:34:50 -0400
Date: Fri, 13 Jul 2012 17:34:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Yong Shen <yong.shen@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] regulator: mc13xxx: Populate selector from
 mc13xxx_fixed_regulator_set_voltage
Message-ID: <20120713163448.GQ4215@opensource.wolfsonmicro.com>
References: <1342191674.10881.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4OpS+d6oOtUQaRm1"
Content-Disposition: inline
In-Reply-To: <1342191674.10881.2.camel@phoenix>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4OpS+d6oOtUQaRm1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 13, 2012 at 11:01:14PM +0800, Axel Lin wrote:

> Not very sure if we should implement set_voltage callback for fixed voltage.
> ( Other drivers do not implement set_voltage callback for fixed voltage.
> Since the voltage is fixed, implement set_voltage callback seems does not make sense.)

We shouldn't normally implement it.  The fixed voltage driver does so
because it reuses the existing set voltage device tree binding to
specify the voltage it provides but I'd not expect other drivers to need
to do this.

--4OpS+d6oOtUQaRm1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQAE1MAAoJEBus8iNuMP3dIdIP/AvSUf30pHbj/vLER1ixn8tw
fN26qzzkh6gTw3wh7WZ2xGw7nzob63fY29HJXSDCOdAaTNkLRCXP8jta17NZCSUz
6dCZTLhYtQbdLew0nvum7k36bweY7iI9gesQvyll8ANrAk4L43J3DYcYwjZjHQl2
9kHdoHEtBPAbdA/En7H/hKZA1g5sLLM8wAoRCXTt8QBIr9gBcRG2l0g7SQjC/J9N
M1dtyjxpPysQVDzdi/BC8hK7yEmCcqhCZPXwQ9jQtbfvPWEtVn8vJNWMWGIMGU4l
KzhwfZWQSsO/iiB1dwgMHsAMZAP/x/C+l0isizjxIixZl4iDu65RRc5yds3bmDw9
ifQZBnbDkAt/tfqrPbULCz64jjU94E7Q9duntaut/g3zBAyK0U+JexVtRaaEisjF
NL/ZlIXjiWfykA8VSNP1sl+lKzXxxan6N4R7+LbPkMZzNa6oXFXBrbXj5BN3YGZe
PhcllYeBXX9ZSUxACCXlw13gRJddmCHiFmnOpFnKbr1fKV4U2DNKz0E+FallqCWm
Q+ZttbpE9X61ANCfzZRGnesoDnWMfdo5rqsi9jJPWg1Sdb3+KoM74OfZAoYxp1It
GRgrqxIn+kL7fxqA/iMlCpEFty7lRYyZ3XkQF68AHhF/iQoNLBBb8nZvXoK9Pkx2
lZsDRrxWjRClVv1QMR6z
=J129
-----END PGP SIGNATURE-----

--4OpS+d6oOtUQaRm1--
