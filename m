Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab2LSX4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:56:07 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:60026 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab2LSXzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:55:55 -0500
X-AuditID: cbfee61b-b7f616d00000319b-b3-50d254091adb
Message-id: <1355961345.16178.120.camel@kjgkr>
Subject: Re: [PATCH -next] f2fs: add missing #include <linux/prefetch.h>
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Dec 2012 08:55:45 +0900
In-reply-to: <1355951970-19720-1-git-send-email-geert@linux-m68k.org>
References: <1355951970-19720-1-git-send-email-geert@linux-m68k.org>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-EE+T3YcemShKFLCeiL6K"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+Zvi5nyKUAg5n/jSz27D3JYnF51xw2
	i4ML2xgdmD0+b5ILYIzisklJzcksSy3St0vgyjj++wdLwQqRijOzelgaGN8IdjFyckgImEjM
	XLqHGcIWk7hwbz1bFyMXh5DAMkaJSa0NLDBFq3sXs0AkpjNKnNn9GarqNaPEv2c32UGqeAX0
	JO4vnMYKYgsLeEhs+fyUsYuRg4NNQFti834DkLCQgKLE2/13WUHCIgK6EnN+MoGEmQViJW5c
	nwh2BIuAqsTqef/BpnAKuEosW/qGFaLVReJl3zuwGn4BUYmTrZ8YIXqrJNac2wX1gJLE7vZO
	qGsEJX5MvscCMVNA4tvkQywgayUEZCU2HWAGuV5C4BG7RNv9D1A/SkocXHGDZQKj+CwkY2ch
	GQUR15Ro3f6bHcLWlli28DUzhG0rsW7de6gaG4lNVxcwQtjyEtvfzmFewMi+ilE0tSC5oDgp
	PddIrzgxt7g0L10vOT93EyMkOqV3MK5qsDjEKMDBqMTDK7niQoAQa2JZcWXuIUYVoDmPNqy+
	wCjFkpefl6okwrvw1sUAId6UxMqq1KL8+KLSnNTiQ4zJQJ9OZJYSTc4HJpS8knhDY2MTMxNT
	E3NLU3NT0oSVxHmbPVIChATSE0tSs1NTC1KLYLYwcXBKNTDmReS/e88a6v+G/9+KzTc23ire
	MGO7NtNm5d3aD91Wd8zW08ibL2x65v7Ea9VMFl7Fir16sn2Pd6fP+pK2cGJceauPYuvPtWtK
	kibqCCbsc46cNu/lJs/cd3EHNq2YwWv/71tB4YuPXD5/F1jNf1F71uK78DSdaUEbKzbd4H4f
	JX3vyrbAykBBJZbijERDLeai4kQAuhy7mB4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsVy+t9jQV3OkEsBBg9f6lrs2XuSxeLyrjls
	FgcXtjE6MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5hx/PcP
	loIVIhVnZvWwNDC+Eexi5OSQEDCRWN27mAXCFpO4cG89WxcjF4eQwHRGiTO7P0M5rxkl/j27
	yQ5SxSugJ3F/4TRWEFtYwENiy+enjF2MHBxsAtoSm/cbgISFBBQl3u6/ywoSFhHQlZjzkwkk
	zCwQK3Hj+kRmEJtFQFVi9bz/YFM4BVwlli19wwrR6iLxsu8dWA2/gKjEydZPjBC9VRJrzu1i
	hrhTSWJ3eyfUNYISPybfY5nAKDgLSdksJCmIuKZE6/bf7BC2tsSyha+ZIWxbiXXr3kPV2Ehs
	urqAEcKWl9j+dg7zAkb2VYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBsf9MegfjqgaLQ4wC
	HIxKPLySKy4ECLEmlhVX5h5iVAGa82jD6guMUix5+XmpSiK8C29dDBDiTUmsrEotyo8vKs1J
	LT7EmAwMjYnMUqLJ+cB0lVcSb2hsYmZkaWRmYWRibk6asJI4b7NHSoCQQHpiSWp2ampBahHM
	FiYOTqkGxuzXE281ayc8ly1K++wnceBgnXnBeak1hzTX3vt3Vmh7ya0drn+SCv66frnofGf6
	vcg8mcC7Nu8XC09tYVpm8fviFtHm6VbC70viym7wcFia6K/e4+IjyaedErypq+uyz8zMV0w/
	jga/m/38+pfij6duR7UZyzpcUWNV+V2XIn15e03bo0iP7UosxRmJhlrMRcWJADwis81NAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EE+T3YcemShKFLCeiL6K
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged.
Thank you very much.

