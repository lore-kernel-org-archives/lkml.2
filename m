Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab2JDBy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 21:54:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57638 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab2JDBy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 21:54:28 -0400
Date: Thu, 4 Oct 2012 11:54:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20121004115417.3b9d41eaa94727b6f0e45953@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Oct_2012_11_54_17_+1000_xf3JP+9VGLUy7yJ8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Oct_2012_11_54_17_+1000_xf3JP+9VGLUy7yJ8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/gma500/psb_drv.h between commit 760285e7e7ab ("UAPI:
(Scripted) Convert #include "..." to #include <path/...> in
drivers/gpu/") from Linus' tree and commit 4d46259f00c6 ("drm: gma500:
Kill the GEM glue layer") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/gma500/psb_drv.h
index b15282f,223ff5b..0000000
--- a/drivers/gpu/drm/gma500/psb_drv.h
+++ b/drivers/gpu/drm/gma500/psb_drv.h
@@@ -23,11 -23,11 +23,11 @@@
  #include <linux/kref.h>
 =20
  #include <drm/drmP.h>
 -#include "drm_global.h"
 -#include "gma_drm.h"
 +#include <drm/drm_global.h>
- #include "gem_glue.h"
 +#include <drm/gma_drm.h>
  #include "psb_reg.h"
  #include "psb_intel_drv.h"
+ #include "intel_bios.h"
  #include "gtt.h"
  #include "power.h"
  #include "opregion.h"

--Signature=_Thu__4_Oct_2012_11_54_17_+1000_xf3JP+9VGLUy7yJ8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQbOxJAAoJEECxmPOUX5FE+GMP/0vMNqp4Ic4+6LyEi/OUo3yb
LI8wkROojqbn+m13BWOxhfLXzLyLVNHEHPBm1eAJ60xxhyFO3+6ElR3T2dcndsYg
HWTykIeYz+aLYkd7XmMs5UiCG0y+XtBmXndFXDVCNjCuCpcbbqR3MPoE+qRl8DvG
787IC0Y7PFiCYq8E1v8QLQYCl41dp/gByTySFad64gyKNnsHTbDm4D4fvRxPk4Vo
UcgdjDSfo+z68iMYMB7kzz3YTfX6o6h+/1MDhiuj2X6I/e3jovG749y7a2hN5q/G
HecAAjVynJf3Opo2nQYSqwXqdcaOogZM3FZZMax4DAkp1sh4+0FyrXU+G4sHTk1V
1ywtsM30PhOktjhS2bGUltrROwq/0oHURIiq6EXWu8ScZyl+kP6L0A/GYiDiW1G0
c97FXYyAYLKrdwx4popDUxWv08gCGA/7g8qQJODz7JkuIkeDAe4aCuFdRDExT3FW
MXo8ebFl8xJo/iABDhe+ZNCCfYAisA0ra/stbmHJnA/Vme3/k/i1BoggedsPqfdx
Kmb6nrUiG0MApB4ommuIzunz0FGqaff34y5/dYRwp9hjj9Or0P9GvjpmO7KuhbI0
i4zTiOJba+CtA5fTI0ukA1N5+rKizWiRMwxf0SD1PvGkEQ70qWGqEj63kDbtE9tC
geJJo00AoJpPJH8jWUVc
=8pAt
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Oct_2012_11_54_17_+1000_xf3JP+9VGLUy7yJ8--
