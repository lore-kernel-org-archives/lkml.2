Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab1L1IwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 03:52:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63510 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1L1IwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 03:52:13 -0500
Message-ID: <1325062442.1165.95.camel@sauron.fi.intel.com>
Subject: Re: linux-next: manual merge of the staging tree with the l2-mtd
 tree
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 28 Dec 2011 10:54:02 +0200
In-Reply-To: <20111228175440.fa8c027e41dbeaccddb0e6ea@canb.auug.org.au>
References: <20111228175440.fa8c027e41dbeaccddb0e6ea@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-oI24t2nWk8ReVI/pv0at"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oI24t2nWk8ReVI/pv0at
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-12-28 at 17:54 +1100, Stephen Rothwell wrote:
> Hi Greg,
>=20
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/spectra/lld_mtd.c between a series of commits from the
> l2-mtd tree and commit be7f39c5ecf5 ("Staging: delete spectra driver")
> from the staging tree.
>=20
> I just removed the file.

Oh, it is in staging, I somehow missed that and pushed a small clean-up
to the MTD tree (because the driver is an MTD driver). I'll kill that
commit now.

Apologies for the hassle.

--=20
Best Regards,
Artem Bityutskiy

--=-oI24t2nWk8ReVI/pv0at
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO+tkqAAoJECmIfjd9wqK0ZX0P/1DUsyt05R3vaLSEXDdwMwdf
05AHa71V6cGBYtKqRsxUENY/Mz6dOvxZTRYi46rdiU3JTk2JyPpBEB2kWB4AZbli
dWHzHtl7qoJLmbcL4jx3HmtUFD0LcDRolmTwqerXFE8aR8IY+Xhh5XDEQ2Q7W9re
a9scWWTb06ejypGEbD9Ktd1W9IMit9+EHusiP0kWpNoZmg0xaSBvj0XzfvKBxokD
WbSiXUPsvEIcCd685ptmFd41V+rVFWW1GuzDNxFy2GyzE4Mxv5D7hUg9fZGw97nk
cDO7DoBa2oqCEVbU9IZE8YhhGnp27KLecvCicfyWbDRpUk8/88dFSMxxSELJkMIr
xRawfc1doGyVxFmWtMWRrApSyLLAZAEbzHH5qNcUdxO82na9Vt9PCDMipYqPOUjO
Y13koXyVnNQw/RT6Yokjg/VBCu8R0obJf4UxIdFcmp5WO7PyMIkZBFdbWAx0c9W9
rPGBaOStD7kRywcHQ5gyPQRWST51ZiGeSiaNaAMjyDxjt+P0mpdbO1Jdo4OlLRfn
TTUCFWxKORcKQSmmblK2S4nhiEogffQLPuYF6MWKJ95ViEZHUGm+j7ZNsdXNg9fM
90LZhsy2U/DyPYutrcGIHGW7YBS5l890OMSKz2telHSJAzeQWUxiqa1HvQqLwxgH
ihKlJUnoEtMX6jW7BxhB
=uQ+F
-----END PGP SIGNATURE-----

--=-oI24t2nWk8ReVI/pv0at--

