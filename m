Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab0HNNMW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 09:12:22 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:58133 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753286Ab0HNNMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 09:12:21 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Aug 2010 09:12:21 EDT
X-IronPort-AV: E=Sophos;i="4.55,367,1278280800"; 
   d="scan'208";a="65398672"
Subject: [PATCH] missing inline keyword for static function in
 linux/dmaengine.h
From: Mathieu Lacage <mathieu.lacage@sophia.inria.fr>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andre Noll <maan@systemlinux.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 Aug 2010 15:02:44 +0200
Message-ID: <1281790964.3017.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a missing inline keyword for static function in linux/dmaengine.h to
avoid duplicate symbol definitions.

Signed-off-by: Mathieu Lacage <mathieu.lacage@sophia.inria.fr>

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 5204f01..57d2b76 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -477,7 +477,7 @@ static inline bool dma_dev_has_pq_continue(struct dma_device *dma)
 	return (dma->max_pq & DMA_HAS_PQ_CONTINUE) == DMA_HAS_PQ_CONTINUE;
 }
 
-static unsigned short dma_dev_to_maxpq(struct dma_device *dma)
+static inline unsigned short dma_dev_to_maxpq(struct dma_device *dma)
 {
 	return dma->max_pq & ~DMA_HAS_PQ_CONTINUE;
 }


