Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680Ab0JZCuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:50:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49795 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757219Ab0JZCuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:50:07 -0400
Date: Tue, 26 Oct 2010 13:49:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warnings after merge of the final tree (mtd tree
 related)
Message-Id: <20101026134959.86b807d1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__26_Oct_2010_13_49_59_+1100_.BL933etPaTlW+kd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Oct_2010_13_49_59_+1100_.BL933etPaTlW+kd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

After merging the final tree, today's linux-next build (powerpc
ppc44x_defconfig) produced these warnings:

In file included from drivers/mtd/mtdchar.c:36:
include/linux/mtd/map.h:145:2: warning: #warning "No CONFIG_MTD_MAP_BANK_WI=
DTH_xx selected. No NOR chip support can work"
In file included from drivers/mtd/chips/chipreg.c:11:
include/linux/mtd/map.h:145:2: warning: #warning "No CONFIG_MTD_MAP_BANK_WI=
DTH_xx selected. No NOR chip support can work"
In file included from drivers/mtd/chips/cfi_probe.c:17:
include/linux/mtd/map.h:145:2: warning: #warning "No CONFIG_MTD_MAP_BANK_WI=
DTH_xx selected. No NOR chip support can work"
In file included from drivers/mtd/chips/cfi_probe.c:18:
include/linux/mtd/cfi.h:75:2: warning: #warning No CONFIG_MTD_CFI_Ix select=
ed. No NOR chip support can work.
In file included from drivers/mtd/maps/physmap_of.c:21:
include/linux/mtd/map.h:145:2: warning: #warning "No CONFIG_MTD_MAP_BANK_WI=
DTH_xx selected. No NOR chip support can work"
In file included from drivers/mtd/chips/cfi_cmdset_0002.c:36:
include/linux/mtd/map.h:145:2: warning: #warning "No CONFIG_MTD_MAP_BANK_WI=
DTH_xx selected. No NOR chip support can work"
In file included from drivers/mtd/chips/cfi_cmdset_0002.c:38:
include/linux/mtd/cfi.h:75:2: warning: #warning No CONFIG_MTD_CFI_Ix select=
ed. No NOR chip support can work.
In file included from drivers/mtd/chips/cfi_util.c:23:
include/linux/mtd/map.h:145:2: warning: #warning "No CONFIG_MTD_MAP_BANK_WI=
DTH_xx selected. No NOR chip support can work"
In file included from drivers/mtd/chips/cfi_util.c:24:
include/linux/mtd/cfi.h:75:2: warning: #warning No CONFIG_MTD_CFI_Ix select=
ed. No NOR chip support can work.
In file included from drivers/mtd/chips/gen_probe.c:11:
include/linux/mtd/map.h:145:2: warning: #warning "No CONFIG_MTD_MAP_BANK_WI=
DTH_xx selected. No NOR chip support can work"
In file included from drivers/mtd/chips/gen_probe.c:12:
include/linux/mtd/cfi.h:75:2: warning: #warning No CONFIG_MTD_CFI_Ix select=
ed. No NOR chip support can work.
In file included from drivers/mtd/chips/jedec_probe.c:21:
include/linux/mtd/map.h:145:2: warning: #warning "No CONFIG_MTD_MAP_BANK_WI=
DTH_xx selected. No NOR chip support can work"
In file included from drivers/mtd/chips/jedec_probe.c:22:
include/linux/mtd/cfi.h:75:2: warning: #warning No CONFIG_MTD_CFI_Ix select=
ed. No NOR chip support can work.

I am not sure where these came from ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__26_Oct_2010_13_49_59_+1100_.BL933etPaTlW+kd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMxkHXAAoJEDMEi1NhKgbsOhQH/0JdXua643m66LXE3BhAIk7p
1Ddgbrx4/ZGUnfdGhQZfL7i2O7F48jeyy5JZd4orgrZqUpKXA0IAE4abUd8+O2nb
XuiwWwv4nVOepiiC60kkMpd+Ittl8klGMgjQxPuwKFg3i+jX7iAYb23vH81QDvTK
Xve4ff02qohjgmOn1g3tel4gi3xJvWPmbG/XSaxn1dFbYvL57B+o+m+x65lYkSCP
Aq8ljfZ9zaYubU2+uvPNEE/wIcegZukZFJeZm4Dq/9XNQg/0vi5k24Wje0k5uvTL
rJtFs0yzEqpNXPT4f7+rMetktSHQy8eDXkw4LqIC3FU+fkeTE4usf0/21N+rUU4=
=M/SV
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Oct_2010_13_49_59_+1100_.BL933etPaTlW+kd--
