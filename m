Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab2KLOyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:54:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:60800 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab2KLOyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:54:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,762,1344236400"; 
   d="asc'?scan'208";a="218309460"
Message-ID: <1352732095.15788.55.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: gpmi: remove unneccessary header
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <shijie8@gmail.com>
Cc: Huang Shijie <b32955@freescale.com>, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 12 Nov 2012 16:54:55 +0200
In-Reply-To: <CAMiH66E9WTtt=6EhX9XVv9afErGd5Ajfg9qN6dVQhE5FEJVrTw@mail.gmail.com>
References: <1350147809-19616-1-git-send-email-shijie8@gmail.com>
	 <1351258892.1823.20.camel@sauron.fi.intel.com>
	 <508B4586.4090600@freescale.com>
	 <1352473841.1814.35.camel@sauron.fi.intel.com>
	 <CAMiH66E9WTtt=6EhX9XVv9afErGd5Ajfg9qN6dVQhE5FEJVrTw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-PTDjR2B9QFAzimi3B/FP"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PTDjR2B9QFAzimi3B/FP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-11-09 at 20:39 -0500, Huang Shijie wrote:
> Could you re-create your mxs config with "make ARCH=3DARM
> mxs_defconfig", and test this patch again?

Done, works now, pushed your patch to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-PTDjR2B9QFAzimi3B/FP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQoQ2/AAoJECmIfjd9wqK0pc0QAJrzmBGp6cz8IgVpb8AXgH3E
XUXwMqvFi6rHKFYva5QvP6T319XRZ9dR4iquZwCoDkVUK3S9MJbeBceyIs3/z0Ce
z2Tl5Bzo3+ZLKOnJGqTLwVWA21iEQEl7yWilTzrljus2T1hPRZFVUDzPw9Q97s7I
LgP6ORkKYS4+kCQGgUcFULRyWkhhhON8P6/6kqDA8pNlkeqTCBtKUUMeQ5mvAUow
dzUwWzyncz1GNjEU0cCwxAPHxciQtuvEvnWPfT9sZ92yY5bGsL0AkiczbW1dWsUr
bmSN2oBUQaoE6EYtUV3SaCxCASEehjuVK0Wiot2i+o5Q9UwKJOzKKsnjBs9P1uhr
He6is61Xw8MO0og9xHHGvapTmRXPZQSdjUkOkbMzX+ixOoGSk1eLu/jtALfSQSYA
bbPARsnraOsTtgwaN+56uOaVPSoSlUKdMWaInqvzgUw/fEw433N3Xqr9a8+MhC3H
MLdc+iWqGRpCNLUNsBVFk8DBJyuGv49xBzbMFytADPzvZulfhHMJMXCeOcXluGXj
ICWVtjBaRH8mQLQ0UG4+4ioNJukn2ah7Ao/EdQZqy9n48GFT7CdJziJikmDu8nYf
R5aRW+F4Bk6KTWqb/JvBcnoKU1sY7PGwv8RH/OuQOQSrUHawVSqzvUXi9JUPMOIV
vj9xNsj5mPfeiQb4utZA
=qlxV
-----END PGP SIGNATURE-----

--=-PTDjR2B9QFAzimi3B/FP--

