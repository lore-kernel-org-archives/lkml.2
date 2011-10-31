Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1JaNVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 09:21:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56037 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab1JaNVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 09:21:34 -0400
Message-ID: <4EAEA0DA.208@monstr.eu>
Date: Mon, 31 Oct 2011 14:21:30 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze changes for 3.2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes.

Thanks,
Michal

The following changes since commit e9308cfd5ab4ade3d81cf591c7599c3a05a21b04:
   Linus Torvalds (1):
         Merge branch 'gpio/merge' of git://git.secretlab.ca/git/linux-2.6

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git next

Edgar E. Iglesias (2):
       microblaze: Switch ELF_ARCH code to 189
       microblaze: Raise SIGFPE/FPE_INTDIV for div by zero

Eli Billauer (2):
       microblaze: Moved __dma_sync() to dma-mapping.h
       microblaze: Added DMA sync operations

Michal Simek (11):
       microblaze: Clear top bit from cnt32_to_63
       microblaze: Change label name in copy_tofrom_user
       microblaze: Separate fixup section definition
       microblaze: Change label names - copy_tofrom_user
       microblaze: Simplify logic for unaligned byte copying
       microblaze: Add loop unrolling for PAGE in copy_tofrom_user
       microblaze: Fix access_ok macro
       microblaze: Add PVR for Microblaze v8.20.a
       microblaze: Add __ucmpdi2() helper function
       microblaze: Remove NET_IP_ALIGN from system.h
       microblaze: Use delay slot in __strnlen_user, __strncpy_user

Peter Zijlstra (1):
       microblaze: Remove __ARCH_WANT_INTERRUPTS_ON_CTXSW usage

  arch/microblaze/include/asm/dma-mapping.h |   20 ++++-
  arch/microblaze/include/asm/elf.h         |    8 +-
  arch/microblaze/include/asm/system.h      |    9 --
  arch/microblaze/include/asm/uaccess.h     |    2 +-
  arch/microblaze/kernel/cpu/cpuinfo.c      |    1 +
  arch/microblaze/kernel/dma.c              |   82 +++++++++++++++-----
  arch/microblaze/kernel/exceptions.c       |    2 +-
  arch/microblaze/kernel/process.c          |    1 +
  arch/microblaze/kernel/ptrace.c           |    2 +-
  arch/microblaze/kernel/timer.c            |    3 +-
  arch/microblaze/lib/Makefile              |    1 +
  arch/microblaze/lib/uaccess_old.S         |  123 +++++++++++++++++++++++++----
  arch/microblaze/lib/ucmpdi2.c             |   20 +++++
  13 files changed, 220 insertions(+), 54 deletions(-)
  create mode 100644 arch/microblaze/lib/ucmpdi2.c


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
