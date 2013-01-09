Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab3AIIJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:09:09 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:37899 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338Ab3AIIJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:09:07 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Benoit Goby <benoit@android.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benoit Goby <benoit@android.com>
Subject: Re: [PATCH] usb: gadget: FunctionFS: Fix missing braces in parse_opts
In-Reply-To: <1357703829-26621-1-git-send-email-benoit@android.com>
Organization: http://mina86.com/
References: <1357703829-26621-1-git-send-email-benoit@android.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Wed, 09 Jan 2013 09:08:56 +0100
Message-ID: <xa1tr4lu93s7.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 09 2013, Benoit Goby <benoit@android.com> wrote:
> Add missing braces around an if block in ffs_fs_parse_opts. This broke
> parsing the uid/gid mount options and causes mount to fail when using
> uid/gid. This has been introduced by commit b9b73f7c (userns: Convert usb
> functionfs to use kuid/kgid where appropriate) in 3.7.
>
> Signed-off-by: Benoit Goby <benoit@android.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: stable@kernel.org

> ---
>  drivers/usb/gadget/f_fs.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index 4a6961c..8c2f251 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -1153,15 +1153,15 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_d=
ata *data, char *opts)
>  					pr_err("%s: unmapped value: %lu\n", opts, value);
>  					return -EINVAL;
>  				}
> -			}
> -			else if (!memcmp(opts, "gid", 3))
> +			} else if (!memcmp(opts, "gid", 3)) {
>  				data->perms.gid =3D make_kgid(current_user_ns(), value);
>  				if (!gid_valid(data->perms.gid)) {
>  					pr_err("%s: unmapped value: %lu\n", opts, value);
>  					return -EINVAL;
>  				}
> -			else
> +			} else {
>  				goto invalid;
> +			}
>  			break;
>=20=20
>  		default:

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

iQIcBAEBAgAGBQJQ7SWYAAoJECBgQBJQdR/0kksQAIixDVTJ9Z5yb0u8cBNUcI3S
3FTfHMWCADfz0nWWkDjI2MhZZytYbMWH15yGtNb46DPOyTkYnQH7AL4kX6Z7KKa6
jtJCwNaQ968AUQf5kyYpHxovaHiG78gWOQDjpWjCFpTqnRzVBIzfaB8M9cI4BRjo
6N3cZ5pPXUyTj5TO4QH9rTLQxT0Yz7/x7RpXfNzaGYJEvaQ+gBCKr3L2eHvn8BO/
RGnhEn5B5om3IJo5Q1xcqKkX7XSPy7kYGb/aGHQokTdfMCGNQ8qbh8l1lomSxGCw
pQ4wYhMiZH9T53HX6ccpp2Y3v9Ee6UnvzPsa4xeTGGBE69H1RgwMY8h1zxa5cJpn
lLUGBZAefOcRXSK0izXXVWr3w0voq/vCoHQiCn+4rkcDAcZvN5XxmB7d9vRJ+IA6
u8FvNPIQRFmTPu9KpkaPD1hucL583u7kcJoXvpEVV6hpwwn11acgU45GpgBBmdAN
2l6Cdfkt1ioonO5HO4lNWwjxes4QvyILw54mXjT3R+2s0gSHfGhz9j1mleynM0k8
CDsKqZJy902BwsbPx0YTpo08478xlZdaiQNH/nE1pnf+oT9DqQBt1K1cYv92pC+3
i/W1OVJlAc0ECA2WPdbv2wHHdt1fvoC+sDq+KEVGC56EdnTkiR6jU5xkWigQjuRs
hIUcDXTRZ6WTfs/k4PZn
=/75N
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
