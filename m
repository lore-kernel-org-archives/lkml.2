Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab2BCFe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 00:34:28 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46320 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2BCFe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 00:34:27 -0500
Message-ID: <1328247387.6750.24.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] jffs2: update to new MTD interface (missed a few)
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        linux-next@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Date: Fri, 03 Feb 2012 07:36:27 +0200
In-Reply-To: <1328228469-10539-1-git-send-email-computersforpeace@gmail.com>
References: <1328228469-10539-1-git-send-email-computersforpeace@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-cKbzJXqHnQdEBHk0rkNv"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cKbzJXqHnQdEBHk0rkNv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-02-02 at 16:21 -0800, Brian Norris wrote:
> There were a few instances of the old MTD interface remaining for JFFS2. =
We
> fix one error that shows up (only when CONFIG_JFFS2_FS_WRITEBUFFER is not
> defined) like this:

Pushed to l2-mtd.git, thank you!

--=20
Best Regards,
Artem Bityutskiy

--=-cKbzJXqHnQdEBHk0rkNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPK3JbAAoJECmIfjd9wqK0agcQANJ+tR8fOcs2399i+NShneVH
zp+mhyy9OBwVwy8BE9fC5az88sGWdK/DWB55rgw9qpQ4oTydClD0pdwumY6r7Twc
PH8tO8iwLrefYxh+6IE01wwtJ3ltSz1FjCbI2vIOY6ZvyjaRlgX4yuhOCwuuA6S0
FQ1CP/hfi0/4hIJ5YzCDtYve2ZKOZzgkqEgQW6b4PakZFiawMiSrqt7VxpfkuBsB
CqpBWnAqOkUhrlUytvOFlgABacHsD7jMjpF5y+ADjba5sZSJbR3ytMAYXy3BKAVB
XTSHjGr8X2esOGp/i7+4ynJMlD81JeY3cVAed0+InMiPnzTPtFqNKK8G8HMMOy2Y
uB+4JAZBvEKOZ8AAE+1fzsxLkhiyUfaScugOW3FU4vqfz2rfpcxOlFbWhpR4aJUE
+YZWGQ8Pyq92hhjl26diIM++xf22EbIxmSxBCXA0loBYY05hQXZAHhMC2jOtnvNM
5oKPBRPCddAkEMGCO9xcvs9AxlonhKo7ErghjysvlWD6pc3Wyxa9VubH/fuJST9U
dvXFKL32TSmqSWgEISqZByzlPmCjS6UbsYE7D2hNggY/908kh2cdr/VNTX2VTk4R
eCwOawC2RUA99Va+TKfHw3lqg9+hIjC2hbktb8DmEO1RlnuaK8aYJkpo3V2fhEKu
CN4emcEJ8h2ODkkH6vkw
=TBWE
-----END PGP SIGNATURE-----

--=-cKbzJXqHnQdEBHk0rkNv--

