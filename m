Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105Ab2HPSBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:01:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:34119 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098Ab2HPSBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:01:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,780,1336374000"; 
   d="scan'208";a="209462529"
Subject: [GIT PULL] slave-dmaengine fixes
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Aug 2012 23:33:12 +0530
Message-ID: <1345140192.1726.14491.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pull to receive two fixes for slave dmanegine.
One fixes the correct use of clock API in imx driver and other enables
clock for tegra driver, which is used for other tegra driver conversion
to dmanegine in -next.

The following changes since commit
0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:
  Linus Torvalds (1):
        Linux 3.6-rc1

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Fabio Estevam (1):
      dma: imx-dma: Fix kernel crash due to missing clock conversion

Laxman Dewangan (1):
      dma: tegra: enable/disable dma clock

Vinod Koul (1):
      Merge branch 'fixes_for-3.6' into fixes

 drivers/dma/imx-dma.c         |   36
+++++++++++++++++++++++++-----------
 drivers/dma/tegra20-apb-dma.c |   18 +++++++++++++++++-
 2 files changed, 42 insertions(+), 12 deletions(-)


-- 
~Vinod

