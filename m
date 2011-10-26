Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab1JZIgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 04:36:50 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:46560 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932450Ab1JZIgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 04:36:49 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Pull request blackfin.git (for-linus branch)
Date: Wed, 26 Oct 2011 04:36:17 -0400
Message-Id: <1319618177-21960-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1319618096-11377-1-git-send-email-vapier@gentoo.org>
References: <1319618096-11377-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7670c7010c7b367ca40c3aba02afb36149764a6e:

  Merge branch 'for-linus' of git://github.com/gregungerer/m68knommu (2011-10-25 16:25:48 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

Lars-Peter Clausen (3):
      Blackfin: bf537-stamp: register adau1701 codec and asoc machine driver
      Blackfin: bf537-stamp: Register adav801 codec and ASoC machine driver
      Blackfin: bf537-stamp: register ASoC EVAL-ADAU1373 board driver

Michael Hennerich (1):
      Blackfin: boards: clean up i2c_board_info

Mike Frysinger (2):
      Blackfin: SMP: convert to common asm-generic/atomic.h
      Blackfin: merge asm/mutex.h into kbuild too

Mikhail Gruzdev (1):
      Blackfin: fix sparse warnings in copy_to/from_user

Paul Bolle (1):
      Blackfin: drop unused Kconfig symbol

Scott Jiang (2):
      Blackfin: bf537-stamp: fix ad1836 name
      Blackfin: bf537-stamp: fix ad73311 codec config macro

Sonic Zhang (2):
      Blackfin: bf548-ezkit: update defconfig
      Blackfin: kgdb_test: rework code to avoid -O0 usage

Steven Miao (1):
      Blackfin: SMP: fix scheduling deadlock

Thomas Gleixner (1):
      Blackfin: H8606: fixup bogus ioresource init

Yong Zhang (1):
      Blackfin: irq: remove IRQF_DISABLED

 arch/blackfin/Kconfig                       |    4 -
 arch/blackfin/configs/BF548-EZKIT_defconfig |   13 +---
 arch/blackfin/include/asm/Kbuild            |    1 +
 arch/blackfin/include/asm/atomic.h          |  104 +++------------------------
 arch/blackfin/include/asm/mutex.h           |    1 -
 arch/blackfin/include/asm/uaccess.h         |    6 +-
 arch/blackfin/kernel/Makefile               |    2 +-
 arch/blackfin/kernel/kgdb_test.c            |    3 +-
 arch/blackfin/kernel/time-ts.c              |    6 +-
 arch/blackfin/kernel/time.c                 |    1 -
 arch/blackfin/mach-bf533/boards/H8606.c     |    3 +-
 arch/blackfin/mach-bf537/boards/cm_bf537e.c |    2 +-
 arch/blackfin/mach-bf537/boards/cm_bf537u.c |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c     |   88 +++++++++++++----------
 arch/blackfin/mach-bf537/boards/tcm_bf537.c |    2 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c  |    2 +-
 arch/blackfin/mach-bf561/smp.c              |    2 +-
 arch/blackfin/mach-common/smp.c             |    7 ++-
 18 files changed, 85 insertions(+), 164 deletions(-)
 delete mode 100644 arch/blackfin/include/asm/mutex.h
