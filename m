Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab2LML2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 06:28:16 -0500
Received: from mga03.intel.com ([143.182.124.21]:50015 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab2LML2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 06:28:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,273,1355126400"; 
   d="asc'?scan'208";a="231009559"
Message-ID: <1355398149.3400.47.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] block2mtd: throttle writes by calling
 balance_dirty_pages_ratelimited.
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: NeilBrown <neilb@suse.de>
Cc: Joern Engel <joern@lazybastard.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 13 Dec 2012 13:29:09 +0200
In-Reply-To: <20121212193215.645da577@notabene.brown>
References: <20121212193215.645da577@notabene.brown>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Mq+iaXYt9dXaBFDHb54j"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Mq+iaXYt9dXaBFDHb54j
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-12-12 at 19:32 +1100, NeilBrown wrote:
>=20
> If you create a block2mtd device that is larger than main memory,
> and write to all of it, then lots of pages will be dirtied but
> they will never be flushed out as nothing calls any variant of
> balance_dirty_pages.
>=20
> It would be nice to call set_page_dirty_balance(), but that isn't exporte=
d,
> so just call balance_dirty_pages_ratelimited() directly.
>=20
> Signed-off-by: NeilBrown <neilb@suse.de>

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-Mq+iaXYt9dXaBFDHb54j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQybwFAAoJECmIfjd9wqK0aCgQALfCsMgt3VMDlnEt871opmHk
6Mui4CPbJiLkfQiG5XqcRHZRZ6JCI33kVfCm25MWD+xA4KZ5SMh3Oud+2zK2QSN2
KwyfQH/YY7SgEMleU02Qta33Ev5Z/rBxptCiXWFJ7j/p2qhZGl7i+lY/SoLTE4Sf
UrrtyWBWVWPtwXccyAxt6MVoizAXaXqJ78LlNS7apfbk/izVdKTdXpbcot3Z1iQI
4iU3Qo1aEY6Ezb40Hs3PGVi+KrVOHQocVzDqeZ0ex9Xi4d6wsAQiN9nOq2GZW1tn
cr0oTYbQxVpj36vZyzX+ZIb8nD+ReBnXP8AghbhgDUlfACd3eGrIE/Z4O7Kh0e6c
i6jG8OE9ltaseWZyd/TsNhgP6YoyMomaOhf3mTuRsylgGSh8HqmoKweUXkRnSAa1
RgDc7dUDckZl+nC1JJWXZjCBavt/8yF33d4Jn3lCOyfZFR9LF5x7j7tDve/BnpRv
z3h6fd4J2Gg4n8iqSWcnp7CjY/hpbid8Dy9bPvDpehHRlbQ4xoV0BdattYErJkJ8
NFZqEh8x90FXXxxWnvZAOYZmk4EDjiiXL0V93ezXRpBdO8Jb6aDjhKYU/tTMvmik
QEl3kfjfwvBrlQlqGHdCrYGVl9DDqFvLgs8ztx9ks2BGP0WmLZYqUiq5DQHFOqY9
MiQdXECdVkyanVG5mcAZ
=1kEM
-----END PGP SIGNATURE-----

--=-Mq+iaXYt9dXaBFDHb54j--

