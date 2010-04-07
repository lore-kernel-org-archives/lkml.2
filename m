Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0DGXi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:38:57 -0400
Received: from ozlabs.org ([203.10.76.45]:36375 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab0DGXiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:38:54 -0400
Subject: Re: [PATCH 25/33] x86, lmb: turn off ARCH_LMB_FIND_AREA
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
In-Reply-To: <1270001838-15857-26-git-send-email-yinghai@kernel.org>
References: <1270001838-15857-1-git-send-email-yinghai@kernel.org>
	 <1270001838-15857-26-git-send-email-yinghai@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AlxfS/9Mf3GHYNQzW6aA"
Date: Thu, 08 Apr 2010 09:38:54 +1000
Message-ID: <1270683534.9521.8.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AlxfS/9Mf3GHYNQzW6aA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-03-30 at 19:17 -0700, Yinghai Lu wrote:
> 32bit now can use generic __find_lmb_area now. So we can turn arch one of=
f
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 1aa53ae..ce097ab 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -584,7 +584,7 @@ config PARAVIRT_DEBUG
>  	  a paravirt_op is missing when it is called.
> =20
>  config ARCH_LMB_FIND_AREA
> -	default y
> +	default n
>  	bool "Use x86 own lmb_find_area()"
>  	---help---
>  	  Use lmb_find_area() version instead of generic version, it get free

So can't the whole ARCH_LMB_FIND_AREA go away then? And the generic
version be made non-weak?

cheers

--=-AlxfS/9Mf3GHYNQzW6aA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAku9F40ACgkQdSjSd0sB4dLx9QCffSHt6ykVGNNv9fb2mrEK3tem
iK4AniKZReqDO6hWD2yFKQQvyOluWJAv
=lKXd
-----END PGP SIGNATURE-----

--=-AlxfS/9Mf3GHYNQzW6aA--

