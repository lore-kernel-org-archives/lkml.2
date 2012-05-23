Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417Ab2EWKmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:42:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:8332 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933306Ab2EWKmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:42:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="170278573"
Message-ID: <1337769978.2483.204.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBIFS: introduce struct ubifs_keymap
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 23 May 2012 13:46:18 +0300
In-Reply-To: <alpine.DEB.2.00.1205211640320.3833@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205211640320.3833@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-/G3G2d1OPU4lxk7lxlxd"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/G3G2d1OPU4lxk7lxlxd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-05-21 at 16:41 +0200, Joel Reardon wrote:
> +static void generate_key(struct ubifs_keymap *km, u8 *to)
> +{
> +       get_random_bytes(to, km->key_size);
> +}

If this function is not going to grow soon, just open-code
'get_random_bytes()' instead. Try to not introduce wrappers like this -
we do not appreciate it usually, we prefer open-coding things unless
there is a good reason to have a wrapper function.

--=20
Best Regards,
Artem Bityutskiy

--=-/G3G2d1OPU4lxk7lxlxd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPvL/6AAoJECmIfjd9wqK0R3oQAJLN+3eJKoyhedcexw0TFUcT
sLh0dyZWEnVAYApfgx6trqOUK3dmrpg9Hy1UQhFUB4jcU25W2Jn97GcCrvVl6rDw
L/tEU7jkuylcCMSw4u4qvNFcm1R7BG7MMP95TkC3gHu7T9//zkUkaI5SjuDUiixf
u7N9t3vkOOzd+MNIgwQgFlpBlC4Pd48o6Okhe6VwxbOodwk1JX9GzBt6W5d5XQQ8
/XEl3Nbhn08Zs1Jd+xppbwcJbzt+EIajDqZtrP2eWDsWiuWDjM7EmfuUGJyYr9yd
ryhpqJyEE/9iPUz0VRKDHeKvLddYl6uS5UsBk+LrPczVmuGzgpitfG6glZMkEBxr
wSLMF00NN/uDpM4JLLKOFfUyFBW6rzcuoOGTVO+vtiM10VlBCcx4vgo2yCjIBeeV
U1lzODHQ2hTwVcg/6pmzvT1wqarpPTqzb2Zz+cp6rSEc2jzWD15s9AbYvPYbjwSh
/30JdgWaSrDHoflvLDbRhH+eQGGFilG7hKg1lhD2pxwu8VxuzvMj6FdII8x9IdOl
uZDvzetfdmWBrXM9XYWPyQXyvkify2d9Stw3Wfizyv0Myc6EVTETd3L8G9SeahGl
SwfhLbUf0ufxMr/BA74OsmkoGRqEbkBRtMYd0N7mqvkVoc7qBBUbsv0qPOiLojk4
epWjAe8CbIcUq/uiDde7
=R80t
-----END PGP SIGNATURE-----

--=-/G3G2d1OPU4lxk7lxlxd--

