Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab1JNUCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:02:42 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:53731 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab1JNUCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:02:41 -0400
Message-ID: <4E98955C.706@nod.at>
Date: Fri, 14 Oct 2011 22:02:36 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Jeff Dike <jdike@addtoit.com>, user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/21] um: drop unused Kconfig symbol
References: <1318595267.6132.60.camel@x61.thuisdomein>
In-Reply-To: <1318595267.6132.60.camel@x61.thuisdomein>
X-Enigmail-Version: 1.3.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3ED4547A5489FA25501A8BD9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3ED4547A5489FA25501A8BD9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 14.10.2011 14:27, schrieb Paul Bolle:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  arch/um/Kconfig.x86 |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/um/Kconfig.x86 b/arch/um/Kconfig.x86
> index 21bebe6..1d97bd8 100644
> --- a/arch/um/Kconfig.x86
> +++ b/arch/um/Kconfig.x86
> @@ -57,9 +57,6 @@ config ARCH_HAS_SC_SIGNALS
>  config ARCH_REUSE_HOST_VSYSCALL_AREA
>  	def_bool !64BIT
> =20
> -config SMP_BROKEN
> -	def_bool 64BIT
> -
>  config GENERIC_HWEIGHT
>  	def_bool y
> =20

Acked-by: Richard Weinberger <richard@nod.at>


--------------enig3ED4547A5489FA25501A8BD9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQEcBAEBAgAGBQJOmJVcAAoJEN9758yqZn9eUFwH+gLv65mYRHF+fkZyHCVHI72h
f2lFxzywwgF7kB0/REBK4ZTu4kaxrvxFBf8K8pbKcYk0RmbVPkTH+TlwMFmk3eGM
rlYJC7xhEBPjSCIzsREB57kCYbHQMF9OtIPTUVUfdm0CM8rGYHsHeqGLeCWmuRgF
bO/aVcP99Vq7xNQnAQxEtXhiBWNsrmQLLVqq0UfPEEEEoMnscmf3K+d14BHsfmVj
+nlBmZZeE8gBZA73H5Q5jzMLpD6EfVKnAuXYbx7LFUmY7+Ty0nkVcpxP70pit9Gi
WibMN7fAeDP01ZjBOrRvUq6wUH0gz4yw55uiBLR+xJcsnxiUhWhP+R5/j/k4g4o=
=9eXL
-----END PGP SIGNATURE-----

--------------enig3ED4547A5489FA25501A8BD9--
