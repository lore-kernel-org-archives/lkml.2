Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab2KTHiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:38:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55576 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab2KTHiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:38:05 -0500
Date: Tue, 20 Nov 2012 08:37:54 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mark Zhang <markz@nvidia.com>
Cc: airlied@linux.ie, swarren@nvidia.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2] drm: Add NVIDIA Tegra30 support
Message-ID: <20121120073753.GA26616@avionic-0098.adnet.avionic-design.de>
References: <1353396376-24121-1-git-send-email-markz@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <1353396376-24121-1-git-send-email-markz@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:QQrLJLmyibyeetw/GI63oP+VfKkDhR6fWHtuTm0jkgF
 lIuwWG13RvhjDCk/Li0oYWWelU6HT4q0ra+xq0f3T/IQEaLFae
 R2MtVQOG85x0yqyb+JpVlCzoEo65doRRhoMexB9snwjhymUc1l
 48TLKrN4up9qI1aFBfUrhsqgY6266i4L0pSAiv9Iv/Tm1w9tYO
 5smJ9+sbpatC0NoSh1LLWXmYRm+2I5Uz2tMAh114QebFvpmDXJ
 CfJzUZjc9vdhJw33QVh2rwYwb4ZbqJS9BKptTDzR38owcDw5I/
 FZG5vrx4tvF1TxBxcQYpxE44KZaPirozvMKUE7JETmjwkTLu85
 IvVs2yvePGNk91GHZ1H1jngCSM6IFUTv09gLYIf+8qgPXYlFFr
 B/nBgH0L4u59wsZIv1S6yEbGeNjDX7sD0g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 20, 2012 at 03:26:16PM +0800, Mark Zhang wrote:
> This patch is based on Thierry's drm patch for Tegra20:
> - [PATCH v2 0/6] Device tree updates for host1x support
> - [PATCH v3 0/2] NVIDIA Tegra DRM driver
>=20
> It adds the support for NVIDIA Tegra30.
>=20
> Signed-off-by: Mark Zhang <markz@nvidia.com>

Hi Mark,

I already carry an equivalent patch in both my tegra/next and
tegra/drm/for-3.8 branches, thanks.

Thierry

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQqzNRAAoJEN0jrNd/PrOhWI8QAJOqTUmSAVnqWkZd8bp5DHNW
Cztc8pu9GTEGZY6EF5SJM9Oj2x5e03SoF+G2JNKIEvS4P70xsU9sfCNYUkQrmtqH
L4ndO1cU/V4bI1rkbpE3ht/c90L2YBt8N1smSq79ywoGTiifxcLy1ybXKQwLerHB
m1uVFh1oB2cOuFvpjNmy/6KoGMAgjKD6Nyybq5swAXcHO7pdBXbxAMXqlUmLZHWb
a/qBG44u+4+BT8l8FOCxEX7iXG9Un5TzjdA45pXrgEEuMAgAgvXjzycBw0r3al14
7W5vnCQeiRWplESMhRM6h3uRQnJyVlLrZePA9GVon4MJMWzTPUTKHjXPos9gEoVi
OBnK6nJhbWpOlCTo6i3gqAphrzLhui+FkzdYH/cfMxppj+kVT46mBrgGYVO0lmzd
9/CP7FHi50qIGHecPhktsQWff+El0RVWCwU744kq0FYQnOJPuuzxx2xSS1PB0YvB
Y6OBb5levIe7hZe4G91kulvhv5aUfkIosj03wYzIwy3yws8qz2R5mV0RpnJkbsin
33hZ3jqSvlc2eIk9dzzjNSLyXSOaVqfuYFgiy34dzh334OhFvdKS/wiSe/MchCdq
gzMHSp6nB9PZtj7w9bPQyX3QYbmt7Ik6Pz256YwGnV7N8EouKCGltnk8+eZN28Av
B4L8NH+NvMdlsciuaYmp
=phrC
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
