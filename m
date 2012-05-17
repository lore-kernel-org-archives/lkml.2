Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967388Ab2EQQs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:48:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:2524 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967351Ab2EQQsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:48:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101269460"
Subject: [GIT PULL] slave-dmaengine fixes
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dan <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 May 2012 22:10:15 +0530
Message-ID: <1337272815.16185.5416.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following to receive fixes of cylic dma usages in slave
dma drivers.

The following changes since commit
88c08a3fba9954ce0ec3e1eab07c498a419ad7e3:

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Vinod Koul (2):
      dmaengine: pl330: dont complete descriptor for cyclic dma
      dmaengine: fix cyclic dma usage

 drivers/dma/at_hdmac.c   |    4 +++-
 drivers/dma/ep93xx_dma.c |    4 +++-
 drivers/dma/pl330.c      |    3 ++-
 3 files changed, 8 insertions(+), 3 deletions(-)

-- 
~Vinod

