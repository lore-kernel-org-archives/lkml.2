Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964953Ab2ERQhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:37:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50541 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932587Ab2ERQhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:37:40 -0400
Date: Fri, 18 May 2012 17:37:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps65910: fixed build error
Message-ID: <20120518163736.GP4039@opensource.wolfsonmicro.com>
References: <1337342245-23154-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R3SAtXwgGp429mN7"
Content-Disposition: inline
In-Reply-To: <1337342245-23154-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R3SAtXwgGp429mN7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 18, 2012 at 05:27:25PM +0530, Laxman Dewangan wrote:
> Some of the api calls are not changed and it leads
> to following build error:
> /regulator/tps65910-regulator.c: In function 'tps65910_enable':
> /regulator/tps65910-regulator.c:491:2: error: implicit declaration of
> function 'tps65910_set_bits'

Ugh, this should've gone in as part of the MFD patch :(

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--R3SAtXwgGp429mN7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPtnrLAAoJEBus8iNuMP3dRyYP/3Y3WBoYCnFwOBvHS67XeZXI
p8/5XVhzg+/owGhhpVtuX7AGyU3M1S7iTTP/FPDb/sTwWFj6iRwSeIjzkadhKSEQ
H2DHs72P92xfZMoVm/FVG6U3uU7MHldeXFFZiANbZsFi8FE9Iem2tBv+qgTeFPcC
lwOyhM+Kd5RZxW+0aZrlMNp6Wj16d0Wr3FXA4wuYC5TqCGS+TXL989y7drJwgjXS
j7gW5Vppp53Ru8jhX0qyQvgM1IGXi+AAG+JDWZtO9J5ij7hn6KJKhKN4HhMnGOsH
aNYaXQZTIDTP6D1qXCfalUnfwUXQ93FeemsNgaqt/r1yE3ve9IQ5ct8iHGiwN0So
vasuE0+rDzRgCzVvTdQ/KLymOBLcyHbARVaPvnyA6pfO0DwxQdYrHgB3tzDiw1GU
HSB3a8GqEEIF4GZtnAjdXZtB4d5MjW9TpFqqDLsIaVEPTmYW8Sh6M9UPXOSxu3y8
499qtrKrGkG22yBC1/9z7X1234Nb9OKSnxERNY0taZyHFrfbGbY0imy087T+tyC1
n/OHySP6MQbOPYMkcP1MHMYxfb6cJRGGZLHPdxsn7p24m+tlW2bA1rTPVUH0HCev
YUEhHfepsLkD3GBHkWQZzEwOF2tHxcWjGr0huV1Vj0WdVrmuf43sZ3tbKQq3vtIP
Jb08sWbfrpIH7ouZXIXC
=5IbH
-----END PGP SIGNATURE-----

--R3SAtXwgGp429mN7--
