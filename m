Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab2EaKDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 06:03:16 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:41093 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750742Ab2EaKDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 06:03:15 -0400
Date: Thu, 31 May 2012 13:01:29 +0300
From: Felipe Balbi <balbi@ti.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Felipe Balbi <balbi@ti.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@ti.com>, Benoit Cousson <b-cousson@ti.com>
Subject: Re: [RFC PATCH] clk: add extension API
Message-ID: <20120531100112.GR5377@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <4FC5DFCF.1020606@codeaurora.org>
 <20120531075125.GL8026@tbergstrom-lnx.Nvidia.com>
 <20120531081841.GG5377@arwen.pp.htv.fi>
 <20120531083131.GQ8026@tbergstrom-lnx.Nvidia.com>
 <20120531085432.GK5377@arwen.pp.htv.fi>
 <20120531090518.GR8026@tbergstrom-lnx.Nvidia.com>
 <20120531092603.GM5377@arwen.pp.htv.fi>
 <20120531094301.GT8026@tbergstrom-lnx.Nvidia.com>
 <20120531094616.GP5377@arwen.pp.htv.fi>
 <20120531095723.GU8026@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GMArzDD+OGn24EFp"
Content-Disposition: inline
In-Reply-To: <20120531095723.GU8026@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GMArzDD+OGn24EFp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 31, 2012 at 12:57:23PM +0300, Peter De Schrijver wrote:
>=20
> >=20
> > Well, that's just because struct device doesn't know about its own clock
> > providers, right ? Should that be patched too ?
> >=20
> > Russell, as the orignal author of the clk API, what do you think ?
>=20
> Even if it would know, how would that solve the problem? only the
> clockframework is supposed to know about struct clk.

you have the device and you have the clock, you need to toggle a bit on
the clock address space. I guess that pretty much says it, no ? Unless
your implementation of struct clk doesn't tell you clk register offset
which is rather unlikely.

--=20
balbi

--GMArzDD+OGn24EFp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPx0FoAAoJEIaOsuA1yqREIbAP/jmyF697rgoiPvmdZnreKs1t
aBD4JALOlwlc0ES/+QH/smyXj3PAs8MdukWWKfKzU5P8NuGYWl2Sc9mbR3kdP51h
I9IplyFVEhFN1f/EFZSy0mOoPUYgCKY2YIcQyjrPIzJQH7mVb2J+CcagFRbHXRf+
SN6nZhBYiG0as7uIEVFBKHQE94L80pH361fvGjATcm9DnPuPH/DcCtcOzemAMPbV
7NNT1it3w9/5gGNfQKvJhKWlTQ+uouSBiHo5bjhalJ0QNyrFSlfb5RcEtuCmlXPF
JYwIJyAh3nGttkEW9C1i7NdJBXNLCvE1MG2nh6Tqh6oLWglCIA8604tpWCylq74J
B3m6pWljTyNlv14TPc9/WnpDOXP35QcGKuWqX/HEHfggNQ+k4R2D2n5n+YylRH7+
3nLlW/rxTyWZMis0AjpFoMUyvKVoinGNuccj8GWW+4yUdhYobQ3t+Icshy+yhv9W
2reS3N4Nvegfhg+nzBF/Da5W+GeLEjBrL4CaM8J3ycN5/t9M363tAUCJNIKr6wgH
P9d2ya0VelRL9PGPhY+6pRTWVrCAntLAcbUNbZ0Iv6Du6LT5DvYmYTF4ZJjfLfur
GgkO9bNoqO4CHDURu95IeOnn8dWiKmg2tgb/Tx4zabnEit0rAnH7aNtaOkqIEEDN
kzpQAUKd4O1H00VXUvsa
=2gAI
-----END PGP SIGNATURE-----

--GMArzDD+OGn24EFp--
