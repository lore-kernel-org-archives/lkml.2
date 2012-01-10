Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab2AJI5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 03:57:00 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51705 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2AJI47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 03:56:59 -0500
Message-ID: <4F0BFD56.8060804@monstr.eu>
Date: Tue, 10 Jan 2012 09:56:54 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze changes for 3.3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes.
There are two patches out of microblaze tree which remove NO_IRQ from xilinx sysace/ps2 drivers.
Appropriate maintainers are not active to add these drivers to their tree.
I have got ACKs from Grant and Ryan.
I have completely removed NO_IRQ from Microblaze and drivers we use.

Thanks,
Michal

The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:
   Linus Torvalds (1):
         Linux 3.2

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git next

Michal Simek (14):
       microblaze: Synchronize __pa __va macros
       microblaze: Add __cmpdi2
       microblaze: Use of_find_compatible_node for timer and intc
       microblaze: intc: Change variable name
       microblaze: Use irq_of_parse_and_map for timer
       microblaze: Change NO_IRQ to 0
       microblaze: Send CR before LF for early console
       microblaze: Remove eprintk macro
       microblaze: Fix debug message in module
       microblaze: Trivial asm fix
       block: xsysace: Don't use NO_IRQ
       input: xilinx_ps2: Don't use NO_IRQ
       microblaze: Remove NO_IRQ from architecture
       microblaze: Wire-up new system calls

  arch/microblaze/include/asm/irq.h      |   11 +++++--
  arch/microblaze/include/asm/page.h     |   11 +-----
  arch/microblaze/include/asm/setup.h    |    6 ----
  arch/microblaze/include/asm/unistd.h   |    5 ++-
  arch/microblaze/kernel/early_printk.c  |    4 +-
  arch/microblaze/kernel/entry.S         |    2 +-
  arch/microblaze/kernel/intc.c          |   52 +++++++++++++------------------
  arch/microblaze/kernel/irq.c           |   11 ++++---
  arch/microblaze/kernel/module.c        |    2 +-
  arch/microblaze/kernel/setup.c         |   18 +++++-----
  arch/microblaze/kernel/syscall_table.S |    3 ++
  arch/microblaze/kernel/timer.c         |   21 ++++---------
  arch/microblaze/lib/Makefile           |    1 +
  arch/microblaze/lib/cmpdi2.c           |   26 ++++++++++++++++
  arch/microblaze/pci/pci-common.c       |    4 +-
  drivers/block/xsysace.c                |   10 +++---
  drivers/input/serio/xilinx_ps2.c       |    2 +-
  17 files changed, 99 insertions(+), 90 deletions(-)
  create mode 100644 arch/microblaze/lib/cmpdi2.c


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
