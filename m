Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab2KPJAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:00:23 -0500
Received: from mga03.intel.com ([143.182.124.21]:23029 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab2KPJAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:00:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,263,1352102400"; 
   d="asc'?scan'208";a="218628949"
Message-ID: <1353056458.20111.8.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] jffs2: Make handling of erase_completion_lock
 consistent in jffs2_do_reserve_space()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Date: Fri, 16 Nov 2012 11:00:58 +0200
In-Reply-To: <1352140814-25208-1-git-send-email-khoroshilov@ispras.ru>
References: <1352140814-25208-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-gdVzduy1btVmWwKOx2qE"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gdVzduy1btVmWwKOx2qE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-11-05 at 22:40 +0400, Alexey Khoroshilov wrote:
> Users of jffs2_do_reserve_space() expect they still held
> erase_completion_lock after call to it. But there is a path
> where jffs2_do_reserve_space() leaves erase_completion_lock unlocked.
> The patch fixes it.
>=20
> Found by Linux Driver Verification project (linuxtesting.org).
>=20
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-gdVzduy1btVmWwKOx2qE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQpgDKAAoJECmIfjd9wqK0guQP+waXozU33WI+ACTmbSCJar05
BbPYnr4hK90tXTbY8rB8nQh8tNcdqk3cRXTBDF7BbGCCXfDS90eXPI4Nt1+Li1ny
lX/m0wTreI7t0GCql+K7i0mia206XNAHp3uCQlDQiXibeI7ljo+D5EWhhwR5AIZk
YDINVT2zsNkkCUaKixgAKPoFo4uaicejrnRahY+QYQe2nTtHpP8a+WEKxH34N/F1
A+XDV+UwbcJgE5Kg+teKKVJCmxl1N3mLjrUlQhlt47WJloQajzh9EIIxJDAW9+o0
uvrQQaG+lJ40CKuDLSFp4hpRLX+/Mi38sUTETwBtxOyxA2f63TEVcoIpHzhKNUb1
Td0ANXxayur7m2VABCXiLsyhhlDs/2kLKsFkncsmJnlY3FZCOsjojE2QyJJPxoj8
1aiVEuL/V5YRxHuEju67owKjMfNAGycNZ75CQH1Vs6gi0xY5H/apl62cI6UZYhyq
4lJbVzDnTJwWB4sbtSMygb5NUVnMnT7m48TZrHfLETeEaoMYUdTFWUJpwMygX9Lg
fl9fZp072vtc/4YC2jHdBFPNzD/6x7nh6daHyazFgwgdTphSCfQpeJjeQMrUzT+y
dq3/gR1qMFIsE1M+T1XgH3NEbdkXFl1oBgJ83oPQGrQ8X9SlbhyCOSp7+P0v4s0v
xXAN+HFnMAPQhG9CZTTT
=/abk
-----END PGP SIGNATURE-----

--=-gdVzduy1btVmWwKOx2qE--

