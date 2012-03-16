Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab2CPEWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 00:22:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56584 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab2CPEWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 00:22:33 -0400
Date: Fri, 16 Mar 2012 15:14:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: ppc-dev <linuxppc-dev@lists.ozlabs.org>, gregkh@linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] powerpc: clean up almos all the rest of the iSeries
 platform code
Message-Id: <20120316151459.dab3cdcc2d5984b05e2d2b5c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Mar_2012_15_14_59_+1100_nYywcf0viZ9qCo9Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Mar_2012_15_14_59_+1100_nYywcf0viZ9qCo9Z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

This series removes almost all the remaining code that is part of the
legacy iSeries platform.

 arch/powerpc/boot/Makefile                      |    9 +--
 arch/powerpc/include/asm/abs_addr.h             |   21 +----
 arch/powerpc/include/asm/dma.h                  |    4 -
 arch/powerpc/include/asm/firmware.h             |    9 --
 arch/powerpc/include/asm/iseries/alpaca.h       |   31 ------
 arch/powerpc/include/asm/iseries/hv_call.h      |  111 --------------------
 arch/powerpc/include/asm/iseries/hv_call_sc.h   |   50 ---------
 arch/powerpc/include/asm/iseries/hv_call_xm.h   |   61 -----------
 arch/powerpc/include/asm/iseries/hv_lp_config.h |  128 -------------------=
----
 arch/powerpc/include/asm/iseries/hv_types.h     |  112 --------------------
 arch/powerpc/include/asm/iseries/it_lp_queue.h  |   78 --------------
 arch/powerpc/include/asm/iseries/lpar_map.h     |   85 ---------------
 arch/powerpc/include/asm/iseries/mf.h           |   51 ---------
 arch/powerpc/include/asm/lppaca.h               |    8 --
 arch/powerpc/include/asm/spinlock.h             |    5 +-
 arch/powerpc/include/asm/time.h                 |   15 ---
 arch/powerpc/kernel/asm-offsets.c               |   14 ---
 arch/powerpc/kernel/irq.c                       |   14 ---
 arch/powerpc/kernel/isa-bridge.c                |    3 -
 arch/powerpc/kernel/lparcfg.c                   |  108 ++------------------
 arch/powerpc/kernel/paca.c                      |   12 +--
 arch/powerpc/kernel/pci-common.c                |   15 ---
 arch/powerpc/kernel/sysfs.c                     |    7 +-
 arch/powerpc/kernel/time.c                      |  108 +-------------------
 arch/powerpc/lib/locks.c                        |   24 +----
 arch/powerpc/mm/hash_utils_64.c                 |    9 +-
 arch/powerpc/mm/slb.c                           |    6 -
 arch/powerpc/mm/stab.c                          |    9 --
 arch/powerpc/oprofile/common.c                  |    3 -
 arch/powerpc/platforms/powernv/pci.c            |    1 +
 arch/powerpc/platforms/pseries/lpar.c           |    1 +
 arch/powerpc/xmon/xmon.c                        |   28 -----
 drivers/tty/hvc/hvc_vio.c                       |    4 -
 init/do_mounts_rd.c                             |    4 +-
 34 files changed, 31 insertions(+), 1117 deletions(-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__16_Mar_2012_15_14_59_+1100_nYywcf0viZ9qCo9Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYr5DAAoJEECxmPOUX5FEqE4P/2HP8532neon01D4GGYfov9u
ftk2tUsu3yacgeccjDRafNl+RJvklmisNNVRMzI1eJlPiun/zpuIoCiry5HJPNRG
K5dz4rtSAM+p9W5y49bAVZ1uWj2OOCnxnPoT8U47ESPWEiVb1u5dGnXECq5vevl9
6KCs+o/YOHNBo1EKVTeyVRJaXwCVFzNAaKVR1SlAJ2xA+b7aJLEGjMd7DbOMOJTi
s4zCMFlLtAazPHyJ+rvmGffTPAmQDNAqQ6i0zwaspxNx/mkn6W4hiAH1wvm/LDu8
+Cj5v1apcaO2n0liB5d8SDpvfCfN6c1yuPltmuqVgrhy13w2eZUsHVobWdtZy+KO
pEY5yB+TPWaC7CfHCmu/NcqgYMD9mrmcomufWJW9On9a/WqtoQzKSyHrnR8PTzSr
FuSDmcpO8ZHjtPKk8OmIzpbOV4VXrOX8WMkViIiHMC1qLbn/l8mLQmmpep9nZHK1
r34L78r6Nh07/ySQteI1xDj/hInTpX7+dK6o4pFb7TAHVkmjNzQBdsBfPzg7Femd
kj2lKfxnFoc6ix9N4OfENAv7YaWFZaTcHYoC8GkBONuiuMOaojzpBjx1UlEhdfUF
sDx6XqdblUQCbjF1c7N1m4ZiDDZKgz2KCi9tnthOWMxkMNeT3U8Yst7WxIRAOSDg
3gz4/BUh0pthc+vNrYzE
=f4dB
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Mar_2012_15_14_59_+1100_nYywcf0viZ9qCo9Z--
