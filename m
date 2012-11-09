Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab2KIJlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 04:41:00 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:42011 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab2KIJk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 04:40:56 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL REQUEST] UniCore32 update for v3.7-rc4
Cc: linux-kernel@vger.kernel.org
Message-Id: <20121109093508.BD26A1460351@linuxdev-32>
Date: Fri,  9 Nov 2012 17:35:08 +0800 (CST)
From: guanxuetao@mprc.pku.edu.cn (guanxuetao)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The following changes since commit 0e4a43ed08e2f44aa7b96aa95d0a540d675483e1:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../steve/gfs2-3.0-fixes

are available in the git repository at:

  git://github.com/gxt/linux.git ..BRANCH.NOT.VERIFIED..

Al Viro (2):
      unicore32: switch to generic kernel_thread()/kernel_execve()
      unicore32: switch to generic sys_execve()

David Howells (1):
      UAPI: (Scripted) Disintegrate arch/unicore32/include/asm

Guan Xuetao (4):
      UniCore32 bugfix: add missed CONFIG_ZONE_DMA
      UniCore32-bugfix: fix mismatch return value of __xchg_bad_pointer
      UniCore32-bugfix: Remove definitions in asm/bug.h to solve difference between native and cross compiler
      unicore32: Use Kbuild infrastructure for kvm_para.h

Kautuk Consul (1):
      unicore32/mm/fault.c: Port OOM changes to do_pf

Kees Cook (1):
      arch/unicore32: remove CONFIG_EXPERIMENTAL

 arch/unicore32/Kconfig                             |    7 ++-
 arch/unicore32/include/asm/Kbuild                  |    1 -
 arch/unicore32/include/asm/bug.h                   |    5 -
 arch/unicore32/include/asm/cmpxchg.h               |    2 +-
 arch/unicore32/include/asm/kvm_para.h              |    1 -
 arch/unicore32/include/asm/processor.h             |    5 -
 arch/unicore32/include/asm/ptrace.h                |   76 +----------------
 arch/unicore32/include/uapi/asm/Kbuild             |    7 ++
 arch/unicore32/include/{ => uapi}/asm/byteorder.h  |    0
 arch/unicore32/include/uapi/asm/ptrace.h           |   90 ++++++++++++++++++++
 arch/unicore32/include/{ => uapi}/asm/sigcontext.h |    0
 arch/unicore32/include/{ => uapi}/asm/unistd.h     |    1 +
 arch/unicore32/kernel/entry.S                      |   20 ++---
 arch/unicore32/kernel/process.c                    |   58 +++----------
 arch/unicore32/kernel/setup.h                      |    6 ++
 arch/unicore32/kernel/sys.c                        |   63 --------------
 arch/unicore32/mm/fault.c                          |   37 ++++++--
 17 files changed, 160 insertions(+), 219 deletions(-)
 delete mode 100644 arch/unicore32/include/asm/kvm_para.h
 rename arch/unicore32/include/{ => uapi}/asm/byteorder.h (100%)
 create mode 100644 arch/unicore32/include/uapi/asm/ptrace.h
 rename arch/unicore32/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/unicore32/include/{ => uapi}/asm/unistd.h (92%)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJQnM5BAAoJENFylnOm3dTb9aoP/in4QBnMN/+lO2JaiMw4aIAI
CkWKfNCg47NHo1D53ZlOH9kCulIrM4bH3uOXwnnGtHDfvlOaX/BdxOKkqEpovv0r
DJXRzQVuGsbTW2A94AQZYDqOUlgHraO4WvAqQeItoEwZqQUptsHHz36ICgLpUGur
CUAtTWeZ14b3xndY4QEUTThUno+cvIu+J6cDOTTXGcOGqfTSkI7EuKSdAVsAPf9K
RaxLGw+k0OekZmcaLNCLH1B+T2GRskNF5UhTLnb8Sa2gcxGwc2sNoPmm0B+Tj6bC
lS2BneX1LWkWEkisl94rZK7T0OirCzr5bXsgSAChVpykf5biN6SBXjQUtV660yGy
yP/vdWDu4ISrqv625v/CKj8Ar476SEkCljKZZ0m2mUWoPBrFAt3N7+KnLUAZXYtd
tsFx/vvWb15Z6PZktLDfcR47ypEd7nf3/FY8h8OvvZg4GJOW+NxIEOHA/ZOXUV+7
yQObEv7+40kB+ZLOBkPy2gDhUIwAsXvaAnj6HB8zFsC9Z3W5tl94vn9RkGiW+6P6
rd3qNgqmHsXBFLsARq2Ct9dP2O6GE3D90EMMq78iP0mE5Ow37KjAmKxWwJSd9KCB
WnDt1rSzsKcmayIMFgVFWJy8dG9rUANaZvIdl/vrqA0tsYcs/3f0lEcwn1/7/maS
qsHCm+R2kL757t/qF2G/
=b4YB
-----END PGP SIGNATURE-----
