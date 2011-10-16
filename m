Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab1JPITp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 04:19:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37143 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab1JPITl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 04:19:41 -0400
Date: Sun, 16 Oct 2011 11:19:30 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine/ep93xx_dma: add module.h include
Message-ID: <20111016081930.GC2642@mwesterb-mobl.ger.corp.intel.com>
References: <1318703917-7604-1-git-send-email-mika.westerberg@iki.fi>
 <1318752342.23438.49.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318752342.23438.49.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 16, 2011 at 01:35:42PM +0530, Vinod Koul wrote:
> Any reason why it is required. Changelog isn't really helpful

Yeah, sorry. Grant also mentioned about the same thing.

Below is an updated version.

From: Mika Westerberg <mika.westerberg@iki.fi>
Subject: [PATCH] dmaengine/ep93xx_dma: add module.h include

Due to module.h cleanup it is not anymore included implicitly. Drivers who
want to use it need to include it explicitly.

Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
---
 drivers/dma/ep93xx_dma.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index 5d7a49b..b47e2b8 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/dmaengine.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
-- 
1.7.6.3

