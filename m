Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab2DEJsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 05:48:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48861 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753124Ab2DEJsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 05:48:50 -0400
Date: Thu, 5 Apr 2012 10:48:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: rc5t583: Fix off-by-one valid range checking
 for selector
Message-ID: <20120405094847.GE3129@opensource.wolfsonmicro.com>
References: <1333550289.5856.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RpqchZ26BWispMcB"
Content-Disposition: inline
In-Reply-To: <1333550289.5856.4.camel@phoenix>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RpqchZ26BWispMcB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 04, 2012 at 10:38:09PM +0800, Axel Lin wrote:
> The valid selector should be 0 ... nsteps-1.

Applied, thanks.

--RpqchZ26BWispMcB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfWp0AAoJEBus8iNuMP3dh8UP/1JRxxNCG3X6Blg1fLru851U
YrUATMyj2+CaBq5KY+OdtGIl8DYrDJrSgezdpa79u7au7r5v5j1P6zZLSOTrMupd
ghkf5Srj7e4Z2dhZ9yvmkYUuLs8Swu3uRGiA7tjaPqZI3tzgS3shRFkZyWDA69oy
78S/QTQ/D7Q3ze8yMK1BzzzvXGJzxAR7C9UKnSUVYHiyeUO/+yL5tMa5IbghlkT3
44KFpvDgopqUtNQsywZq4d7SckkBLvnZRAutPBLxP09OgM21EuOj3X5TGS9ymdCh
kJVAl3Bv3FORlDzyX66Cg9LUlRo/D1LhOHjdOBnGM/zhyToSeAovb3ynAGxdyc4o
hdInyulQvCHC1ne6CJmEIc2PKFRO+27v+bpHGesGa0Qx3QInc+gTsiPtEaVQNamT
kx0el3vaZ89B1HVsz7W/9AptWQJhnOaprk5ymGqRdzV9wD9nTi+LUhKBVdxKjoCi
lMnewElbLklzr+QP9VOHkSbhSYqB5qNnfmJcOqTa7LZ6CKcX8wTwax3gKKmv8Kfv
FHIpH6lhvRzkBmKy6rxJE9ZESU0JObdOZlEfiOIMKqfI4SqWYxw086oItj+RHCUW
izpGZToe01hQbm3DEpSH4c2UlkNkwtnmrFzycLGKbrmLnQsOIAl8oEL6UR/wPZk3
zjjD0kMvrqVarZugoXHl
=0Xlc
-----END PGP SIGNATURE-----

--RpqchZ26BWispMcB--
