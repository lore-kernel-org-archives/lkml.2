Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab2FUCyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:54:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:18460 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757707Ab2FUCyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:54:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="183004187"
Subject: [GIT PULL] slave-dmaengine fixes
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dan <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jun 2012 08:16:27 +0530
Message-ID: <1340246787.1927.1663.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following to receive few off fixes in pl330 and imx-sdma
drivers.

The following changes since commit
f8f5701bdaf9134b1f90e5044a82c66324d2073f:
  Linus Torvalds (1):
        Linux 3.5-rc1

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Javi Merino (1):
      DMA: PL330: Fix racy mutex unlock

Richard Zhao (1):
      dma: imx-sdma: buf_tail should be initialize in prepare function

Sachin Kamat (1):
      DMA: PL330: Add missing static storage class specifier

Tushar Behera (1):
      dmaengine: pl330: dont complete descriptor for cyclic dma

 drivers/dma/imx-sdma.c |    6 ++++--
 drivers/dma/pl330.c    |   30 ++++++++++++------------------
 2 files changed, 16 insertions(+), 20 deletions(-)


-- 
~Vinod

