Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab1KBOWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 10:22:41 -0400
Received: from linux-sh.org ([111.68.239.195]:40475 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204Ab1KBOWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 10:22:40 -0400
Date: Wed, 2 Nov 2011 23:22:34 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 3.2
Message-ID: <20111102142233.GC5972@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	git://github.com/pmundt/linux-sh.git sh-latest

Which contains:

Kuninori Morimoto (1):
      sh: ecovec: add renesas_usbhs DMAEngine support

Magnus Damm (4):
      sh: intc: Add IRQ trigger bit field check
      sh: pfc: get_config_reg() shift clean up
      sh: pfc: Remove unused gpio_in_use member
      sh: pfc: Add GPIO IRQ support

Nobuhiro Iwamatsu (4):
      sh: Fix implicit declaration of function numa_node_id
      sh: userimask.c needs linux/stat.h
      sh: modify the asm/sh_eth.h to linux/sh_eth.h in sh7757lcr
      sh: Add default uImage rule for sh7757lcr

Paul Bolle (1):
      sh: drop unused Kconfig symbol

Simon Horman (2):
      sh: kexec: Register crashk_res
      sh: kexec: Add PHYSICAL_START

Yong Zhang (1):
      SH: irq: Remove IRQF_DISABLED

Yoshihiro Shimoda (2):
      sh: add parameters for EHCI and RIIC in clock-sh7757.c
      sh: modify the asm/sh_eth.h to linux/sh_eth.h in some boards

 arch/sh/Kconfig                        |   17 ++++++++++++-----
 arch/sh/Makefile                       |    1 +
 arch/sh/boards/board-espt.c            |    2 +-
 arch/sh/boards/board-secureedge5410.c  |    3 +--
 arch/sh/boards/board-sh7757lcr.c       |    2 +-
 arch/sh/boards/mach-cayman/irq.c       |    2 --
 arch/sh/boards/mach-ecovec24/setup.c   |    6 +++++-
 arch/sh/boards/mach-hp6xx/hp6xx_apm.c  |    2 +-
 arch/sh/boards/mach-se/7724/setup.c    |    2 +-
 arch/sh/boards/mach-sh7763rdp/setup.c  |    2 +-
 arch/sh/boot/Makefile                  |    6 ++++--
 arch/sh/drivers/dma/dma-g2.c           |    2 +-
 arch/sh/drivers/dma/dma-pvr2.c         |    1 -
 arch/sh/drivers/dma/dma-sh.c           |    4 ++--
 arch/sh/drivers/dma/dmabrg.c           |    6 +++---
 arch/sh/drivers/pci/pci-sh5.c          |    4 ++--
 arch/sh/drivers/pci/pci-sh7780.c       |    2 +-
 arch/sh/drivers/push-switch.c          |    2 +-
 arch/sh/include/asm/page.h             |   10 ++++++++++
 arch/sh/kernel/cpu/sh4a/clock-sh7757.c |   10 +++++++++-
 arch/sh/kernel/cpu/sh4a/smp-shx3.c     |    2 +-
 arch/sh/kernel/setup.c                 |    9 ++++++---
 arch/sh/kernel/topology.c              |    1 +
 arch/sh/kernel/vmlinux.lds.S           |    2 +-
 arch/sh/mm/init.c                      |    8 ++++----
 drivers/sh/intc/chip.c                 |    9 +++++++--
 drivers/sh/intc/userimask.c            |    1 +
 drivers/sh/pfc.c                       |   29 ++++++++++++++++++++++++++++-
 include/linux/sh_pfc.h                 |   12 +++++++++++-
 29 files changed, 117 insertions(+), 42 deletions(-)
