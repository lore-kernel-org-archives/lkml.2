Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab1CPI6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 04:58:15 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42337 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab1CPI6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 04:58:09 -0400
Message-ID: <4D807B9D.10100@monstr.eu>
Date: Wed, 16 Mar 2011 09:58:05 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze changes for 2.6.39
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes.

Thanks,
Michal

The following changes since commit a5abba989deceb731047425812d268daf7536575:
   Linus Torvalds (1):
         Linux 2.6.38-rc8

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git next

Michal Simek (28):
       microblaze: Do not use r0_ram space for hw exception debugging
       microblaze: Fix unaligned.h for endians
       microblaze: Optimize BE/LE bootup detecting
       microblaze: Do not use r0_ram space for syscall debugging
       microblaze: Remove r0_ram pointer and PTO alignment
       microblaze: Do not use "la" pseudo instruction - use addik instead
       microblaze: Fix GDB issue caused by cache issue
       microblaze: Label MB 7.20.d as broken with WB cache
       microblaze: Add PVR for Microblaze v8.10.a
       microblaze: Fix coding style - ptrace.h
       microblaze: trivial: Add one empty line
       microblaze: Add support for DMA_BIDIRECTIONAL
       microblaze: Fix sparse warning - prom.c
       microblaze: Fix sparse warning - timer.c
       microblaze: Fix sparse warning - sw_exceptions
       microblaze: Fix sparse warnings - ptrace
       microblaze: Fix sparse warning - consistent_alloc function
       microblaze: Fix sparse warning - unwind.c
       microblaze: Fix sparse warning - cpuinfo.h
       microblaze: Fix sparse warnings - cache.c
       microblaze: Fix missing microblaze specific syscalls declaration
       microblaze: Fix sparse warning - fault.c
       microblaze: Fix sparse warnings - signal.c
       microblaze: Add missing export symbols for lib functions
       microblaze: Fix circular headers dependency when ftrace is enabled.
       microblaze: Fix microblaze init vectors
       microblaze: Fix _reset function
       microblaze: Do not copy reset vectors/manual reset vector setup

Steven J. Magnani (1):
       microblaze: Fix /dev/zero corruption from __clear_user()

Thomas Gleixner (3):
       microblaze: Remove stale irq_chip.end
       microblaze: Select GENERIC_HARDIRQS_NO_DEPRECATED
       microblaze: Convert irq_chip to new functions

Tobias Klauser (1):
       microblaze: Fix typo in Kconfig

  arch/microblaze/Kconfig                       |   14 +-
  arch/microblaze/include/asm/cacheflush.h      |   13 +-
  arch/microblaze/include/asm/cpuinfo.h         |    4 +-
  arch/microblaze/include/asm/entry.h           |   36 ---
  arch/microblaze/include/asm/exceptions.h      |    3 +
  arch/microblaze/include/asm/irq.h             |    2 -
  arch/microblaze/include/asm/pgtable.h         |    2 +-
  arch/microblaze/include/asm/processor.h       |    2 +-
  arch/microblaze/include/asm/ptrace.h          |   14 +-
  arch/microblaze/include/asm/syscall.h         |    3 +
  arch/microblaze/include/asm/syscalls.h        |    8 +
  arch/microblaze/include/asm/uaccess.h         |    8 +-
  arch/microblaze/include/asm/unaligned.h       |   11 +-
  arch/microblaze/kernel/cpu/cache.c            |   16 +-
  arch/microblaze/kernel/cpu/cpuinfo.c          |    1 +
  arch/microblaze/kernel/dma.c                  |    1 +
  arch/microblaze/kernel/entry-nommu.S          |    4 +-
  arch/microblaze/kernel/entry.S                |  325 +++++++++++++------------
  arch/microblaze/kernel/exceptions.c           |    2 +-
  arch/microblaze/kernel/head.S                 |   24 +-
  arch/microblaze/kernel/hw_exception_handler.S |   48 +++--
  arch/microblaze/kernel/intc.c                 |   51 ++---
  arch/microblaze/kernel/irq.c                  |   12 +-
  arch/microblaze/kernel/microblaze_ksyms.c     |   12 +
  arch/microblaze/kernel/process.c              |    2 +-
  arch/microblaze/kernel/prom.c                 |    2 +-
  arch/microblaze/kernel/ptrace.c               |    3 +-
  arch/microblaze/kernel/setup.c                |   12 +-
  arch/microblaze/kernel/signal.c               |    8 +-
  arch/microblaze/kernel/sys_microblaze.c       |    3 +-
  arch/microblaze/kernel/timer.c                |    6 +-
  arch/microblaze/kernel/unwind.c               |    2 +-
  arch/microblaze/kernel/vmlinux.lds.S          |    5 -
  arch/microblaze/lib/muldi3.c                  |    1 +
  arch/microblaze/mm/consistent.c               |    2 +-
  arch/microblaze/mm/fault.c                    |    2 +-
  36 files changed, 347 insertions(+), 317 deletions(-)


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
