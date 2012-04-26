Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486Ab2DZQoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 12:44:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:23125 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757752Ab2DZQoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 12:44:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158712866"
Subject: [GIT PULL] slave-dmaengine fixes
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dan <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Apr 2012 22:10:25 +0530
Message-ID: <1335458425.31825.129.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following to recieve fixes of slave dma drivers.
This round we have small fixes on few drivers

The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:
  Linus Torvalds (1):
        Linux 3.4-rc1

are available in the git repository at:
  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Davide Ciminaghi (1):
      dmaengine/amba-pl08x : reset phychan_hold on terminate all

Linus Walleij (2):
      dma/ste_dma40: explicitly include regulator consumer header
      dma/ste_dma40: fix erroneous comparison

Narayanan G (1):
      dma40: Improve the logic of stopping logical chan

Nicolas Ferre (1):
      dmaengine: at_hdmac: remove clear-on-read in atc_dostart()

Olof Johansson (1):
      dma: pl330: fix a couple of compilation warnings

Shawn Guo (1):
      dma: mxs-dma: enable channel in device_issue_pending call

Vinod Koul (1):
      dmaengine: imx-dma: dont complete descriptor for cyclic dma

 drivers/dma/amba-pl08x.c               |    1 +
 drivers/dma/at_hdmac.c                 |    4 -
 drivers/dma/imx-dma.c                  |    9 +-
 drivers/dma/mxs-dma.c                  |   10 +-
 drivers/dma/pl330.c                    |   25 ++-
 drivers/dma/ste_dma40.c                |  323 ++++++++++++++++++++------------
 drivers/dma/ste_dma40_ll.h             |    2 -
 drivers/mmc/host/mxs-mmc.c             |    3 +
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c |    1 +
 9 files changed, 230 insertions(+), 148 deletions(-)



-- 
~Vinod

