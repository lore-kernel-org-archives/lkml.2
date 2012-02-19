Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab2BSTzw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 14:55:52 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:18858 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab2BSTzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 14:55:51 -0500
Date: Sun, 19 Feb 2012 22:57:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: santosh prasad nayak <santoshprasadnayak@gmail.com>
Cc: mfm@muteddisk.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Staging: driver usbip: Code cleanup
Message-ID: <20120219195751.GE2855@mwanda>
References: <CAOD=uF4st80fB0+uwXNNbHtN4YpoFWwu4EUhwmVi+v=0euu=sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ep0oHQY+/Gbo/zt0"
Content-Disposition: inline
In-Reply-To: <CAOD=uF4st80fB0+uwXNNbHtN4YpoFWwu4EUhwmVi+v=0euu=sQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4F4153C1.006A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ep0oHQY+/Gbo/zt0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 19, 2012 at 05:48:39PM +0530, santosh prasad nayak wrote:
>  Code cleanup: removed commented code of old style lock initilization
>=20

1) The patch is line wrapped so it doesn't apply.  To test, save
your email as raw text.  `cat raw_email.txt | git am`
Read Documentation/email-clients.txt.

2) The subject could be improved.  Do a:
git log --pretty=3Doneline drivers/staging/usbip/stub_dev.c | head
to see the correct prefix to use.

3) Instead of "Code cleanup" choose a more descriptive name like
"Delete commented code."

4) Use your full name for the Signed-off-by line.

Please fix these and resend.

If you want, you can leave linux-usb@vger.kernel.org and
linux-kernel@vger.kernel.org off the CC list, because no one on
those lists care about trivial patches to the Staging tree.

regards,
dan carpenter


--ep0oHQY+/Gbo/zt0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPQVQ+AAoJEOnZkXI/YHqRWhQP/1OomrMtIB0A03yYsOfRo10F
ImqWJbXrM+iE7Bw/8VFmb7z+rbad/WbFFMyT7lWJf283XwS+UwumT9UO2CB0h3Ho
HAU+WYv/3Le25YxtuOnf4tSGssQFQ+Ko3CzYQYtskEYlOl0Oke7/IUH1STic25ni
EF9Am/fJzm8v5I36Rkk3sr6c5+W+/xrhknd1UX5vSQ1xxKGQlix/oNmTQESl0yY4
Od/bJCuQZvlZXhrrhxVdeENvaRYGm7TG+orisyzfYJp/W/+B5BLxkLxVu5+DrHSb
jeHIdYC7W/jWtd6uZljbj6iMtgxPEbC69tfN8hazLASKSD3FJcDyJ9iF91kz5BCN
Fa2Xe7tyDQ9dK1ZPGu9qAfD29YPuJY8g9oCpae5MTzoChsKi3HINrRgBZb//sZxd
8pCO3LTjKu8S0/M8E2AObv3DUAEdlFRNcWPhu/JR2yJXPGC2nXxkorAqZezGK4/J
/BLj5JqKZerHn7x+BiP5J+ysPmk0ridyolalxIF87LtXHPuQuloJe9/THfuKozWt
2x3nVF+jnLGN3ULX3l0WdwfYfPmBXVkICYA09eflOAWcNFIIz3GtUgnMZV+VVv8L
0bDWcYLQEFCTEhlBQzUGtBbdMPtuKhzfJsdDXdgNzeILi6NDCSR7xTEFRhnCJ6c4
wUBJZM3iOrkFDMWtSPQI
=vJIr
-----END PGP SIGNATURE-----

--ep0oHQY+/Gbo/zt0--
