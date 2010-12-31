Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab0LaAJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 19:09:46 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:62963 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab0LaAJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 19:09:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vSsmRPv7a70j2YgLIjtbZI36OJQw5ntrvRNTBsUyDhXSbfkQvJ6vi/lqfF3a789COe
         MmOwq5vJuzgtEtTjspDuo8axkukQ4+BaGf7LJm2n6cK8LFr8OR3gSluj52qHJQpMpqlb
         mzCVrfId4Y2K1/fXy69/R5tYNBykQiZuB3MqU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        gregkh@suse.de, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/5]drivers:staging:tidspbridge:core:tiomap3430.c Typo change singal to signal
Date: Thu, 30 Dec 2010 16:09:42 -0800
Message-Id: <1293754184-1928-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293754184-1928-2-git-send-email-justinmattock@gmail.com>
References: <1293754184-1928-1-git-send-email-justinmattock@gmail.com>
 <1293754184-1928-2-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches below fixes a typo "singal" to "signal". Please let me 
know if anything needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/tidspbridge/core/tiomap3430.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 1be081f..7e56ff6 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -1796,7 +1796,7 @@ static int mem_map_vmalloc(struct bridge_dev_context *dev_context,
 
 /*
  *  ======== wait_for_start ========
- *      Wait for the singal from DSP that it has started, or time out.
+ *      Wait for the signal from DSP that it has started, or time out.
  */
 bool wait_for_start(struct bridge_dev_context *dev_context, u32 dw_sync_addr)
 {
-- 
1.6.5.2.180.gc5b3e

