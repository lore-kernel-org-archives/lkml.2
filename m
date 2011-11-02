Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab1KBQN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 12:13:59 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:38444 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932955Ab1KBQN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 12:13:57 -0400
Date: Wed, 2 Nov 2011 09:13:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 2/7] drm/i915: Remove link_status field from
 intel_dp structure
Message-ID: <20111102091348.7f8b956e@jbarnes-desktop>
In-Reply-To: <1320214830-12696-3-git-send-email-keithp@keithp.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com>
	<1320214830-12696-3-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VH41fijFfPFKHgOUwtjuDEQ"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/VH41fijFfPFKHgOUwtjuDEQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue,  1 Nov 2011 23:20:25 -0700
Keith Packard <keithp@keithp.com> wrote:

> No persistent data was ever stored here, so link_status is instead
> allocated on the stack as needed.
>=20
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---

I like this cleanup.

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/VH41fijFfPFKHgOUwtjuDEQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOsWw8AAoJEIEoDkX4Qk9hEOMQAJ26u5Fs/DtTK2BXMvBTHA1x
WTuV/+66h03o/HoXFj8ALQYzj8CmEteZ0Z/85gOyDlDXdr3fwEpHUniAQleYfmrN
GpDnLMw/HqunOkoOZqamaYMWHvl62jJgqBWCYLg+s6N6C7m7vlRF2IN0jHeiMiOA
1wKZkJl1/Bal7ZuDu0B7seERBizPb48M4+fCLar2yHwwgCFXa8TmBuzpsQRqGpXQ
I8Mm5i8jGLSym/QQPWdoBVqdnZ6BFYqwrdTja/rH2g/hafxQdi+AlqFsn88gzkg4
NS/5u7RtZxW95zU/sZxdoh0Cg6RoF9PqSkrZheypW+HO+eOyoNjXk8gZ3r0x+sZs
1yr/ayUh40aKgirHoeC5QDyge+zTYq8QDmdjIeWnc6PoeC2U753sqEb4Iopj2cCj
P6p9oE9C5AAKLEheDyuk8qyoyu1BRaMrkKS7Quyb6TWcA9kaMzW/GdPuLnjgffoh
lwF+ClsLyLx8TBSpwwUKayK4PB0lsFQ6uaj8FE6GEflS8WOmTVWuIbJL/sRunZ3F
HwNg+TLoZUPvnPnSiBS1204o2khpKRpoLS1M+Gy9SC2q+rWhIWbFlKtyVN7ZuNUA
wiHlJXRA8WnigqFOwSlrQehxoaTHz9jGioQvjH6guaCphiHaKFmi7Rmyi73Er2ea
Myg/9M8T5MMVhc4U5srQ
=w+1k
-----END PGP SIGNATURE-----

--Sig_/VH41fijFfPFKHgOUwtjuDEQ--
