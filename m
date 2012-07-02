Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089Ab2GBVcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 17:32:53 -0400
Received: from ns.pmeerw.net ([87.118.82.44]:51723 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174Ab2GBVcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 17:32:52 -0400
From: Peter Meerwald <pmeerw@pmeerw.net>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, gregkh@linuxfoundation.org,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: [PATCH] extcon: spelling of detach in function doc
Date: Mon,  2 Jul 2012 23:32:50 +0200
Message-Id: <1341264770-1411-1-git-send-email-pmeerw@pmeerw.net>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
---
 include/linux/extcon/extcon_gpio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/extcon/extcon_gpio.h b/include/linux/extcon/extcon_gpio.h
index a2129b7..2d8307f 100644
--- a/include/linux/extcon/extcon_gpio.h
+++ b/include/linux/extcon/extcon_gpio.h
@@ -31,7 +31,7 @@
  * @irq_flags	IRQ Flags (e.g., IRQF_TRIGGER_LOW).
  * @state_on	print_state is overriden with state_on if attached. If Null,
  *		default method of extcon class is used.
- * @state_off	print_state is overriden with state_on if dettached. If Null,
+ * @state_off	print_state is overriden with state_on if detached. If Null,
  *		default method of extcon class is used.
  *
  * Note that in order for state_on or state_off to be valid, both state_on
-- 
1.7.9.5

