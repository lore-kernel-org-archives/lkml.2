Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab2C1GcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 02:32:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38111 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2C1GcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 02:32:12 -0400
Message-ID: <4F72B068.7090001@monstr.eu>
Date: Wed, 28 Mar 2012 08:32:08 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL v2] arch/microblaze changes for 3.4
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is the second pull request for Microblaze. Patches are listed below.
Please pull them.

Thanks,
Michal

The following changes since commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7:
   Linus Torvalds (1):
         Linux 3.3

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git next

Joe Perches (1):
       microblaze: Use vsprintf extention %pf with builtin_return_address

Masanari Iida (1):
       microblaze: Fix typo in early_printk.c

Michal Simek (17):
       microblaze: Fix makefile to work with latest toolchain
       microblaze: Add PVR version string for MB 8.20.b and 8.30.a
       microblaze: trivial: Fix typo fault in timer.c
       microblaze: mm: Use ZONE_DMA instead of ZONE_NORMAL
       microblaze: mm: Fix lowmem max memory size limits
       microblaze: Introduce fixmap
       microblaze: Show more detailed information about memory
       microblaze: Use active regions
       microblaze: Highmem support
       microblaze: Fix mapin_ram function
       microblaze: Use node name instead of compatible string
       microblaze: Clear all MSR flags on the first kernel instruction
       microblaze: Extend space for compiled-in FDT to 32kB
       microblaze: Improve TLB calculation for small systems
       microblaze: Introduce TLB skip size
       microblaze: Handle TLB skip size dynamically
       microblaze: Fix __futex_atomic_op macro register usage

  arch/microblaze/Kconfig                       |   33 +++--
  arch/microblaze/boot/Makefile                 |    2 +-
  arch/microblaze/include/asm/fixmap.h          |  109 ++++++++++++
  arch/microblaze/include/asm/futex.h           |    2 +-
  arch/microblaze/include/asm/highmem.h         |   96 +++++++++++
  arch/microblaze/include/asm/mmu.h             |   12 ++
  arch/microblaze/include/asm/page.h            |    2 +-
  arch/microblaze/include/asm/pgtable.h         |    3 +-
  arch/microblaze/include/asm/setup.h           |    3 +-
  arch/microblaze/include/asm/system.h          |    1 +
  arch/microblaze/include/asm/uaccess.h         |    2 +-
  arch/microblaze/kernel/cpu/cpuinfo.c          |    2 +
  arch/microblaze/kernel/early_printk.c         |   16 ++-
  arch/microblaze/kernel/head.S                 |  129 +++++++++++++--
  arch/microblaze/kernel/hw_exception_handler.S |   13 +-
  arch/microblaze/kernel/intc.c                 |    4 +-
  arch/microblaze/kernel/misc.S                 |   13 +-
  arch/microblaze/kernel/setup.c                |   24 +++-
  arch/microblaze/kernel/timer.c                |    6 +-
  arch/microblaze/kernel/vmlinux.lds.S          |    2 +-
  arch/microblaze/mm/Makefile                   |    1 +
  arch/microblaze/mm/highmem.c                  |   88 ++++++++++
  arch/microblaze/mm/init.c                     |  224 ++++++++++++++++++++-----
  arch/microblaze/mm/pgtable.c                  |   20 ++-
  24 files changed, 711 insertions(+), 96 deletions(-)
  create mode 100644 arch/microblaze/include/asm/fixmap.h
  create mode 100644 arch/microblaze/include/asm/highmem.h
  create mode 100644 arch/microblaze/mm/highmem.c

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
