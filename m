Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2HMHB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 03:01:27 -0400
Received: from mail.gw90.de ([188.40.100.199]:58910 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab2HMHBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 03:01:25 -0400
Message-ID: <1344841259.4126.4.camel@mattotaupa>
Subject: Re: [PATCH] drm/radeon: Include swiotlb.h if SWIOTLB configured.
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Huacai Chen <chenhuacai@gmail.com>
Cc: David Airlie <airlied@linux.ie>,
        Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Hongliang Tao <taohl@lemote.com>, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhc@lemote.com>, Hua Yan <yanh@lemote.com>
Date: Mon, 13 Aug 2012 09:00:59 +0200
In-Reply-To: <1344823753-28780-1-git-send-email-chenhc@lemote.com>
References: <1344823753-28780-1-git-send-email-chenhc@lemote.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-B8nkIRNeI7JGGg9GZ2WX"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-B8nkIRNeI7JGGg9GZ2WX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Chen,


thanks for your patch.

Firstly, is Chen your first or last name? If it is your first name, your
=46rom address should be switched.

Am Montag, den 13.08.2012, 10:09 +0800 schrieb Huacai Chen:
> When SWIOTLB is configured, if without this patch kernel compilation
> fails.

Secondly, could you please always paste part of the error message into
the commit message so that people hitting this problem and searching for
it on the WWW have a higher chance finding your patch.

Thirdly, do you know why this was not caught beforehand and compilation
worked before?

> Signed-off-by: Huacai Chen <chenhc@lemote.com>

Lastly, the addresses in your From line and Signed-off-by line disagree.
You can easily fix that, by adding

    From: Huacai Chen <chenhc@lemote.com>

to the beginning of your message.

> Signed-off-by: Hongliang Tao <taohl@lemote.com>
> Signed-off-by: Hua Yan <yanh@lemote.com>
> Cc: dri-devel@lists.freedesktop.org
> ---
>  drivers/gpu/drm/radeon/radeon_ttm.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon=
/radeon_ttm.c
> index 5b71c71..fc3ac22 100644
> --- a/drivers/gpu/drm/radeon/radeon_ttm.c
> +++ b/drivers/gpu/drm/radeon/radeon_ttm.c
> @@ -41,6 +41,10 @@
>  #include "radeon_reg.h"
>  #include "radeon.h"
> =20
> +#ifdef CONFIG_SWIOTLB
> +#include <linux/swiotlb.h>
> +#endif
> +
>  #define DRM_FILE_PAGE_OFFSET (0x100000000ULL >> PAGE_SHIFT)
> =20
>  static int radeon_ttm_debugfs_init(struct radeon_device *rdev);

With the clarification above

    Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>

can be added to your patch.


Thanks,

Paul

--=-B8nkIRNeI7JGGg9GZ2WX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlAopisACgkQPX1aK2wOHVinowCeNpCi0RKLCCdCgrKFB/DOLj3e
QkcAmgM3vHRg5EXNhGPMIlFIQIJ1Un0h
=Yn/n
-----END PGP SIGNATURE-----

--=-B8nkIRNeI7JGGg9GZ2WX--

