Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab2EBNoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 09:44:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:62551 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab2EBNoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 09:44:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="137950315"
Message-ID: <1335966464.10293.53.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] M25: Add support for Everspin MR25H256 MRAM chip
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Marek Vasut <marex@denx.de>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Date: Wed, 02 May 2012 16:47:44 +0300
In-Reply-To: <1335837840-15511-1-git-send-email-marex@denx.de>
References: <1335837840-15511-1-git-send-email-marex@denx.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-UiWbTCrIQAzLVO15hDn3"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UiWbTCrIQAzLVO15hDn3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-05-01 at 04:04 +0200, Marek Vasut wrote:
> This chip isn't JEDEC-compatible.
>=20
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> Cc: linux-mtd@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-UiWbTCrIQAzLVO15hDn3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPoTsAAAoJECmIfjd9wqK0SYEQAJGTSEvZc+EjFtLorejvlj8s
jQWZlHAMSfailhX2BPMEuC9pUIP0jYqlAX1KdzCdn6J3XGbiIWvtaiFPej998xKQ
E/kgnbWOy0E2p/wDa2TgJPBM2qHyVDcYa1DiET2WwXF1Mbgq/MM9FfXBb314Xc47
goUvrUIDVai65sKVWV2t55Np6+1ZijIxLwBnyBYmyEqngkkJlUVth8U3vcK1hi7k
C9sLgjLSFpJkSLA/O7spPzxCnoKNNLbOZjsfax/PNMWiSD049cp89jQrcmm0g70W
pnmV5HMyfYAJMqQxMGiwae5k+d07nP0OBruc5kWAVwi4dZ1B1PwqXItcOktWXsBJ
cEHz0Buzxpi9qFrhDvX64XR1HEnVsaQ6ycq7NsQO42hbnnla3squTRiZ3k6XIdRI
l4bZCVrq5LskXJ8xI6+czS8tP4rcoPS2pe+96yDIVk1/uQiQCb7de+b0GG2erQIk
UnEyn5uLKUa4PSTeJnPidKXuXefOjteogUKZMD8Gm4HA9tC+9OA3OO+csk4YeUh0
sTtWDrUfdOEGxm7aCZzjuxzkEyt+nyjzAPSb+p6JoTYT3V0XD0bBaNx2FkB51OY1
ZgonSIuKohlMriG7pqMaXooXAU3aWzJ7MVnbF/qduHasOf8OCgYqylukuHkK29a/
A2YbKHQSPtDNl4R1hUCS
=2kqr
-----END PGP SIGNATURE-----

--=-UiWbTCrIQAzLVO15hDn3--

