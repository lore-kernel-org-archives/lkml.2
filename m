Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab2J2DJf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 23:09:35 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:50758 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756417Ab2J2DJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 23:09:34 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL REQUEST] UniCore32 update for v3.7-rc2
Cc: linux-kernel@vger.kernel.org
Message-Id: <20121029030549.EF94F14603E7@linuxdev-32>
Date: Mon, 29 Oct 2012 11:05:49 +0800 (CST)
From: guanxuetao@mprc.pku.edu.cn (guanxuetao)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit e657e078d3dfa9f96976db7a2b5fd7d7c9f1f1a6:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net

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
