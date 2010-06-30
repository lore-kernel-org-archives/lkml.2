Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab0F3Q0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:26:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55486 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab0F3Q0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:26:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=YQtExYcGewQz+vGGgCXQoyL+jqhzYycCcUW3O1S+9/whUcVclr/Slzhza3yPMrtY46
         WRTr1WPrSVrBJ0tT1qCJFMThT/TZV3jFuTAtniWzDXiQ0X3MrGGzJ6RX7WEMf/9soUsu
         uWQ6Nv/maMy8PzXmnSivwdwgLcXBPoMJ/EpDU=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Christoph Egger <siccegge@cs.fau.de>
Subject: Re: [PATCH 28/33] Removing dead CPU_S3C24XX
Date: Wed, 30 Jun 2010 19:19:45 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.34-gentoo-anarsoul; KDE/4.4.4; i686; ; )
Cc: Vincent Sanders <support@simtec.co.uk>, Ben Dooks <ben-linux@fluff.org>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
References: <cover.1277911345.git.siccegge@cs.fau.de> <787416813d524b042dc933fbcfbbae22fd5ca2ca.1277911346.git.siccegge@cs.fau.de>
In-Reply-To: <787416813d524b042dc933fbcfbbae22fd5ca2ca.1277911346.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6491874.X05KAL5gmn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201006301919.51697.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6491874.X05KAL5gmn
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

=D0=92 =D1=81=D0=BE=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D0=B8 =D0=BE=D1=82 =
30 =D0=B8=D1=8E=D0=BD=D1=8F 2010 19:02:51 =D0=B0=D0=B2=D1=82=D0=BE=D1=80 Ch=
ristoph Egger =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
> CPU_S3C24XX doesn't exist in Kconfig, therefore removing all
> references for it from the source code.
>=20
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> ---
>  arch/arm/mach-s3c2410/include/mach/gpio.h |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/arm/mach-s3c2410/include/mach/gpio.h
> b/arch/arm/mach-s3c2410/include/mach/gpio.h index b649bf2..a37d274 100644
> --- a/arch/arm/mach-s3c2410/include/mach/gpio.h
> +++ b/arch/arm/mach-s3c2410/include/mach/gpio.h
> @@ -30,8 +30,4 @@
>  #include <mach/gpio-nrs.h>
>  #include <mach/gpio-fns.h>
>=20
> -#ifdef CONFIG_CPU_S3C24XX
> -#define S3C_GPIO_END	(S3C2410_GPIO_BANKJ + 32)
> -#else
>  #define S3C_GPIO_END	(S3C2410_GPIO_BANKH + 32)
> -#endif

This patch conflicts with Yaugen Kharuzhy patch (ARM: S3C24XX: Fix gpiolib=
=20
support for ports K..M), S3C24XX is just a typo, it should be S3C244X and t=
hat=20
was fixed by mentioned patch

Regards
Vasily

--nextPart6491874.X05KAL5gmn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkwrbqcACgkQRM6pQpltKE5D+wCfewbwYKOYtBvfqRbYaNW6LDqO
XzMAoNF5kVwcEv5PjRsFq/ewBsnQr6Du
=ex7n
-----END PGP SIGNATURE-----

--nextPart6491874.X05KAL5gmn--
