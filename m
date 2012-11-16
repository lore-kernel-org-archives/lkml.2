Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148Ab2KPGnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:43:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57404 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2KPGnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:43:41 -0500
Date: Fri, 16 Nov 2012 07:43:31 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mark Zhang <markz@nvidia.com>
Cc: airlied@redhat.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] drm: Add NVIDIA Tegra30 support
Message-ID: <20121116064331.GA21671@avionic-0098.mockup.avionic-design.de>
References: <1353041889-3114-1-git-send-email-markz@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <1353041889-3114-1-git-send-email-markz@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:VYgePnv1if2iFI+ugV9g0ze76kO+tWp8RLA0VE9bPb3
 JOSMTC10ZGcVDq5kX61ZVcmEHQfcy9jctcdZp4et8CI2elFltM
 OMMn+jUZwdEBlCp5hGgX8iZpLV4cEdL0YA86h8lxHxzOVaVvVR
 QdFxfmOWuMQd2S/FheSjijQBoOxUhQkRZSDNGV3jvW9DYGzJp+
 MevyqlzdQVx4TVWYidsbuDHZTjjSZdTlyF+8QsyA9yNz1qX2E/
 ENKYbzmcnWVzR2CxHgXNrUrGmyl+cZ5eMkc5ibf+UL0OYG/I7u
 Xa/6wJvr7V0ljon3Tu1EBQfrWj7Xi/dydAa8IB3Dv6eSGwZxoa
 itVXbY8AG8S19qONE8qyG+6fXzhEzPGl2X7Oysx1FqLXS3qxVw
 /2R4sYEzzhRenol/wDlGFW1LDB1E8ZPT4XWdlef4B1fjq+Xks8
 qZecy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 16, 2012 at 12:58:09PM +0800, Mark Zhang wrote:
> This patch is based on Thierry's drm patch for Tegra20:
> - [PATCH v2 0/6] Device tree updates for host1x support
> - [PATCH v3 0/2] NVIDIA Tegra DRM driver
>=20
> It adds the support for NVIDIA Tegra30.
>=20
> Signed-off-by: Mark Zhang <markz@nvidia.com>

Hi Mark,

I already carry a similar patch in my tegra/next branch and was going to
post that once I get word back that tegra-drm actually works on Tegra30.

You do have the hardware available, right? Did you test this patch on
top of the latest (v3) tegra-drm patches and arch/arm/mach-tegra (v2)
patches I sent a few hours ago?

Thierry

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQpeCTAAoJEN0jrNd/PrOhkBMP/ROXfhJ5jbPERlvV+XC0tdb0
/Bi0TZ/fK5UlYHRv1+tZsKs/mEHOfMHLLx+hqCsmt3eRj5txWmWQE6nIoe/z/R+s
A3ZNygwfM0gnF4uNyCwMd7M9+n/OpUSDIbC9YBNom5BesDq2VxSV28dG2zngUn8M
zeNtA+4/KX/Hg3iZ4KxA75rDRgpL4TqGFOKV0keqynozeMNG7om+8ErmmVGN7jjP
xQOuFr3iXNPliPUn6WY05XKXgmnITEAk6eTAJSctO1FVN3IDmzj9YBbx5bToo1Zo
qJerjaFWvWLb09l3wtdzj72UlleuvVnwdNfQTYgnIDTObDAi9LkZ1Jl55I6i4TWz
yC90+2jlxUHcU0XUHGHoHrXGrgQEB6cKRwCPk6t8FhxbU6O46nsbCs6Q3xH3TmPm
5I+F64TetLEE8o3/g/2yTVezY8TloiYF9DhwDT1YIN0soxb6+lBysU8sJAYlQlGr
UyivgQANFWq0YCAP3izke5/sRW+29EgcqL3+mjceT6VmvyiFO2Hvu9TTKShIwO9V
aUrISWx9DbyAec7gb5IRgqoDABUw0jqjg1udUPT95fE6z99D1ISXFDkf1EyhPLqw
E2N7AXsnJb2K+G80rcGg2Xa9vqkDvibnalFlNgCGv/w1AmM37h5/H32ety16SDh4
/ZkaldN3X4npwo3uTJ6x
=jI5L
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
