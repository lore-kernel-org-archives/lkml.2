Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab2DEPYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:24:48 -0400
Received: from linux-sh.org ([111.68.239.195]:41901 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226Ab2DEPYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 11:24:46 -0400
Date: Fri, 6 Apr 2012 00:24:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 3.4-rc1
Message-ID: <20120405152443.GE23761@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f52b69f86e27903d6896ed5fa7cd280fec8de532:

  Merge tag 'sh-for-linus' of git://github.com/pmundt/linux-sh (2012-03-30 00:09:17 -0700)

are available in the git repository at:

  git://github.com/pmundt/linux-sh.git sh-for-linus

Paul Mundt (6):
      sh: fix up fallout from system.h disintegration.
      sh: dwarf unwinder depends on SHcompact.
      sh: dma: Fix up device attribute mismatch from sysdev fallout.
      sh: vsyscall: Fix up .eh_frame generation.
      serial: sh-sci: use serial_port_in/out vs sci_in/out.
      Merge branches 'sh/urgent', 'sh/vsyscall' and 'common/serial-rework' into sh-latest

Shimoda, Yoshihiro (1):
      sh: fix clock-sh7757 for the latest sh_mobile_sdhi driver

 arch/sh/Kconfig.debug                        |    1 +
 arch/sh/boards/board-sh7785lcr.c             |    1 +
 arch/sh/boards/mach-hp6xx/pm.c               |    1 +
 arch/sh/drivers/dma/dma-sysfs.c              |    2 +-
 arch/sh/kernel/cpu/fpu.c                     |    1 +
 arch/sh/kernel/cpu/sh2a/fpu.c                |    1 +
 arch/sh/kernel/cpu/sh4/fpu.c                 |    1 +
 arch/sh/kernel/cpu/sh4a/clock-sh7757.c       |    2 +-
 arch/sh/kernel/cpu/shmobile/pm.c             |    1 +
 arch/sh/kernel/idle.c                        |    2 +-
 arch/sh/kernel/kgdb.c                        |    1 +
 arch/sh/kernel/process_32.c                  |    1 +
 arch/sh/kernel/smp.c                         |    1 +
 arch/sh/kernel/vsyscall/vsyscall-sigreturn.S |   35 ++++++
 arch/sh/kernel/vsyscall/vsyscall-trapa.S     |   23 ++--
 arch/sh/mm/cache-sh4.c                       |    1 +
 arch/sh/mm/flush-sh4.c                       |    1 +
 arch/sh/mm/sram.c                            |    1 +
 drivers/tty/serial/sh-sci.c                  |  167 +++++++++++++-------------
 drivers/tty/serial/sh-sci.h                  |    8 +-
 20 files changed, 147 insertions(+), 105 deletions(-)
