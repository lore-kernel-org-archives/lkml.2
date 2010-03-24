Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab0CXCjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 22:39:48 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57754 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab0CXCjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 22:39:46 -0400
Date: Wed, 24 Mar 2010 11:38:35 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.34-rc3
Message-ID: <20100324023834.GA10729@linux-sh.org>
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

Andreas Bombe (1):
      sh64: Remove long unused mid_sched macro

Guennadi Liakhovetski (2):
      SH: fix SCIFA SCASCR register bit definitions
      SH: remove superfluous warning from the serial driver

Kuninori Morimoto (3):
      sh: mach-ecovec24: Add i2c_put_adapter on sh_eth_init
      sh: ms7724: Add tiny-document for sound
      sh: Add watch-dog register address for SH7722/SH7723/SH7724

Magnus Damm (1):
      serial: sh-sci: fix SH-Mobile SH breakage

Matt Fleming (3):
      sh: Flush ITLB too in PTEAEX's flush_tlb_page()
      sh: Replace unsafe manipulation of MMUCR
      sh: Fix build after dynamic PMB rework

Paul Mundt (2):
      sh: Tidy up a couple of section mismatches.
      sh: Silence unintialized variable warnings in dwarf unwinder.

 arch/sh/boards/mach-ecovec24/setup.c      |    2 +
 arch/sh/boards/mach-se/7724/setup.c       |    8 ++++++
 arch/sh/include/cpu-sh4/cpu/mmu_context.h |    2 +
 arch/sh/include/cpu-sh4/cpu/watchdog.h    |    6 +++++
 arch/sh/kernel/dwarf.c                    |    4 +-
 arch/sh/kernel/idle.c                     |    2 +-
 arch/sh/kernel/perf_event.c               |    2 +-
 arch/sh/kernel/process_64.c               |    7 -----
 arch/sh/mm/pmb.c                          |    4 ++-
 arch/sh/mm/tlb-pteaex.c                   |    2 +
 arch/sh/mm/tlbflush_32.c                  |   21 ++++++++++++-----
 drivers/serial/sh-sci.c                   |    4 ---
 drivers/serial/sh-sci.h                   |   35 ++++++++++++++++++++++------
 13 files changed, 69 insertions(+), 30 deletions(-)
