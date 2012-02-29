Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab2B2L1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 06:27:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46630 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab2B2L1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 06:27:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dedekind1@gmail.com designates 10.42.73.136 as permitted sender) smtp.mail=dedekind1@gmail.com; dkim=pass header.i=dedekind1@gmail.com
Message-ID: <1330515018.3545.96.camel@sauron.fi.intel.com>
Subject: Re: [PATCH resend] checkpatch.pl: be silent when -q and --ignore is
 given
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Date: Wed, 29 Feb 2012 13:30:18 +0200
In-Reply-To: <20120229032530.b948ee51.akpm@linux-foundation.org>
References: <1330364758-12065-1-git-send-email-dedekind1@gmail.com>
	 <1330513326.3545.93.camel@sauron.fi.intel.com>
	 <20120229032530.b948ee51.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-NiZ34KXWiaKYLPhTT8+k"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NiZ34KXWiaKYLPhTT8+k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-02-29 at 03:25 -0800, Andrew Morton wrote:
> I applied it, but it seems that for some reason the applied-to-mm email
> didn't get sent out for that one.

OK, thanks a lot!

--=20
Best Regards,
Artem Bityutskiy

--=-NiZ34KXWiaKYLPhTT8+k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPTgxLAAoJECmIfjd9wqK0X1kP+wcVPPQY9WNBargDtA+NzkWZ
ziOiqzUEzoEMW9lUpcQouf1GHM77MU8+eea9V9sHgyTYp3Mc0COc1dc44/ISroQz
QQu2xbUyZhPCZKizjO/i4mHS74K2ONfU/OLdTApp0wTdZiuFIp7VS8tjiiMQLjED
nCopnktz4BVUx9sGgq0Xxq6bXW5RWUwrytUOKtdSnDFOpuLCrjH8U7KkhLPwVIti
znTy4mpOgFT0tYfgE8FSWYzm0hd26pJIlT3WpntbOfMOSRZuXUI9Fvl+Y6rMZoov
+pTz1ZAfVzQPSf2N2Umgaj6SUP8Rq+tnP0v2aVnDsrnsbKT00lxqVt9E+ygjiLpx
CxtrdtCqRkaCHnKwNwURgAOkiLW4JURJ617ZdkSeb0hvwyVApXUTIqtWAfyE1B5T
XvjLlxgKDtqJs01gNULOzfSjFKN/Rq7e+liNFxJ74dDrvLM9fkZlZGJlkm6P/6LX
fQfEP9F7gIhB6jGURsHtfrV+G7qQeoVpDNps0wFKLi+FIS0/55k7o7RGIciiyDBQ
iCjIFvQCG/oYnWspUlkg6iwwNDlCd9ZhaMKcWicS2uTHp4K5F+zlQXRDm1FaX/bK
BG5nCK9fgwvV1EEX1MYrJ2ltS5XRDTyn7IFwKHdJze83KjNuktwqW35WkZhWpoIy
o2PB25oIxvM/Z2qZSyhk
=A5cs
-----END PGP SIGNATURE-----

--=-NiZ34KXWiaKYLPhTT8+k--

