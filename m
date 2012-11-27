Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab2K0UOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 15:14:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51803 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755512Ab2K0UOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 15:14:47 -0500
Date: Tue, 27 Nov 2012 20:14:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT][PATCH 4/4] regulator: tps51632: Use linear_min_sel and
 regulator_[map|list]_voltage_linear
Message-ID: <20121127201445.GA32691@opensource.wolfsonmicro.com>
References: <1353983073.5422.2.camel@phoenix>
 <1353983327.5422.8.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <1353983327.5422.8.camel@phoenix>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 27, 2012 at 10:28:47AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com

I got some conflicts applying this one, can you check my topic/min
branch please?  The conflicts looked pretty trivial but too easy for me
to fat finger doing them by hand.

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQtR8VAAoJELSic+t+oim9fVMP+wdd4txT7Xj1AJ9wv9m64QZj
ZrB6bG4NuC0yif9VWXJ0cUgjQARSVF+RW3CPuPbDvqzbTB5r7dGG3yEfMg5sDd4P
PIdoDYtOqBXlUeDBlg3uyzo711Rhss7KsXh6W2AUu8h1ewb1I9HMccQEG7GCBmRe
Yev++5xGx8uDlIHl7Vccp4rrY2iw0rB/ULsDXLRcSfXrrQ4cDtJTj2J0QcOqPsFi
/T2nw9/onEgTVFJzo/NWCb0GH+/18umGs4EZTkLCSgGkR0WEAvpDy/TairNipoIQ
E3LBEjUX4NkR6ND6bSq0qhDlSzIj8eWIJXVjDwF0eQ6yzomZ1RQkTyxhzP2n3+DO
GFkcVG+2VCpRE+WSWPpUsiIcNOKOEbwVygDDKyyveIk8WQGp3lgdj/RD6QpI2qu4
nHQXHKg8WvV62HsfZlWSlAOmgFBBE7dphSxprJW09NdqRFWluZ5dNQZthJNzWqFm
Q0IqWCMPQCWmToKdSycHy2mC7PuFDQ3hYu62JEeaCL2XQBrXaq0d8TugoGIq26tE
J6BsUcszW3P0X2uPMkBQiulgSJh4t8cUbg+1d3fbLZlhfjwCF4rbYx7/2uz2qeC1
4GWbAQHpm8nmOjjHYBYMhO5eCCcizjY3nI09VMtXThSRr05A4i/IFWawUahf8dnm
zDp2o70ZdfibcaQ9xedF
=q9KU
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
