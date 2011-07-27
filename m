Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab1G0JIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:08:06 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33949 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1G0JIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:08:04 -0400
Message-ID: <4E2FD56B.60502@monstr.eu>
Date: Wed, 27 Jul 2011 11:07:55 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL\ arch/microblaze changes for 3.1-rc1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes for microblaze.

Thanks,
Michal


The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:
   Linus Torvalds (1):
         Linux 3.0

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git next

John A. Williams (2):
       microblaze: Unprivileged stream instruction awareness
       microblaze: Standardise cpuinfo output for cache policy

Mathias Krause (2):
       microblaze: Remove duplicated prototype of start_thread()
       microblaze: exec: Remove redundant set_fs(USER_DS)

Michal Simek (8):
       microblaze: Fix unaligned value saving to the stack for system with MMU
       microblaze: trivial: Fix typo fault
       microblaze: Get early printk console earlier
       microblaze: Simplify early console binding from DT
       microblaze: Add support for early console on mdm
       microblaze: PCI fix typo fault in of_node pointer moving into pci_bus
       Revert "microblaze: PCI fix typo fault in of_node pointer moving into 
pci_bus"
       microblaze: Do not show error message for 32 interrupt lines

Steven Rostedt (1):
       microblaze/irqs: Do not trace arch_local_{*,irq_*} functions

  arch/microblaze/include/asm/cpuinfo.h         |    1 +
  arch/microblaze/include/asm/irqflags.h        |   20 +++---
  arch/microblaze/include/asm/processor.h       |    3 -
  arch/microblaze/include/asm/prom.h            |    8 ++-
  arch/microblaze/include/asm/pvr.h             |    5 +-
  arch/microblaze/include/asm/setup.h           |    1 +
  arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c |    1 +
  arch/microblaze/kernel/cpu/cpuinfo-static.c   |    1 +
  arch/microblaze/kernel/cpu/cpuinfo.c          |    4 +
  arch/microblaze/kernel/cpu/mb.c               |    9 ++-
  arch/microblaze/kernel/early_printk.c         |   68 ++++++++++--------
  arch/microblaze/kernel/hw_exception_handler.S |   56 +++++++-------
  arch/microblaze/kernel/intc.c                 |    2 +-
  arch/microblaze/kernel/process.c              |    1 -
  arch/microblaze/kernel/prom.c                 |   97 +++++++++++--------------
  arch/microblaze/kernel/setup.c                |    5 ++
  16 files changed, 149 insertions(+), 133 deletions(-)


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
