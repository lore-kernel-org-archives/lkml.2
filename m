Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab2EIU3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:29:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42439 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932272Ab2EIU3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:29:42 -0400
Date: Wed, 9 May 2012 21:29:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: NeilBrown <neilb@suse.de>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] twl-regulator: define all feature flags in one place.
Message-ID: <20120509202938.GA21307@opensource.wolfsonmicro.com>
References: <20120501204259.27026.40156.stgit@notabene.brown>
 <20120501204449.27026.29720.stgit@notabene.brown>
 <20120502090848.GF4075@opensource.wolfsonmicro.com>
 <20120509195041.GR1794@sortiz-mobl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20120509195041.GR1794@sortiz-mobl>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 09, 2012 at 09:50:41PM +0200, Samuel Ortiz wrote:

> Could you please re-send this patch to me ?

Neil did actually resend this the other day as the regulator bit needed
rebasing to current regulator code - I ended up applying it since it
looked like you'd missed it after you went through things the other day
and the main thing was the regulator change based off it but I can
easily drop the patches again if that's a problem.

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqtOpAAoJEBus8iNuMP3dEjkP/A3WiHkzuIu5riMqrmYM/+m0
vJcOGHwIMWXNcmKrVmurS7gZ7zOhFKPfJJ18F6UVXWmtKmfT4+ZYpDovXtSny1pz
DtjNbNKj2XGF3+KX39u+VU76pW1TO1kaGNimk7obeY4DynjjOw8tsatoQ+rj55Af
0mvqAdMnU0BaLdBY8niEfrsJx/5KQGHHQ8u9E2L1Be8pY8IOM3/g2hWbIyjWKfyt
b8GO9QJgNiRa70QigVVlbe5feVKAP8/RdrEoMHfHk5/B/w1CT7lcOE8/UqKFDN0e
oV5eKp6MddFzQceo3emCjn9CwWL9LahAzjnHza7anhNOqOS0gmiSlrw6Nuy4GPfO
KY9Jnr42PErxZuDvhxztbZmqAtzDrVz47ZFNJKYAFKhI1EKYAhReHyJ6QbklN9kN
Lrdlhx9pfBV+/vP0WeKPa2Jl0eDHNlrZxgfzd9qzPpX6TYiuAJMMWezE7KDt3JFG
lhrnHyZCXXRC85FC73dz6j1xclzpVnIp8PBqcVxQIBC8z28km+eww5hMFitzSgDf
G7JZHsuMWeXuiE/SnttAdvCE//4uvWN/8fYDrnIpTeEsnThaEC8gzTbJHSyTkngF
W6OumWgnqdgajH2rsCH39pWUkHGESxWJWktYoFKAhpfJvHJSFK1+QDdrgRyjRW7p
4sU/6jwqfWicFzEQ+73v
=Y+Uf
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
