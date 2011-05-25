Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab1EYSnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:43:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:31549 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269Ab1EYSnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:43:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,268,1304319600"; 
   d="scan'208";a="1627086"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, Dan <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH] mainatiners: add dma engine tree details
Date: Wed, 25 May 2011 23:39:26 +0530
Message-Id: <1306346966-16385-1-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@intel.com>

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 MAINTAINERS |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8f44130..4435893 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2169,6 +2169,8 @@ M:	Dan Williams <dan.j.williams@intel.com>
 S:	Supported
 F:	drivers/dma/
 F:	include/linux/dma*
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git
+T:	git git://git.infradead.org/users/vkoul/slave-dma.git (slave-dma)
 
 DME1737 HARDWARE MONITOR DRIVER
 M:	Juerg Haefliger <juergh@gmail.com>
-- 
1.7.0.4

