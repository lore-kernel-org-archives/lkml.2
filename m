Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab2KMGpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 01:45:23 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:60196 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab2KMGpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 01:45:22 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL REQUEST] UniCore32 update for v3.7-rc4
Cc: linux-kernel@vger.kernel.org
Message-Id: <20121113063853.E47D114600B1@linuxdev-32>
Date: Tue, 13 Nov 2012 14:38:53 +0800 (CST)
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

  git://github.com/gxt/linux.git unicore32

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

iQIcBAEBAgAGBQJQoeryAAoJENFylnOm3dTb0AUQAL0YxduSqFJHM7mvyTzfhedM
jw0nHoOvA+5N50t4uHmcqoto8R2VY5eTsho7rInKsURilFzwU7SNZBzHQ9cmHX5p
ljO5l5gxMMvTa3SYG0jRBhw1DgeVeHBpuPPfCEproJ5EOIFEFuDUvyUPKNcyEoRV
Ey3QZy4RTfe9DnKwBboqi80pN4Gl6E25VWGz3LnhaFzQXxUyZbm0kycuF1BGWu3F
TUubRs/OMYArNwq4LgZvcFs/7SrsJNSZ4f6wUnobYgJoBhe+Q5W3OS99JNb7PDuY
fxvJQJnbFfYlzk87U1slDTZk+Z7rMJ2sBfguBO13EOtc6DvZeaXMnaiW+HK6CSRW
dSpolVJ7CvCDXP2cFLn3ThMhM8gv0A/XnXnZ7h33zmXNC7HyZq6iMDoq4aqcClko
0LcJwypu1j5c0doQG/mVoiQje7un17pTY9yUNrgR4Ni4v9/Rq6NVy9ksckwEpS7i
g3QhdGtDPDD9zv/YLFId8GX+JbPC2QE2qVaEufj95YAD6AUJVgmqjZiRYKyw+RnY
cdMljswDa4iZC7/dOdOm5hR959Xtc2/XWAG735iWtb99VThgJzanim3pAZi1m+6z
Wp3Heil4IIcCXKdmIsjIeaVINYg00xQto+6+KTFYhtdRn/B6DUNS0+SmstrHVsld
eGUBUqfSFJiBLUIYeFbV
=MPI3
-----END PGP SIGNATURE-----
