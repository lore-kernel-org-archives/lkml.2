Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab2LJOpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:45:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:40275 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856Ab2LJOpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:45:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,252,1355126400"; 
   d="asc'?scan'208";a="259977041"
Message-ID: <1355150764.2657.35.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/2] mtd: mxc_nand: fix unbalanced clk_disable() in
 error path
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Lothar =?ISO-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: linux-mtd@lists.infradead.org, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>
Date: Mon, 10 Dec 2012 16:46:04 +0200
In-Reply-To: <1354779748-28869-1-git-send-email-LW@KARO-electronics.de>
References: <1354779748-28869-1-git-send-email-LW@KARO-electronics.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-hLZUFHVxbzo6TI9v/LuP"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hLZUFHVxbzo6TI9v/LuP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-12-06 at 08:42 +0100, Lothar Wa=C3=9Fmann wrote:
> If nand_scan_ident() or nand_scan_tail() fails, the NAND chip may have
> been deselected and the clock already disabled. Thus, check 'clk_act'
> in the error path to decide whether the clock still needs to be
> disabled.
>=20
> This fixes a:
> |WARNING: at drivers/clk/clk.c:472 __clk_disable+0x3c/0x78()

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-hLZUFHVxbzo6TI9v/LuP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQxfWsAAoJECmIfjd9wqK0pHIP/RKLDmWRuyH3K/tbvCJfEU6Q
ad8J+BOPzFEAR3mBuaMPwRYy+EUghDVUxaWHYW9/5TlOQM7m2kCun9P1UWZLJArs
mShDiLKPfJWWytcIj02SFBBA2iLJz5HrZHrr5RmAs48D4fQatb7VeY3Wae7CZgNN
GrLY6rs/Bwpcxaejtf7kYjhPcRU5EcVQ/6e5sruAyB++wUrguNQaYGCIuC69qgNk
2fBePfYisZ4KxqJ4PrWBCKVohHbNJfEwL/oAjsj39lqSAp0uJ4IydrqhbIZyQ0aL
qlFPhHME6DeLrh2p42zgAaA5cEAlBQdVur4gePhIyTgpVpSeB/Skp7mAucilGZbk
1+GVgrynqu/uK0+9hOuLFOPoC3yjuZEyiCburOcfELae4165PM4/Id3M1GpjGogD
30PpM8fGkjIO7/e/AgeEy1gP+lEyu7S0MZyPkKYQCuNge8qpBeKFRgq8c/V02QcF
jmJ50NZRW1Lb41xYHJrmp3VEtyof3pgjuw10wloGbfWDb9BuOhIK3Cy2CtNvB2pV
jHWsEoUaufOEpr2IlAw1RlTll9OYlt3e93UxjLgpJeBkLcRT7JyLzaMGEV29C7FE
Gn0rOw6E2IkuMYpQvkIoXbm+R1M00MC2P69Ark+OdNKJ17UZn3sSMbproS6N9ZyY
4rMI+vh5RlcuphWqGvFu
=9spq
-----END PGP SIGNATURE-----

--=-hLZUFHVxbzo6TI9v/LuP--

