Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab2JEOpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:45:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60726 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843Ab2JEOpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:45:42 -0400
Message-ID: <506EF293.9030100@monstr.eu>
Date: Fri, 05 Oct 2012 16:45:39 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze changes for 3.7-rc1
References: <4FC32330.8060300@monstr.eu>
In-Reply-To: <4FC32330.8060300@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes.

Thanks,
Michal

The following changes since commit a0d271cbfed1dd50278c6b06bead3d00ba0a88f9:
   Linus Torvalds (1):
         Linux 3.6

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git next

John Linn (1):
       microblaze: Added more support for PCI

Michal Simek (10):
       microblaze: Add support for ioreadXX/iowriteXX_rep
       microblaze: Added fdt chosen capability for timer
       microblaze: Do not used hardcoded value in exception handler
       microblaze: Support 4k/16k/64k pages
       microblaze: Use predefined macro for ESR_DIZ
       microblaze: Remove additional andi which has been already done
       microblaze: Remove PAGE properties duplication
       microblaze: Fix bug with passing command line
       microblaze: Prefer to use pr_XXX instead of printk(KERN_XX)
       Revert "microblaze_mmu_v2: Update signal returning address"

Paul Bolle (1):
       microblaze: clinkage.h

Stephan Linz (1):
       microblaze: Improve failure handling for GPIO reset

  arch/microblaze/Kconfig                       |    7 +--
  arch/microblaze/include/asm/clinkage.h        |    1 -
  arch/microblaze/include/asm/io.h              |   94 +++++++++++++++++++++++++
  arch/microblaze/include/asm/page.h            |    9 +--
  arch/microblaze/include/asm/pci.h             |    2 +
  arch/microblaze/include/asm/pgtable.h         |    6 --
  arch/microblaze/kernel/head.S                 |   14 +++--
  arch/microblaze/kernel/hw_exception_handler.S |   61 ++++++++++-------
  arch/microblaze/kernel/reset.c                |   21 +++---
  arch/microblaze/kernel/setup.c                |   15 ++--
  arch/microblaze/kernel/signal.c               |    8 --
  arch/microblaze/kernel/timer.c                |   24 ++++--
  12 files changed, 182 insertions(+), 80 deletions(-)
  delete mode 100644 arch/microblaze/include/asm/clinkage.h


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
