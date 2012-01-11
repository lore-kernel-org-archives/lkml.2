Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab2AKNv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 08:51:29 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:47500 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547Ab2AKNv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 08:51:27 -0500
Date: Wed, 11 Jan 2012 16:52:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: nagarjun kommineni <nagarjunkommineni@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, Bart Westgeest <bart@elbrys.com>
Subject: Re: high speed cams are not working on usbip
Message-ID: <20120111135225.GG16258@mwanda>
References: <CAKPZvrbFV5oR8tHJEYUzBhC7Z4pSaCXdG_3BGD0jK-6_A3nmiw@mail.gmail.com>
 <20120110103929.GH3644@mwanda>
 <CAKPZvrah6P4vR9vsrbtTzWwz=tVAE_eyabUhGt4+C39N4Cft8w@mail.gmail.com>
 <20120111125137.GF16258@mwanda>
 <CAKPZvrbwZEFY1zZ30Tcoe9TBw6AoP+Xf2oX5VenQYKvZA6Z_Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hcut4fGOf7Kh6EdG"
Content-Disposition: inline
In-Reply-To: <CAKPZvrbwZEFY1zZ30Tcoe9TBw6AoP+Xf2oX5VenQYKvZA6Z_Pw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F0D93D7.0069,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hcut4fGOf7Kh6EdG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

So on 3.1 low resolutions work for usbip but high resolutions don't.
As near as we can tell they never have, so it's not a regression.

File a bug on http://bugzilla.kernel.org explaining:
1) Which resolutions you tested (working and not working).
2) What you mean when you say it doesn't work.  What were the error
   messages etc?

When it comes time to move this out of the staging directory, we'll
look through bugzilla and see what bugs it has.

regards,
dan carpenter


--hcut4fGOf7Kh6EdG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPDZQYAAoJEOnZkXI/YHqR4UcQAKQIMeJFeAbNrhIgu8nvOb2u
UhjJ4cpiM2mkmp8Etp+sExP1NrTxUn2qrAD8kkLY7ywVZY+wMLwhm9IXzJkuq1vb
3l9Lcm2m5bY3fpkpWV20ix3fK0jOiQQeEneST3d65g2fqBPlRUo/ivifKSWPKhlQ
oFFf1TvWQAsHEzOo8zMOmI4PbQjdUEc7iO7mb20WvkeNzZnoiVa7soKf/4simNKX
Iqvb4K0gwzPLtP4KownTTDuxigkDqRD05wjDnzo/jRLxH4i8ULhZ6iUWH/ZcNMt2
Cs1uN08nraYooBQF2C1UqgrifTdUuYv16tLNidT+VXMC+l2nRjfbY4KyN14rvFEa
nMIyv0rnEZ+rzA7JDUXobTLdKx62zssNPxYw0wo/KW738jHkEkC6ZK9ZoPFILmQa
eWnMmsrNC/3QIx2gBhMkpcnUavRYimvde3YIS3i2HAdF+P6uTWOUdHTGyxJppXNf
y8ZyUffB+ebZUWngAcY0ItPVqQZvrutliE3GZkWkC3k+9o4EuTAQFkKsZe9AzSve
Thwf+x9dx+AIiKcZGy2+GIsMFZUzc2juUqloVKB0HvcUxlwiZI5m/2qNwPF9cJdh
My174sZCgix09TxpnAdHP+kkmeU94EN58HooOsOr0WdXx1VCMYFha9KXcZ7LGG96
s0LTmIQUPb6ZayV52WPJ
=UQO/
-----END PGP SIGNATURE-----

--hcut4fGOf7Kh6EdG--
