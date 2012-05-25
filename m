Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab2EYMU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 08:20:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:22937 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718Ab2EYMUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 08:20:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="147756635"
Message-ID: <1337948678.30969.31.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBIFS: introduce struct ubifs_keymap
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 25 May 2012 15:24:38 +0300
In-Reply-To: <alpine.DEB.2.00.1205250947210.1340@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205211640320.3833@eristoteles.iwoars.net>
	 <1337769818.2483.202.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1205250947210.1340@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-x1s2xCuPahR6RpUBs2/Z"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-x1s2xCuPahR6RpUBs2/Z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-05-25 at 09:49 +0200, Joel Reardon wrote:
> This patch introduces struct ubifs_keymap, the entity responsible for key
> generation, distribution, and lifetime management for ubifs's secure dele=
tion.
> In addition to the struct's (partial) definition, it is added as a field =
to
> ubifs_info. The alloc routines are provided. More fields and functions
> will come in following patches.
>=20
> This is tested using local unit tests for the functions: alloc,
> and checking couple/decouple is sound. UBIFS integck is also run to ensur=
e
> UBIFS is not effected.

Pushed to the "joel" branch with a minor amendment, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-x1s2xCuPahR6RpUBs2/Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPv3oGAAoJECmIfjd9wqK0mX4QAJq1y73HE0QrzTXrRwIPyrF/
HnMs4nxN4UjEZOLt5faLNORahiupauRfyJZPRCFaalUC2/D8kisBM/wW1wroQy69
pgHshqoh1pN1TdDUby6m99MWLYl3BV/CrH1g1kSIVeb8gkSMeDtvKjOV6rj/Qg9q
bOwC5/d99t44sTXhTUtcdOfFqUqBss7ze1V74WmRnqfH5iiEensh5crPJgq15VVG
i/FeaMJxi6i5PxUw8FrnT6AdawGsFXUXa7zP5f7ji9woyH52jYGQOdgrVi2Ur2Ko
VQiDtD98Yd/qOPb/nKlMMLMY42nUDrB2M01MKzcHsd40Yq7X2enpER81QV5bXuKP
oWIug/o260dczJ0DBrLGAJf12T8n3FqcxQoU1VJhh5E67HutCWZLGOXUSWrHWK82
OQ7vMTXaEnMsEfEe5AuMOwxTEdg7lmC/N2/01P3qG9jwer/hbAAr2CvEt3vMWXEs
0x4m5d+E7Tl7rBp8G/Il3pORAN7oLm65WF+RSW4SelX1TNwfI7COQrdJzhxZ1rWb
14+ElsKSvXG6P+/d7k12Q640kyNCm38+Zduwov2eJlbf7HfFrSbXUJulNvN8QvBg
adPQuk/klS15NwplFoiljlBIO+C2nUQQw3Uecb+IYfeT0TKI3BjmRJCfM5jv9v8U
3XvzCZBM/DmgoZq7tPo5
=EMqy
-----END PGP SIGNATURE-----

--=-x1s2xCuPahR6RpUBs2/Z--