--=20
Jaegeuk Kim
Samsung

2012-12-19 (=EC=88=98), 22:19 +0100, Geert Uytterhoeven:
> m68k allmodconfig:
>=20
> fs/f2fs/data.c: In function =E2=80=98read_end_io=E2=80=99:
> fs/f2fs/data.c:311: error: implicit declaration of function =E2=80=98pref=
etchw=E2=80=99
>=20
> fs/f2fs/segment.c: In function =E2=80=98f2fs_end_io_write=E2=80=99:
> fs/f2fs/segment.c:628: error: implicit declaration of function =E2=80=98p=
refetchw=E2=80=99
>=20
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> http://kisskb.ellerman.id.au/kisskb/buildresult/7787109/
>=20
>  fs/f2fs/data.c    |    1 +
>  fs/f2fs/segment.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 655aeab..3aa5ce7 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -16,6 +16,7 @@
>  #include <linux/backing-dev.h>
>  #include <linux/blkdev.h>
>  #include <linux/bio.h>
> +#include <linux/prefetch.h>
> =20
>  #include "f2fs.h"
>  #include "node.h"
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 8bc1b6f..ca7b5ff 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -12,6 +12,7 @@
>  #include <linux/f2fs_fs.h>
>  #include <linux/bio.h>
>  #include <linux/blkdev.h>
> +#include <linux/prefetch.h>
>  #include <linux/vmalloc.h>
> =20
>  #include "f2fs.h"



--=-EE+T3YcemShKFLCeiL6K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQ0lQBAAoJEEAUqH6CSFDSth4P/2Rvhp/bAk81JedEAAsqplxa
YSSyjY5gjgZ2Du4aqU8vxtBxEr8z9e/pLqzyHbtg+PgJrSroFtcnATi5iryLhlOk
XLKE599zd38heawUo2+xxvxQE9gjxgcdYyuTYX15M/TicG6DuxFpIW2Yfvjm6McV
GDsaiDrnQCdQLSrJy2FbJlgBZz33Rv8zfE6yb5V81ByThel1diqYWR5QQoynIna9
V2aPVlY4NOQWkXZqr27mCdZiHz+WahJYWYKCJU6tNTU1u687h6t+4tCjzigidv8J
IOCLgeNsto0LUCf0oF33jnEtyK2xvmoQnsC17yDoO3ro3/T5IyEQUL95oYk8M7l+
iirUaDuKSm4okEKF5Nj8qXqRgbYhS66e3xHJgiKdojlEAiv6EK70VdZR9Eh/kLIi
LUtPmrX4PNU/XyyyDkktP4kTLfqz5IMG/W36XIHXx/rzfzH4qAFfB85Og240r3NU
br+b0s6os2IBg7DtsIiPArpVGq+8bGLd1hH1kSKlbe1P7VvfwqQx8jpqtcY06K9O
+L+ZBA2Be+vxCwiXhb9w65V+6uvlBpER6gXYJY809bctvYIPymzA5U9OkH0uzkvZ
eJfTisxuGjSriayw8KfpS6QejjjvNol9mOwm2aKuDowkA0xDfxl/j/2e9Dou4Q8o
NxU93Z9cRq+OqQ2KagGy
=GSI0
-----END PGP SIGNATURE-----

--=-EE+T3YcemShKFLCeiL6K--

