Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab0C2MH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:07:57 -0400
Received: from ozlabs.org ([203.10.76.45]:60393 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab0C2MHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:07:53 -0400
Subject: Re: [PATCH 20/31] lmb: Add __NOT_KEEP_LMB to put lmb code to .init
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
In-Reply-To: <1269830604-26214-21-git-send-email-yinghai@kernel.org>
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
	 <1269830604-26214-21-git-send-email-yinghai@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-98yJ3QODL26BthrgyzG7"
Date: Mon, 29 Mar 2010 23:07:50 +1100
Message-ID: <1269864470.24620.15.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-98yJ3QODL26BthrgyzG7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-03-28 at 19:43 -0700, Yinghai Lu wrote:
> So those lmb bits could released after kernel is booted up.
>=20
> Arch code could define __NOT_KEEP_LMB in asm/lmb.h, __init_lmb will becom=
e __init

ARCH_KEEP_LMB or ARCH_DISCARD_LMB, or something like that, would be more
in keeping with existing flags like this.

cheers


--=-98yJ3QODL26BthrgyzG7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkuwmBUACgkQdSjSd0sB4dJJhQCgruLp9X7aiAD4d0qK37QmBfbb
8UEAoIny6xPe7k0fMRcaObTwrDRsH8gK
=MKvC
-----END PGP SIGNATURE-----

--=-98yJ3QODL26BthrgyzG7--

