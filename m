Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab1K1CmE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 21:42:04 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:37633 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab1K1CmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 21:42:02 -0500
Date: Mon, 28 Nov 2011 13:41:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: build warning after merge of the drm tree
Message-Id: <20111128134156.186426a6dd7d612d488c87b1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Nov_2011_13_41_56_+1100_rKv=.yJNj9_vhq.a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Nov_2011_13_41_56_+1100_rKv=.yJNj9_vhq.a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the drm tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

drivers/gpu/drm/gma500/framebuffer.c: At top level:
drivers/gpu/drm/gma500/framebuffer.c:669:2: warning: initialization from in=
compatible pointer type [enabled by default]
drivers/gpu/drm/gma500/framebuffer.c:669:2: warning: (near initialization f=
or 'psb_mode_funcs.fb_create') [enabled by default]

Caused by commit 4d8d096e9ae8 ("gma500: introduce the framebuffer support
code") interacting with commit 308e5bcbdb10 ("drm: add an fb creation
ioctl that takes a pixel format v5").  Again this should have been fixed
up in commit b63e0f9cb433 ("Merge branch 'drm-gma500-alanc' into
drm-core-next").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Nov_2011_13_41_56_+1100_rKv=.yJNj9_vhq.a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO0vT0AAoJEECxmPOUX5FErIwQAJMOEdum0kCLtONBTl5jB2WE
CsD2fLWKIJhwwfNZc9RY6ccyRK13YxHYo6dA/BwOIumaX8lXkb5clVeUKUsxFft5
RSaWIvUaeyuT7j9XlocIYtyFMfq9e7VPzClIyN7Bs7I8T2K2U3Emip3/iHbRNhe2
9jtqLL0Bw0iS/+Fia0TnE3B39VfV6Z37+kQNyNrZgM+FDmHAS/ikWTkg5tiW4r8n
qcJrurbASScsViGK+1+v26PXTU4N3TvQinf68EmuFEb85pXCTstkS5b9GvseaK4F
wGEBap6o1+oVopDlacoZO/BJO0NtgU2taMU5rsRW5vsm2Y20PcPuVjT4H8UPphVz
T6aiRQnUtfay40mc1gQR/cmKdhZyk/G2719Mx2x9aiw9n0J27fwcyQWAw0J411Ww
7D8h4sUJQmzMVAzBwMNb89j0yCM3XqsnO7VtzPyEvrQ1mQrbmYZRZLR43vFDrI/z
CxA2n1lcs0iBWWqCCmGNFk7tKmDDkfxgAzxkt/J6/RPGF7XBERp2FExXDv/Yki1D
sxbknJbQkAvY4BlqWGTADS/SW6NvoKnyxt6dPzTs7fSlza2jttneJv4MweSSaply
XyrgB0RpHsixY0sk3YwhX+hHUTbb8rP/XwKFmtdXzTl49Sxi+IV64lhXJrwN2/id
2Mxtv79Tv/pjy47wbx5z
=H4xd
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Nov_2011_13_41_56_+1100_rKv=.yJNj9_vhq.a--
