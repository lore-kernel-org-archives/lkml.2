Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab1AKLYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:24:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53889 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab1AKLYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:24:22 -0500
Message-ID: <4D2C3DE0.1030503@monstr.eu>
Date: Tue, 11 Jan 2011 12:24:16 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze changes for 2.6.38
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes.

Thanks,
Michal


The following changes since commit 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5:
   Linus Torvalds (1):
         Linux 2.6.37

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git next

Amerigo Wang (1):
       microblaze: remove obsolete DEBUG_BOOTMEM

Joe Perches (1):
       arch/microblaze: Remove unnecessary semicolons

Michal Simek (9):
       microblaze: Fix initramfs
       Revert "microblaze: Simplify syscall rutine"
       microblaze: Add PVR for Microblaze v8.00.b
       microblaze: Fix unaligned exception for little endian platform
       microblaze: Remove useless early_init_dt_check_for_initrd
       microblaze: Clear i/dcache for sw breakpoints
       microblaze: Fix __muldi3 function for little-endian.
       microblaze: trivial: Fix removed the part of line
       Merge commit 'v2.6.37' into next

roel kluin (1):
       microblaze: Correct PVR access macros

  arch/microblaze/Kconfig.debug                 |    4 -
  arch/microblaze/Makefile                      |    2 +-
  arch/microblaze/configs/mmu_defconfig         |    1 -
  arch/microblaze/include/asm/pvr.h             |  185 
+++++++++++++------------
  arch/microblaze/kernel/cpu/cpuinfo.c          |    1 +
  arch/microblaze/kernel/entry.S                |   46 +++++-
  arch/microblaze/kernel/exceptions.c           |    3 +
  arch/microblaze/kernel/hw_exception_handler.S |    9 ++
  arch/microblaze/kernel/prom.c                 |    4 +-
  arch/microblaze/kernel/vmlinux.lds.S          |   16 +--
  arch/microblaze/lib/memmove.c                 |    2 +-
  arch/microblaze/lib/muldi3.S                  |  121 ----------------
  arch/microblaze/lib/muldi3.c                  |   60 ++++++++
  13 files changed, 214 insertions(+), 240 deletions(-)
  delete mode 100644 arch/microblaze/lib/muldi3.S
  create mode 100644 arch/microblaze/lib/muldi3.c


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
