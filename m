Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab2GLFvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 01:51:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54312 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab2GLFvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 01:51:31 -0400
Date: Thu, 12 Jul 2012 15:51:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Glauber Costa <glommer@parallels.com>
Subject: linux-next: build warning after merge of the slab tree
Message-Id: <20120712155120.6382db5535bf8d099793b351@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__12_Jul_2012_15_51_20_+1000_CE7QGP4Xh3uXthPO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Jul_2012_15_51_20_+1000_CE7QGP4Xh3uXthPO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the slab tree, today's linux-next build (i386_defconfig)
produced this warning:

mm/slab_common.c: In function 'kmem_cache_create':
mm/slab_common.c:101:1: warning: label 'oops' defined but not used [-Wunuse=
d-label]

Introduced by commit 20cea9683ecc ("mm, sl[aou]b: Move kmem_cache_create
mutex handling to common code") from the slab tree.  The label is only
used when CONFIG_DEBUG_VM is defined.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__12_Jul_2012_15_51_20_+1000_CE7QGP4Xh3uXthPO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP/mXYAAoJEECxmPOUX5FE7RYQAIJqCjx7UZ3eCsl8sJoQ7chM
hwLkRzF1bvy5kksrVZBKJhzYCqrgveHLHEcQqrZqY8m0cISRWQrSjWgxLtM4yAmq
aVEpCh15NaLvE0Ao5RYHVcGK6/Ceo9NP5ziHPvZW5iE+i434hgd4mkBGvf+FD6T/
QmNFEI/6zcSJkf0x1OttE6ZVohy5UCHgv4WLB5KXf4BAjweYf76WFHYGfFYBkvXQ
GlUVIUwGAbgUW+fDzaNUQVHD1wBEpf3z6Whvw81DhU9YgLquaFTYYnYSM0P9rJlA
MF/qaPCLQtj5TINq7fO3poUVPtZ8HTRtPAGGJtB6tvoExdCG8JbgL9/0OCNvOAW7
rInONSNrxw6GQiD/SMnXPDUOhUa97cowqW8/wCeXaPqWYfsV/H9vrC08+a8BPMgZ
KihuYF9ujoyB1HS2Mr90bltFLvJs1D0j+9mAnakR3vIfoj81IZOzy1MHqdtER4o4
o1AUyXf3gxN3weXWpKCTspLyPkoRCH4dEo1D85a5yGiW8zYY3yG3qPXBSfk+XXsO
5IjnoXNuz9p2U7AyvK82JkA1/l5A3f1ruomgyYFTDiNoJ9+54gkv7qyRMXjHG504
XjJ6J+5OgH532r7OIfYGW2P55rTd39G99/LLDsvApiPgb/jc7Gx0HeleKNYDVrgg
bhfrfFvglanPmtEyk4Dy
=TlCa
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Jul_2012_15_51_20_+1000_CE7QGP4Xh3uXthPO--
