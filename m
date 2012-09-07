Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120Ab2IGHA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:00:26 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:24291 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350Ab2IGHAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 03:00:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmkEAN+aSVBbdWObgWdsb2JhbABFhUBHrR0iiAwiAQEWJieCIAEBBSNWEAsYKgICVwYTiBSobJMokDCBEgOoWw
X-IronPort-AV: E=Sophos;i="4.80,384,1344204000"; 
   d="asc'?scan'208";a="1039836813"
Message-ID: <1347001292.5957.43.camel@fourier.local.igalia.com>
Subject: Re: [PATCH] staging: ipack: only build on platforms that provide
 ioread/iowrite.
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Jens Taprogge <jens.taprogge@taprogge.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        industrypack-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 07 Sep 2012 09:01:32 +0200
In-Reply-To: <1346960719-9184-2-git-send-email-jens.taprogge@taprogge.org>
References: <CAMuHMdWN--hXYTPYNi07vNB0DrMdDoc+MwxgUkSBihPw+VKGHg@mail.gmail.com>
	 <1346960719-9184-1-git-send-email-jens.taprogge@taprogge.org>
	 <1346960719-9184-2-git-send-email-jens.taprogge@taprogge.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-vkEIv9jKvBZ45LcOlhlg"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vkEIv9jKvBZ45LcOlhlg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-09-06 at 21:45 +0200, Jens Taprogge wrote:
> Do so by depending on HAS_IOMEM.
>=20
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>=20
> Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
> ---
>  drivers/staging/ipack/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/staging/ipack/Kconfig b/drivers/staging/ipack/Kconfi=
g
> index af32178..4cf4706 100644
> --- a/drivers/staging/ipack/Kconfig
> +++ b/drivers/staging/ipack/Kconfig
> @@ -4,6 +4,7 @@
> =20
>  menuconfig IPACK_BUS
>  	tristate "IndustryPack bus support"
> +	depends on HAS_IOMEM
>  	---help---
>  	  If you say Y here you get support for the IndustryPack Framework
>  	  for drivers for many types of boards that support this industrial

Acked-by: Samuel Iglesias Gons=C3=A1lvez <siglesias@igalia.com>

Thanks,

Sam

--=-vkEIv9jKvBZ45LcOlhlg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlBJm8wACgkQWrfbyfmd9eJ6GwCfZOLdUytNutk8hUmUOglq3t40
QdYAn0ATyyZGMMt19NZupjUE+ClyYcRS
=t4a0
-----END PGP SIGNATURE-----

--=-vkEIv9jKvBZ45LcOlhlg--

