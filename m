Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1H2LeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 07:34:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58436 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab1H2LeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 07:34:07 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linaro-dev@lists.linaro.org,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH 1/4] dmaengine/ste_dma40: add missing kernel doc for pending_queue
Date: Mon, 29 Aug 2011 13:33:32 +0200
Message-Id: <1314617615-2394-2-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314617615-2394-1-git-send-email-per.forlin@linaro.org>
References: <1314617615-2394-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/dma/ste_dma40.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index cd3a7c7..486b6c0 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -174,6 +174,7 @@ struct d40_base;
  * @tasklet: Tasklet that gets scheduled from interrupt context to complete a
  * transfer and call client callback.
  * @client: Cliented owned descriptor list.
+ * @pending_queue: Submitted jobs, to be issued by issue_pending()
  * @active: Active descriptor.
  * @queue: Queued jobs.
  * @dma_cfg: The client configuration of this dma channel.
-- 
1.7.4.1

