Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab0EFJlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:41:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56102 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0EFJlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:41:23 -0400
Message-ID: <4BE28E9E.6090300@monstr.eu>
Date: Thu, 06 May 2010 11:40:46 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 2.6.34-rc7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes.

Thanks,
Michal


The following changes since commit 722154e4cacf015161efe60009ae9be23d492296:
   Linus Torvalds (1):
         Merge branch 'zerolen' of git://git.kernel.org/.../jgarzik/misc-2.6

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git for-linus

Michal Simek (16):
       microblaze: PCI: add pci_bus_for_each_resource(), remove direct 
bus->resource[] refs
       microblaze: resource/PCI: align functions now return start of 
resource
       microblaze: Quiet section mismatch warnings for MMU version
       microblaze: Remove ancient code
       microblaze: Add isa_dma_bridge_buggy to dma.h
       microblaze: Remove "cache" optimized copy_page function
       microblaze: page.h: Remove get_user_page and free_user_page
       microblaze: pci-dma: use include/linux/dma-mapping.h
       microblaze: Fix consistent code
       microblaze: Fix typo fault in cache code
       microblaze: Fix kmalloc alignment on non-coherent DMA platforms
       microblaze: cpuinfo shows cache line length
       microblaze: Define correct L1_CACHE_SHIFT value
       microblaze: Fix consistent-sync code
       microblaze: Optimize CACHE_LOOP_LIMITS and CACHE_RANGE_LOOP macros
       microblaze: Defconfig update

Nick Piggin (1):
       microblaze: invoke oom-killer from page fault

Randy Dunlap (1):
       microblaze: fix divide by zero exception message

Steven J. Magnani (2):
       microblaze: Fix IRQ entry/exit ftracing
       microblaze: Quiet section mismatch warnings

  arch/microblaze/configs/mmu_defconfig    |   58 ++++++++-
  arch/microblaze/configs/nommu_defconfig  |   39 +++++-
  arch/microblaze/include/asm/cache.h      |    2 +-
  arch/microblaze/include/asm/dma.h        |    6 +
  arch/microblaze/include/asm/exceptions.h |    6 -
  arch/microblaze/include/asm/io.h         |    2 -
  arch/microblaze/include/asm/page.h       |   12 +--
  arch/microblaze/include/asm/pci.h        |    8 --
  arch/microblaze/include/asm/pgalloc.h    |   16 +---
  arch/microblaze/include/asm/pgtable.h    |   35 +------
  arch/microblaze/kernel/asm-offsets.c     |    1 +
  arch/microblaze/kernel/cpu/cache.c       |   72 ++++++-----
  arch/microblaze/kernel/cpu/mb.c          |   10 +-
  arch/microblaze/kernel/dma.c             |    2 +-
  arch/microblaze/kernel/exceptions.c      |    2 +-
  arch/microblaze/kernel/head.S            |    3 +-
  arch/microblaze/kernel/irq.c             |    3 +-
  arch/microblaze/kernel/misc.S            |   36 ------
  arch/microblaze/kernel/traps.c           |   34 ------
  arch/microblaze/kernel/vmlinux.lds.S     |    3 +-
  arch/microblaze/mm/consistent.c          |  190 
++++++++++++++++--------------
  arch/microblaze/mm/fault.c               |   13 +--
  arch/microblaze/mm/pgtable.c             |   51 +++------
  arch/microblaze/pci/pci-common.c         |   17 ++--
  24 files changed, 278 insertions(+), 343 deletions(-)


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
