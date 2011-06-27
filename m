Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab1F0Jfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 05:35:55 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:57397 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757481Ab1F0Jdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 05:33:41 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        om prakash <omprakash.pal@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/4] dmaengine/ste_dma40: fix missing kernel-doc
Date: Mon, 27 Jun 2011 11:33:31 +0200
Message-ID: <1309167211-23375-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: om prakash <omprakash.pal@stericsson.com>

Missing documentation creates kernel-doc warnings, so add
the documenation.

Signed-off-by: Om Prakash <omprakash.pal@stericsson.com>
Reviewed-by: Rabin Vincent <rabin.vincent@stericsson.com>
Reviewed-by: Jonas Aberg <jonas.aberg@stericsson.com>
Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/ste_dma40.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 58de946..35b078d 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -185,6 +185,8 @@ struct d40_base;
  * @log_def: Default logical channel settings.
  * @lcla: Space for one dst src pair for logical channel transfers.
  * @lcpa: Pointer to dst and src lcpa settings.
+ * @runtime_addr: runtime configured address.
+ * @runtime_direction: runtime configured direction.
  *
  * This struct can either "be" a logical or a physical channel.
  */
-- 
1.7.3.2

