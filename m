Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab0F2GPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 02:15:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52479 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab0F2GPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 02:15:53 -0400
Date: Tue, 29 Jun 2010 16:15:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, pgf@laptop.org, x86@kernel.org,
       linux-kernel@vger.kernel.org, Mitch Bradley <wmb@laptop.org>,
       mingo@redhat.com, hpa@zytor.com, sparclinux@vger.kernel.org,
       tglx@linutronix.de, cjb@laptop.org, davem@davemloft.net
Subject: Re: [PATCH 2/4] sparc: break out some prom device-tree building
 code out into drivers/of
Message-Id: <20100629161544.e0af63f0.sfr@canb.auug.org.au>
In-Reply-To: <20100628220037.5744c207@debian>
References: <20100628215407.2017bf2f@debian>
	<20100628220037.5744c207@debian>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__29_Jun_2010_16_15_44_+1000_WUxM38Ip/cO_C_Xo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Jun_2010_16_15_44_+1000_WUxM38Ip/cO_C_Xo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andres,

On Mon, 28 Jun 2010 22:00:37 -0400 Andres Salomon <dilinger@queued.net> wro=
te:
>
> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> index 6f1470b..b4cb63b 100644
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -150,6 +150,7 @@ config ARCH_NO_VIRT_TO_BUS
> =20
>  config OF
>  	def_bool y
> +	select OF_PROMTREE

Please put this select in CONFIG_SPARC instead as we want to move
CONFIG_OF to drivers/og/Kconfig

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__29_Jun_2010_16_15_44_+1000_WUxM38Ip/cO_C_Xo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMKY+QAAoJEDMEi1NhKgbsDJMH/0lTOUhiEzu+od7cSu8EyqVL
+rHJhvo0mqAbEIF0qMuPj2JqsPJ6/O1cAPTBJ5eSDUXtxTZoLlnFzeU0tD8rtmca
DiXT8+9rYS+vlx93yZe306RNjuCIhwWMoDfraAuo6WUErGN+mzfX26vUbXhHmoYN
22p3jjD/DraYNq+l689oC3LFQCy8fSMpPxlULDijk6sMXgEE1+gTa3OAEVty7QvS
j30YyGrqU3x+Q1co1rC+iw5C9Zc48Fy891Amf6DGPssI74xLqIJNw5euE2pdy4EL
keCZrpK/KJZ8ujcyznRyrClcIc7eqbtsiLZYY2/VVC531yPuJg6C99e4U4xrsig=
=+saU
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Jun_2010_16_15_44_+1000_WUxM38Ip/cO_C_Xo--
