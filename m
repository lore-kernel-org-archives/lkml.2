Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855Ab2JVGjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 02:39:03 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:36745 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab2JVGjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 02:39:01 -0400
From: gxt@mprc.pku.edu.cn
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gxt@mprc.pku.edu.cn
Subject: [GIT PULL] unicore32 fixes for v3.7-rc1 
Date: Mon, 22 Oct 2012 14:36:03 +0800
Message-Id: <1350887763-31732-1-git-send-email-gxt@mprc.pku.edu.cn>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

 arch/unicore32/Kconfig                             |    5 +
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
 17 files changed, 159 insertions(+), 218 deletions(-)
 delete mode 100644 arch/unicore32/include/asm/kvm_para.h
 rename arch/unicore32/include/{ => uapi}/asm/byteorder.h (100%)
 create mode 100644 arch/unicore32/include/uapi/asm/ptrace.h
 rename arch/unicore32/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/unicore32/include/{ => uapi}/asm/unistd.h (92%)
