Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab2KUPCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:02:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:23436 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968Ab2KUPCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 10:02:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,293,1352102400"; 
   d="asc'?scan'208";a="252413159"
Message-ID: <1353510173.2701.7.camel@sauron.fi.intel.com>
Subject: Re: [RFC/PATCH] mtd_blkdevs: Replace request handler kthread with a
 workqueue
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Date: Wed, 21 Nov 2012 17:02:53 +0200
In-Reply-To: <1352563700-5268-1-git-send-email-elezegarcia@gmail.com>
References: <1352563700-5268-1-git-send-email-elezegarcia@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-WFLYCMai6pYn34gU6uNV"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WFLYCMai6pYn34gU6uNV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-11-10 at 13:08 -0300, Ezequiel Garcia wrote:
> By replacing a kthread with a workqueue, the code is now a bit clearer.
> There's also a slight reduction of code size (numbers apply for x86):
> Before:
>    text	   data	    bss	    dec	    hex	filename
>    3248	     36	      0	   3284	    cd4	drivers/mtd/mtd_blkdevs.o
>=20
> After:
>    text	   data	    bss	    dec	    hex	filename
>    3150	     36	      0	   3186	    c72	drivers/mtd/mtd_blkdevs.o
>=20
> Due to lack of real hardware, tests have been performed on an emulated
> environment with mtdswap and mtdblock over nandsim devices.
> Some real testing should be done, before merging this patch.

Looks good to me, thanks, pushed to l2-mtd.git.

--=20
Best Regards,
Artem Bityutskiy

--=-WFLYCMai6pYn34gU6uNV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQrO0dAAoJECmIfjd9wqK0piMQAMhcbdB0HeEj8TfitfYq7+LK
2uMAim0/Mq7WJ3zZE6PVJ5CddCDfDwb04UNbSdUPig7CXkLNA8d3YWJXbj3nbERS
It7F4DRWhkiSVIrSbnrAxd9hb8kHDUL7aGBg5kTDdZIq4CwDRcJArWKUvfhcD9OQ
ors/G7WbM2JTPHdXkuKM2YzodyH9SQEFlT0wpix9ctBAnBIx/RgYDWgmIR3/fQlo
hcAGAXr2bMRLJ7hDSggYJkEJiqYhOKe8+rFV74MHx6b1KHIknhF3h7vjNJU6LiEf
nEBZrzbLFif+WCqUsyMJ055iccSOJgQ110c6yxMncQ6Io5JZgF0zxC/wOYUrR8uC
EBCuXpf/hZccxpbXwsZqpNhOqjYjq2D7HldxVx3dZ/QoLej1tsrILtw0aKbWHAWL
k00rIYZJM2P4vxHRguwEO+e4scMwxR+vjK4K+eFzq7rr81ubotQuKkCZt2rwgy++
loTVd9fQvIlPZSsfI+KYcByqBuWXTM7PoWMFoSaPfDrGyJZvZnZM8BmfGhyj2eRf
H3qhsBIa0A0mve99mFEWDjdkKGgvprw0qZGxkskziaIaEPuAoQa3ih3cX3qs2YzU
FFmOxFHHdKU1nRGfR6vUHJ8QPimLuNZjNfywhInQtvoRtRAyN06/CK6NzfkjVtoR
lcdUWACedIqUP1cRrSvS
=+o2c
-----END PGP SIGNATURE-----

--=-WFLYCMai6pYn34gU6uNV--

