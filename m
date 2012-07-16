Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab2GPT7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 15:59:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47397 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752199Ab2GPT7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 15:59:32 -0400
Date: Mon, 16 Jul 2012 20:59:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: lp872x: Simplify implementation of
 lp872x_find_regulator_init_data()
Message-ID: <20120716195930.GC10774@opensource.wolfsonmicro.com>
References: <1342342632.2939.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IpbVkmxF4tDyP/Kb"
Content-Disposition: inline
In-Reply-To: <1342342632.2939.2.camel@phoenix>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IpbVkmxF4tDyP/Kb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 15, 2012 at 04:57:12PM +0800, Axel Lin wrote:
> Pass regulator id rahter than the index to lp872x_find_regulator_init_data(),
> then the code can be simpler.
> We can also get max_regulators by lp->num_regulators.

Applied, thanks.

--IpbVkmxF4tDyP/Kb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBHKcAAoJEBus8iNuMP3dO18P/2L1tkwVmspBvIbmOmFB+mNe
hzBLMb10GN9lbHc6LRbSeU356iL9mJXU0RAWF5O4M+akfIFokM6F6FODAEZlw4e9
en6bPEgq0oQ8QdBSdh63Hf5L++dOcPvFTotyeifPgE9qIb9wtXow1480/Q5bHFB/
GxYEG0WLymMkaI0aK0QiLB2P9Xuebq5AsSZEklfJ8UBZG7CRK5wYV40q+eeFNM83
1p7l2AKm9BSrFS0ogBUp2y7bzWQdJtroJwyWsGKOhepnWdGR+/rTBlywu65kkKfK
DsMRfTQUvD2hauk2jBwQ/f5oxtP1H1Mlb1hbZtvotrVDeIuXaUsS/JQvM40Diz3q
ErRjoSACkZfcUyL++t/rE1J6YqBnHTaLzDRBq+pAZMhO5FSRwIUfkGO/T5Z0C9jK
k4PE8BJyW8oXd8V75hfsigNJkRe6F1VVB84qDUc9zqvYAvgi95CrmBrCHs/VGT14
OMMuYxNFeiIfDmZEiowbR/4gtiZ3WHR8O1BlLwr4R+QSqL7Y1EZnc7GVVghuwkkP
EOO+Yv8vmO/E+6HHnL82an6cCe5IWMjdxL+uXzoaK7zChOTA9D0lrkiFMgwaOa8w
Z89pnoGMJdOtHlBo7JCyJpao6sER5CXKBQ/NV5k++q/OVbw3nV093PW8NE7NngV0
oaCkSbn51hzO29qS0ETf
=JLRH
-----END PGP SIGNATURE-----

--IpbVkmxF4tDyP/Kb--
