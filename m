Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab2BTS3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 13:29:53 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:30785 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab2BTS3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 13:29:51 -0500
Date: Mon, 20 Feb 2012 21:31:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: pradheep.sh@gmail.com
Cc: gregkh@linuxfoundation.org, lucas.demarchi@profusion.mobi,
        devel@driverdev.osuosl.org, devel@linuxdriverproject.org,
        Andy Whitcroft <apw@canonical.com>, joe@perches.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] staging: bcm: fix checkpatch.pl errors and warnings
 in Version.h
Message-ID: <20120220183109.GL2855@mwanda>
References: <y>
 <4f428dfc.e302440a.02ba.6747@mx.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FxavXfDenm+F7xE/"
Content-Disposition: inline
In-Reply-To: <4f428dfc.e302440a.02ba.6747@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F429113.00B5,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FxavXfDenm+F7xE/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 20, 2012 at 10:15:54AM -0800, pradheep.sh@gmail.com wrote:
> -#define VER_FILEVERSION             5.2.45
> -#define VER_FILEVERSION_STR         "5.2.45"
> +#define VER_FILEVERSION			(5.2.45)
> +#define VER_FILEVERSION_STR		("5.2.45")

These don't need parenthesis.  It's bug checkpatch.pl that says that
they do.

regards,
dan carpenter

--FxavXfDenm+F7xE/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPQpFsAAoJEOnZkXI/YHqRZQkQAKMoW0gp/7gZpGiFjx2Xwu+e
PFHg5SYy8MJg1o3byo3hYxEUoTLSnYNcbksPBwQWZBx6xjcqUoRqaEyTq9kVXRWR
0ANXsyq40x2ZYu4XHl4V8LrGyXRzwRZHGrV6V0LACEAmG39oA7T2/CPO/OkHtJ0u
oMujCJBk7zYK8lwSWIGn+92Y4JYduPzB+z226+ohmEU/G75z5zf0HPdjnaNL2bp8
EsTxPQQfFAebslIqeyUlEynoJan3bl3Xn5EjxsVl+IO9VYQqYVi4PAZ9G9YPOgd8
tksyENm1LMDdBy9iTJaKR/o/9FGfR2Pyp66UaUaM6JbK+Qqkb2p+C4vBNq8P7jf6
wIQCv5pQ42458LwzNPKxKYFMWpQV/pOUMOZWHnIkbbzOWFjxWwttjwbrfi9M1CoZ
qiIvoqnz0ObXMphQc7rchZdDcinsKO4hqEvnlWX0hZLlI28s7XdUpjjb6aBRI9bZ
Nl5+Tdqi8Crk+sGmg5VzuhYEh/M2yFgaCyOmxrJAtZlnp0lFyAak1AUKS0Fzr3CE
GNj+U+zHO1dKyvinkEIrXfaCZA/SSrxJiDAFEvFeMx1RPm7dIr/WZdTDNYJuWgtS
JhophFHwE6RAcmd1IDUOEfA0lsxMn1SeiAKHtK+1gOVmgy92eDkS7c/+TZQbXF6+
6UBTmAB/brhsbY+6RSpJ
=oS/p
-----END PGP SIGNATURE-----

--FxavXfDenm+F7xE/--
