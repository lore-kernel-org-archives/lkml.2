Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab2BXEs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 23:48:58 -0500
Received: from linux-sh.org ([111.68.239.195]:51620 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825Ab2BXEs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 23:48:56 -0500
Date: Fri, 24 Feb 2012 13:48:53 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] rmobile fixes for 3.3-rc5
Message-ID: <20120224044853.GA3112@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit bb4c7e9a9908548b458f34afb2fee74dc0d49f90:

  Merge branch 'for-linus' of git://oss.sgi.com/xfs/xfs (2012-02-23 15:38:57 -0800)

are available in the git repository at:


  git://github.com/pmundt/linux-sh.git rmobile-for-linus

for you to fetch changes up to 7372a4cd6c6fe07ae9d7d0340717736fba863580:

  arch/arm/mach-shmobile/board-ag5evm.c: included linux/dma-mapping.h twice (2012-02-24 13:32:17 +0900)

----------------------------------------------------------------
SH/R-Mobile fixes for 3.3-rc5

----------------------------------------------------------------
Danny Kukawka (1):
      arch/arm/mach-shmobile/board-ag5evm.c: included linux/dma-mapping.h twice

Guennadi Liakhovetski (2):
      ARM: mach-shmobile: simplify MMCIF DMA configuration
      ARM: mach-shmobile: add GPIO-to-IRQ translation to sh7372

Kuninori Morimoto (3):
      ARM: mach-shmobile: mackerel: use renesas_usbhs instead of r8a66597_hcd
      ARM: mach-shmobile: mackerel: add ak4642 amixer settings on comment
      ARM: mach-shmobile: clock-sh73a0: add DSIxPHY clock support

Magnus Damm (5):
      ARM: mach-shmobile: sh73a0 PINT IRQ base fix
      ARM: mach-shmobile: sh73a0 IRQ sparse alloc fix
      ARM: mach-shmobile: IRQ driven GPIO key support for Kota2
      ARM: mach-shmobile: sh73a0 PSTR 32-bit access fix
      ARM: mach-shmobile: r8a7779 PFC IPSR4 fix

Paul Gortmaker (1):
      arm: fix compile failure in mach-shmobile/board-ag5evm.c

Paul Mundt (4):
      Merge branch 'rmobile/kota2' into rmobile-fixes-for-linus
      Merge branch 'rmobile/mackerel' into rmobile-fixes-for-linus
      Merge branch 'rmobile/urgent' into rmobile-fixes-for-linus
      Merge git://git.kernel.org/.../torvalds/linux into rmobile-fixes-for-linus

 arch/arm/mach-shmobile/board-ag5evm.c        |   29 ++++---
 arch/arm/mach-shmobile/board-ap4evb.c        |   12 +---
 arch/arm/mach-shmobile/board-kota2.c         |    3 +-
 arch/arm/mach-shmobile/board-mackerel.c      |   95 +++++-----------------
 arch/arm/mach-shmobile/clock-sh73a0.c        |  113 ++++++++++++++++++++++++++
 arch/arm/mach-shmobile/include/mach/sh73a0.h |    6 +-
 arch/arm/mach-shmobile/intc-sh73a0.c         |    2 +
 arch/arm/mach-shmobile/pfc-r8a7779.c         |    2 +-
 arch/arm/mach-shmobile/pfc-sh7372.c          |   41 +++++++++
 arch/arm/mach-shmobile/smp-sh73a0.c          |    2 +-
 10 files changed, 200 insertions(+), 105 deletions(-)
