Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab0C2MWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:22:15 -0400
Received: from ozlabs.org ([203.10.76.45]:52897 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab0C2MWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:22:12 -0400
Subject: Re: [PATCH -v9 00/31] use lmb with x86
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iM37uDJ2ZLT+Dapr5Sfp"
Date: Mon, 29 Mar 2010 23:22:11 +1100
Message-ID: <1269865331.24620.44.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iM37uDJ2ZLT+Dapr5Sfp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-03-28 at 19:42 -0700, Yinghai Lu wrote:
> the new lmb could be used to early_res in x86.
>=20
> Suggested by: David, Ben, and Thomas
>=20
> First three patches should go into 2.6.34
>=20
> -v6: change sequence as requested by Thomas
> -v7: seperate them to more patches
> -v8: add boundary checking to make sure not free partial page.
> -v9: use lmb_debug to control print out of reserve_lmb.
>      add e820 clean up, and e820 become __initdata

Bike shedding perhaps, but can you maintain the naming convention, ie.
lmb_xxx() rather than xxx_lmb(). Neither is necessarily better, but all
the existing functions use the lmb_xxx() style.

cheers


--=-iM37uDJ2ZLT+Dapr5Sfp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkuwm3IACgkQdSjSd0sB4dILswCfZeq/ir6De5q4SpsZxHtxfAU6
/KEAn1JAvTLu3EphuIF+lmGzAuQf9Vzv
=AtVv
-----END PGP SIGNATURE-----

--=-iM37uDJ2ZLT+Dapr5Sfp--

