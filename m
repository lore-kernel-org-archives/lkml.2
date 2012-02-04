Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab2BDSaU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 13:30:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:30712 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674Ab2BDSaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 13:30:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="63300564"
Subject: slave dmaengine fixes
From: Vinod Koul <vinod.koul@intel.com>
To: Linus <torvalds@linux-foundation.org>
Cc: Dan <dan.j.williams@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Feb 2012 00:01:42 +0530
Message-ID: <1328380302.26182.46.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are few dmaegine fixes. Just some minor fixes on dma drivers (sh,
at, imx) along with dmatest fix merged from Dan's tree


The following changes since commit
dcd6c92267155e70a94b3927bce681ce74b80d1f:
  Linus Torvalds (1):
        Linux 3.3-rc1

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Dr. David Alan Gilbert (1):
      dmaengine: fix missing 'cnt' in ?: in dmatest

Guennadi Liakhovetski (2):
      dma: sh_dma: not all SH DMAC implementations support MEMCPY
      ARM: mach-shmobile: both USB DMAC instances on sh7372 are
slave-only

Nikolaus Voss (1):
      at_hdmac: bugfix for enabling channel irq

Philippe Rétornaz (1):
      i.MX SDMA: Fix burstsize settings

Vinod Koul (1):
      Merge branch fixes of git://git.kernel.org/.../djbw/dmaengine.git

 arch/arm/mach-shmobile/setup-sh7372.c |    2 ++
 drivers/dma/at_hdmac.c                |    4 ++--
 drivers/dma/at_hdmac_regs.h           |   17 ++++++++---------
 drivers/dma/dmatest.c                 |    2 +-
 drivers/dma/imx-sdma.c                |    6 ++++--
 drivers/dma/shdma.c                   |    3 ++-
 include/linux/sh_dma.h                |    1 +
 7 files changed, 20 insertions(+), 15 deletions(-)

Thanks
-- 
~Vinod

