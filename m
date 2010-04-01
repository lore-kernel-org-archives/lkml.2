Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab0DAGt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 02:49:26 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:40623 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab0DAGtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 02:49:20 -0400
Message-ID: <4BB441EA.2050204@monstr.eu>
Date: Thu, 01 Apr 2010 08:49:14 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>
Subject: [GIT PULL] arch/microblaze fixes for 2.6.34-rc4
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes.

Thanks,
Michal



The following changes since commit 2eaa9cfdf33b8d7fb7aff27792192e0019ae8fc6:
   Linus Torvalds (1):
         Linux 2.6.34-rc3

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git for-linus

Arun Bhanu (3):
       microblaze: Add a missing single quote to make 'make help' happy
       microblaze: Fix Makefile to delete build generated files
       microblaze: Makefile cleanups

Michal Simek (31):
       microblaze: Remove memset in free_init_pages
       microblaze: Remove segment.h
       microblaze: Move exception_table_entry upward
       microblaze: move noMMU __range_ok function to uaccess.h
       microblaze: uaccess: fix clean user macro
       microblaze: uaccess: fix __get_user_asm macro
       microblaze: uaccess: fix put_user and get_user macros
       microblaze: uaccess: sync put/get/clear_user macros
       microblaze: uaccess: copy_to_user unification
       microblaze: uaccess: fix copy_from_user macro
       microblaze: uaccess: Fix strncpy_from_user function
       microblaze: uaccess: fix clear_user for noMMU kernel
       microblaze: uaccess: Fix get_user macro for noMMU
       microblaze: uaccess: Fix put_user for noMMU
       microblaze: uaccess: Move functions to generic location
       microblaze: uaccess: Unify __copy_tofrom_user
       microblaze: uaccess: Sync strlen, strnlen, copy_to/from_user
       microblaze: Support systems without lmb bram
       microblaze: Add DEBUG option
       microblaze: Prepare work for optimization in exception code
       microblaze: Change register usage for ESR and EAR
       microblaze: Remove additional resr and rear loading
       microblaze: Use instruction with delay slot
       microblaze: Fix TLB macros
       microblaze: Add .type and .size to ASM functions
       microblaze: Adding likely macros
       microblaze: Kconfig Fix - pci
       microblaze: Use MICROBLAZE_TLB_SIZE in asm code
       microblaze: head.S typo fix
       microblaze: Print early printk information to log buffer
       microblaze: Support word copying in copy_tofrom_user

Steven J. Magnani (1):
       microblaze: Fix "kstack=" parsing

  arch/microblaze/Kconfig                       |    3 -
  arch/microblaze/Makefile                      |    4 +-
  arch/microblaze/boot/Makefile                 |    6 +-
  arch/microblaze/include/asm/processor.h       |    1 -
  arch/microblaze/include/asm/segment.h         |   49 ---
  arch/microblaze/include/asm/thread_info.h     |    5 +-
  arch/microblaze/include/asm/tlbflush.h        |    3 +-
  arch/microblaze/include/asm/uaccess.h         |  447 
++++++++++++++-----------
  arch/microblaze/kernel/dma.c                  |    2 +-
  arch/microblaze/kernel/head.S                 |   12 +-
  arch/microblaze/kernel/hw_exception_handler.S |  112 +++----
  arch/microblaze/kernel/misc.S                 |   15 +-
  arch/microblaze/kernel/process.c              |   10 +-
  arch/microblaze/kernel/setup.c                |   24 +-
  arch/microblaze/kernel/traps.c                |    6 +-
  arch/microblaze/lib/Makefile                  |    3 +-
  arch/microblaze/lib/fastcopy.S                |    6 +-
  arch/microblaze/lib/memcpy.c                  |    2 +-
  arch/microblaze/lib/memset.c                  |   15 +-
  arch/microblaze/lib/uaccess.c                 |   48 ---
  arch/microblaze/lib/uaccess_old.S             |   45 ++-
  arch/microblaze/mm/fault.c                    |   24 +-
  arch/microblaze/mm/init.c                     |    9 -
  arch/microblaze/mm/pgtable.c                  |    2 +-
  24 files changed, 407 insertions(+), 446 deletions(-)
  delete mode 100644 arch/microblaze/include/asm/segment.h
  delete mode 100644 arch/microblaze/lib/uaccess.c



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
