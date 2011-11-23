Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab1KWORb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 09:17:31 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:19203 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab1KWOR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 09:17:29 -0500
Date: Wed, 23 Nov 2011 17:17:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] iio: Fix build error in industrialio-core.c
Message-ID: <20111123141727.GA3195@mwanda>
References: <1322043239-26082-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <1322043239-26082-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4ECD0072.01C7,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 23, 2011 at 12:13:59PM +0200, Sasha Levin wrote:
> The error was introduced in commit b4641336 ("iio: fix a leak due to
> improper use of anon_inode_getfd()").
>=20

Which tree is that patch from?  It's not in linux-next.

regards,
dan carpenter

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOzQB3AAoJEOnZkXI/YHqRt/kP+gMEmxvCi4HKP5YSNazuIe15
9hWEDHexBurF1xRoO4QtKleka4JRUs9FWsvbC13qWXaMJkeqguRCn4XJxJTkDm54
+IctZThIcVJhJUv2HqKKQ0ul/2QPm4MaSWE+XtGlG4GyRgvcjxSg9en90w0+tfc6
vKcHx26GhW2cBMFpOcnUgTYpRxXlFTeHz6Vvt8OcNsUBFLh6uWW4AfhIrVWvnwro
LRed/sR9A/RSBsimNoU+f4PbXNI1rC3nOi872c4K+POpmPDIdzB6p4IXQtX+GSQP
5wGwUE2+K7Ci4nFAQfRHqXUKz5OnlY33t0A4AdO7n3AqdCjciWdvXm0NG/iuFf7U
Jc7vn9VLY3movTJYi8vcEgDzTAD5V1EmEYHjJAVGwfnayCQ63TTcNOUxWWv5eHWx
mLVBsFgzR4tdQ8otOeQO6kA7pRfg5xJlstJODxheth9elb6YJEtR8Q6IJ7T39nlR
DKryf6LmVfPwpdCbv7yOcD4NTkBq1RIsRUcUsUtf75rUrOmXwYCAIcBlLsLIiHol
vaMMjuNgPc1WQzb1B0YQidW8pfqeo+AxvvHSddbXJIkIHZobBfK7VDiSOMr80nwO
7iMjj1/ojXpJ7gStrEpyur9mc9PcZSA8GNPR4JP+4tYJPJ0+Pf7OMKyITbtAD+kM
XBgs+d/tVYw4rCS1w/UQ
=GZpM
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
