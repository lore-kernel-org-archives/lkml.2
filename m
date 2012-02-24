Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab2BXEs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 23:48:58 -0500
Received: from linux-sh.org ([111.68.239.195]:51618 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752Ab2BXEs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 23:48:56 -0500
Date: Fri, 24 Feb 2012 13:48:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh fixes for 3.3-rc5
Message-ID: <20120224044852.GH9994@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 74ea15d909b31158f9b63190a95b52bc05586d4b:

  Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2012-01-26 17:04:47 -0800)

are available in the git repository at:


  git://github.com/pmundt/linux-sh.git sh-for-linus

for you to fetch changes up to 1ae911cba414f7e805b2cb3798fa402b36a21601:

  sh: Fix sh2a build error for CONFIG_CACHE_WRITETHROUGH (2012-02-24 13:21:46 +0900)

----------------------------------------------------------------
SuperH fixes for 3.3-rc5

----------------------------------------------------------------
Guennadi Liakhovetski (2):
      sh: sh7757lcr: update to the new MMCIF DMA configuration
      sh: se7724: fix compile breakage

Kuninori Morimoto (2):
      sh: clock-sh7724: fixup sh_fsi clock settings
      sh: clkfwk: bugfix: use clk_reparent() for div6 clocks

Masanari Iida (1):
      sh: Fix typo in pci-sh7780.c

Paul Mundt (6):
      sh: Defer to asm-generic/device.h.
      video: pvr2fb: Fix up spurious section mismatch warnings.
      Merge branch 'sh/platform-updates' into sh-latest
      Merge branch 'sh/platform-updates' into sh-latest
      Merge branch 'sh/clkfwk' into sh-latest
      Merge branches 'sh/urgent' and 'sh/platform-updates' into sh-latest

Phil Edworthy (1):
      sh: Fix sh2a build error for CONFIG_CACHE_WRITETHROUGH

Rusty Russell (1):
      arch/sh: remove references to cpu_*_map.

Shimoda, Yoshihiro (4):
      sh: fix the sh_mmcif_plat_data in board-sh7757lcr
      sh: modify resource for SPI0 in setup-sh7757
      sh: add platform_device for SPI1 in setup-sh7757
      sh: modify a resource of sh_eth_giga1_resources in board-sh7757lcr

 arch/sh/boards/board-sh7757lcr.c       |   20 +++++++++-----------
 arch/sh/boards/mach-ap325rxa/setup.c   |    1 +
 arch/sh/boards/mach-ecovec24/setup.c   |    2 ++
 arch/sh/boards/mach-kfr2r09/setup.c    |    1 +
 arch/sh/boards/mach-migor/setup.c      |    2 ++
 arch/sh/boards/mach-se/7724/setup.c    |    1 +
 arch/sh/drivers/pci/pci-sh7780.c       |    2 +-
 arch/sh/include/asm/device.h           |    8 ++++----
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c |    2 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c |   22 +++++++++++++++++++++-
 arch/sh/kernel/smp.c                   |    2 +-
 arch/sh/kernel/topology.c              |    2 +-
 arch/sh/mm/cache-sh2a.c                |    2 ++
 drivers/sh/clk/cpg.c                   |    2 +-
 drivers/video/pvr2fb.c                 |    2 +-
 15 files changed, 49 insertions(+), 22 deletions(-)
