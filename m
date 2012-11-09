Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab2KIRKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:10:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50948 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754639Ab2KIRKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:10:10 -0500
Date: Fri, 9 Nov 2012 17:10:08 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] spi: tegra: sequence compatible strings as per preference
Message-ID: <20121109171008.GX23807@opensource.wolfsonmicro.com>
References: <1352452052-13823-1-git-send-email-ldewangan@nvidia.com>
 <509D37B8.8020606@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CRrRoVXEpX/Dc4YP"
Content-Disposition: inline
In-Reply-To: <509D37B8.8020606@wwwdotorg.org>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CRrRoVXEpX/Dc4YP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 09, 2012 at 10:04:56AM -0700, Stephen Warren wrote:

> However just FYI, it should not be necessary for correctness; The DT
> matching order is supposed to be driven purely by the order of the
> compatible values in the DT now, and not affected by the order of values
> in the table. (This wasn't always the case, but was a bug that was fixed
> IIRC by Thierry Reding).

I guess the driver is being used backported in older kernels which don't
have that fix?

--CRrRoVXEpX/Dc4YP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQnTjpAAoJELSic+t+oim9eRAP/2C4WUVsyEEvfHlf1mVAC4GN
VXxJ38fLwPX+SJghZ2ReHlicEe65SN14UZ3zYM/JVts/bbqY0DZ4Hbm2Xz2qNGJZ
e0DZx/h93xzTXRBC3JnuBZmd6kVAtyq8bD55jMF6JxFIu+EBZQnpzC1hjzsZWGaY
sff/n6P5SpUGznJ/oeA60MmPWGq+gTw7wGTVura7dMQdOQScqZdPy+q/jLVKX1G8
FNN65h7rKzbRcLSckE7JpLLinxPPSr+Awk7R+wzavi94BWG2ivBgLGnVFNy7XA0+
MxpCJyKr2CFcvU+yXkre012wZgGzhICZVmg/ygBcQy3MI6LLO1XCHnoMRr7wXy1D
jX/wlQ3Kj4CENHB4r7kQ7P6TnKHyEJH6TXa1bVDXbtfrlaKhZuK7nEpwA2FXaDRh
+MhNxDqr3LQLUdEfFwVVDm/jpclal7Bm2qjRucESycT5TR/oJGg1NJQe4bPWIWjb
nAGdwf00LV/IMNd4teVPTtP0Olx68/HW+266wP+waXdfQjUZz1KHU2Hh8s0+J/o+
h+9RSsTQF92y+OGPI4c7QnEacRQCUNpRZj52WRXi6BseEGbR8upqw1LowQi2XlCa
n1TKqTZigamzHBq1idF16TVHRfLxN1et0SEVMy4cXVzWycAb50KEP8d+t2PZA1iN
4j0g1ORuGVdHMuqxZrgn
=erz+
-----END PGP SIGNATURE-----

--CRrRoVXEpX/Dc4YP--
