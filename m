Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340Ab0DBHqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 03:46:06 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:37387 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759328Ab0DBHp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 03:45:56 -0400
Date: Fri, 2 Apr 2010 16:44:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.34-rc4
Message-ID: <20100402074431.GC14056@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.34

Which contains:

Andrea Gelmini (1):
      USB gadget r8a66597-udc.c: duplicated include

Andrew Stubbs (1):
      sh: Fix FDPIC binary loader

Julia Lawall (1):
      arch/sh/kernel: Use set_cpus_allowed_ptr

Matt Fleming (2):
      sh: update the TLB replacement counter for entry wiring.
      sh: Enable the mmu in start_secondary()

Paul Mundt (2):
      sh: export return_address() symbol.
      sh: Fix up the SH-3 build for recent TLB changes.

Yusuke Goda (1):
      sh: Update ecovec_defconfig

 arch/sh/configs/ecovec24_defconfig        |  236 +++++++++++++++++++++++------
 arch/sh/include/asm/elf.h                 |    6 +-
 arch/sh/include/cpu-sh4/cpu/mmu_context.h |    2 +
 arch/sh/kernel/cpufreq.c                  |    4 +-
 arch/sh/kernel/return_address.c           |    3 +
 arch/sh/kernel/smp.c                      |    1 +
 arch/sh/mm/tlb-pteaex.c                   |   28 ++++
 arch/sh/mm/tlb-sh3.c                      |   19 +++
 arch/sh/mm/tlb-sh4.c                      |   28 ++++
 arch/sh/mm/tlb-urb.c                      |   22 ++-
 arch/sh/mm/tlbflush_32.c                  |   28 ----
 drivers/usb/gadget/r8a66597-udc.c         |    1 -
 12 files changed, 294 insertions(+), 84 deletions(-)
