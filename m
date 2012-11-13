Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab2KMOrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 09:47:17 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34086 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab2KMOrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 09:47:15 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Remove unused variable in alloc_contig_range()
In-Reply-To: <1352709906-10749-1-git-send-email-thierry.reding@avionic-design.de>
Organization: http://mina86.com/
References: <1352709906-10749-1-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Tue, 13 Nov 2012 15:47:06 +0100
Message-ID: <xa1tr4nxv9ud.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 12 2012, Thierry Reding wrote:
> Commit 872ca38f7afd9566bf2f88b95616f7ab71b50064 removed the last
> reference to this variable but not the variable itself.
>
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

I could have sworn that someone (Marek?) sent that patch already.

> ---
>  mm/page_alloc.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 6b990cb..71933dd 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5822,7 +5822,6 @@ static int __alloc_contig_migrate_range(struct comp=
act_control *cc,
>  int alloc_contig_range(unsigned long start, unsigned long end,
>  		       unsigned migratetype)
>  {
> -	struct zone *zone =3D page_zone(pfn_to_page(start));
>  	unsigned long outer_start, outer_end;
>  	int ret =3D 0, order;

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQol1rAAoJECBgQBJQdR/05toP/iNhRiJJejr3V6cY2HOFsP7L
8mQNkqyXEYqiMaXC5/YNXP+myuIIO1czk7NzbuFXuDOVLtvvTQQ4t6NsO7bpa0yl
6QdZGm1X3kj57HhDDj4NVhlnbWAArwAwoePOupifFnEQ80W81Y7k+ly78W5lYIXW
ZeSlrjJ6Gsz+8DkQaHs9tvaA9cAzXfuiYWmBDSOIG6gjxbOcTnZY3CqDqLLqEple
jUT7U4lac6PAWFgxe0t7+LvblqadgaUjtqaNWATPtfzzs/QwhCNET6AMZSna/e+t
Kw0iDbMHFQshAqEAamXaqbnKqoP/F6Lz7IQDuJP/bYIga5mUEs1yFVoBG6Z1FgH6
bd/Zwpef/hXJQKLD1eLmQxboJC7N5+EpcrUg1P6UyzvW71qydkb965Mx85PVjvxO
U69U01QCLVaAH0PEC2CJjhjNhe3A68Q/5i6JkQYUGcGb6AbgRM32vySBaTdH5I+T
TdHl+XhbvsKfsor6Q8p2NrJyAELx3CNP4TpemNiJWX9TFPtlGKr9/kOdQcAqagBa
wRDd08qfbj/TlFCnhgYKdahWEEoH/HKqrzVQdYCvbQPdF2SS8z4zljE98D2YzGWT
CFkJwSDA3+ysgwkZwhm0x25eZMk2cz4//C12JlEzKFSjAOcCcpNyRBFECWWm7h6P
dio4/cBM3wQxgtgpG8eS
=+o4b
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
