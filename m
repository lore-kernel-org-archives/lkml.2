Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1KFBdP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 21:33:15 -0400
Received: from linux-sh.org ([111.68.239.195]:51864 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab1KFBdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 21:33:14 -0400
Date: Sun, 6 Nov 2011 10:33:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] rmobile updates for 3.2
Message-ID: <20111106013302.GF29825@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	git://github.com/pmundt/linux-sh.git rmobile-latest

Which contains:

Bastian Hecht (1):
      ARM: sh7372 ap4evb NOR Flash USB boot fix

Guennadi Liakhovetski (1):
      ARM: mach-shmobile: ag5evm needs CONFIG_I2C

Magnus Damm (19):
      ARM: mach-shmobile: sh73a0 PFC pull-up support for SDHI0+2
      ARM: mach-shmobile: Kota2 SCIFA2 and SMSC911X support
      ARM: mach-shmobile: Kota2 KEYSC support
      ARM: mach-shmobile: Kota2 GPIO Keys support
      ARM: mach-shmobile: Kota2 GPIO LEDs support
      ARM: mach-shmobile: Kota2 MMCIF support
      ARM: mach-shmobile: Kota2 SCIFA4 and SCIFB support
      ARM: mach-shmobile: Kota2 SDHI0 and SDHI1 support
      ARM: mach-shmobile: Break out INTC IRQ code
      sh: intc: Allow triggering on both edges for ARM SoCs
      ARM: mach-shmobile: sh7372 Mackerel NOR Flash USB boot fix
      ARM: mach-shmobile: sh73a0 GPIO IRQ support
      ARM: mach-shmobile: Use common INTC IRQ code on sh7367
      ARM: mach-shmobile: Use common INTC IRQ code on sh7377
      ARM: mach-shmobile: Use common INTC IRQ code on sh7372
      ARM: mach-shmobile: Use common INTC IRQ code on sh73a0
      ARM: mach-shmobile: SDHI0 GPIO hotplug for AG5EVM
      ARM: mach-shmobile: Add support for PINT though INTC macros
      ARM: mach-shmobile: sh73a0 and AG5EVM PINT support

 arch/arm/mach-shmobile/Kconfig               |    8 +
 arch/arm/mach-shmobile/Makefile              |    1 +
 arch/arm/mach-shmobile/board-ag5evm.c        |   36 ++-
 arch/arm/mach-shmobile/board-ap4evb.c        |    4 +-
 arch/arm/mach-shmobile/board-kota2.c         |  447 ++++++++++++++++++++++++++
 arch/arm/mach-shmobile/board-mackerel.c      |    4 +-
 arch/arm/mach-shmobile/include/mach/intc.h   |  246 ++++++++++++++
 arch/arm/mach-shmobile/include/mach/sh73a0.h |   17 +
 arch/arm/mach-shmobile/intc-sh7367.c         |   40 +--
 arch/arm/mach-shmobile/intc-sh7372.c         |   72 +----
 arch/arm/mach-shmobile/intc-sh7377.c         |   67 +----
 arch/arm/mach-shmobile/intc-sh73a0.c         |  187 +++++++++++
 arch/arm/mach-shmobile/pfc-sh73a0.c          |  120 ++++++-
 arch/arm/mach-shmobile/platsmp.c             |   10 +-
 drivers/sh/intc/chip.c                       |    2 +-
 15 files changed, 1063 insertions(+), 198 deletions(-)
 create mode 100644 arch/arm/mach-shmobile/board-kota2.c
 create mode 100644 arch/arm/mach-shmobile/include/mach/intc.h
