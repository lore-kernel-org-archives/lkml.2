Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab2J0VOo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 17:14:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40300 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451Ab2J0VOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 17:14:43 -0400
Date: Sat, 27 Oct 2012 22:14:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, festevam@gmail.com
Subject: Re: [PATCH] regmap: Fix printing of size_t variable
Message-ID: <20121027211436.GB4564@opensource.wolfsonmicro.com>
References: <1351181238-25568-1-git-send-email-fabio.estevam@freescale.com>
 <5089C2B0.6050900@xenotime.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8P1HSweYDcXXzwPJ"
Content-Disposition: inline
In-Reply-To: <5089C2B0.6050900@xenotime.net>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 25, 2012 at 03:52:32PM -0700, Randy Dunlap wrote:

> Acked-by: Randy Dunlap <rdunlap@xenotime.net>

There's not much point in doing this after a patch has been applied...

> http://marc.info/?l=linux-kernel&m=135041943424273&w=2

So, the difference between Fabio's patch and your patch is that he sent
the patch in the normal fashion and didn't do the random extra stuff I
keep mentioning when I apply your patches.  The things you do like the
random recipient lists and CCs in the text of the mail get in the way
and mean that for things like minor warning fixes the patch is likely to
get deferred for a big mailbox cleanup or (like this time) superceeded
by a version that's easier to deal with.

--8P1HSweYDcXXzwPJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjE62AAoJELSic+t+oim9uwwP/0D185QNQCdpAtNOUhIo5Ous
CKJ2QpdIK4FBQh2U6ZNqASb60eHTfNsruNC8lhD42Xt4OMljG37BUlOdicKqBXub
ZTSqDPC45bMYR2lWj6UGii69Pjy77z/aTuNA+OSW32xjpbHZL2hGcrVtioFy6ipT
Rj2TpQgtds5gfhXziUvA1A7VvEBmocW4ik6kZtyOnqg6sAMYYFt+u/kI5wDKj1FQ
bjesRq6231zp9Me3jEb5a7+o5lf6+UJHuLuT0cNOXZhy5Nwcr/f2mdcggIqk4ER6
7aQuLVQFQ909nUUX5b0MHuVSj+KiaiqJftqzeUHuMHnMv2MUk1o0ecXFnDdGySJK
PmLDOJ+cqhicgM9/Vz8CPnsHzz1CIGXurx/pS4groS5RtCHCJoogebRWGbNkKp7K
Bw1Ag6OfeQ7ZX/FRwEtdxJrwem1pUfoZ4GuEVznxfJLv/FNGvsM/XTTdOYdc9r+j
YWTzd4lI5RajNb8SogXeeEoEvDdtEjlOr4kz5SEi+vYDtkR9ctImqjGTlUz34tbA
71+MuJ7rjeU5GCrSuBcRFVRuYJWq8ytrcT/MDdzHkXbXARV3DCHcjMQlYPzavzVH
RaqOXHxV0Zx0zRHqN3vyvFz/yC85Z4vx1rvxJe1ilI8Z14dQETMyQwVVBOdV1UsJ
uJx6LWR7yCyLEZexcNnu
=j8DA
-----END PGP SIGNATURE-----

--8P1HSweYDcXXzwPJ--
