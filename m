Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab0C3ENJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 00:13:09 -0400
Received: from ozlabs.org ([203.10.76.45]:44830 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab0C3ENH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 00:13:07 -0400
Subject: Re: [PATCH 07/31] lmb: Add reserve_lmb/free_lmb
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BB13D61.3040902@kernel.org>
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
	 <1269830604-26214-8-git-send-email-yinghai@kernel.org>
	 <1269865322.24620.42.camel@concordia>  <4BB0D92C.3010103@kernel.org>
	 <1269901252.2286.11.camel@concordia>  <4BB12BBA.4060108@kernel.org>
	 <1269905664.7101.43.camel@pasglop>  <4BB13D61.3040902@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EFkoRkgWekuvA7KH+Eho"
Date: Tue, 30 Mar 2010 15:13:03 +1100
Message-ID: <1269922383.15854.68.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EFkoRkgWekuvA7KH+Eho
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-03-29 at 16:53 -0700, Yinghai Lu wrote:
> On 03/29/2010 04:34 PM, Benjamin Herrenschmidt wrote:
> > On Mon, 2010-03-29 at 15:37 -0700, Yinghai Lu wrote:
> >>> We just need a lmb.alloc_limit and a lmb_set_alloc_limit() which arch
> >>> code calls when it knows what the alloc limit is (and can call multip=
le
> >>> times during boot). Or maybe it should be called "default_alloc_limit=
",
> >>> but that's getting a bit long winded.
> >>
> >> ok, I will get_max_mapped() for now, an will change to new field...lat=
er
> >=20
> > No. Do it now. get_max_mapped() sucks as an identifier.
> >=20
>=20
> ok, can i reuse rmo_size, or introduce one new member in struct lmb.
>=20
> default_limit?

alloc_limit or default_alloc_limit

cheers

--=-EFkoRkgWekuvA7KH+Eho
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkuxek8ACgkQdSjSd0sB4dJNkgCfTeCeEEWj8HyGyvN2YJ7K75cx
LJoAn1RaPm+W3eDqR0M0LK+B/g4aACao
=jvEL
-----END PGP SIGNATURE-----

--=-EFkoRkgWekuvA7KH+Eho--

