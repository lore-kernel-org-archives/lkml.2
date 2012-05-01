Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab2EAIhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 04:37:09 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:60397 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab2EAIhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 04:37:07 -0400
From: Chen Baozi <baozich@gmail.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Chen Baozi <baozich@gmail.com>
Subject: [PATCH] include/linux/irqdesc.h: fix comment of struct irq_desc
Date: Tue,  1 May 2012 08:36:30 +0800
Message-Id: <1335832590-28341-1-git-send-email-baozich@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix:
- comments about struct irq_desc.

Signed-off-by: Chen Baozi <baozich@gmail.com>
---
 include/linux/irqdesc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index f1e2527..e35d058 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -20,7 +20,7 @@ struct module;
  * @handle_irq:		highlevel irq-events handler
  * @preflow_handler:	handler called before the flow handler (currently used by sparc)
  * @action:		the irq action chain
- * @status:		status information
+ * @status_use_accessors: status information
  * @core_internal_state__do_not_mess_with_it: core internal status information
  * @depth:		disable-depth, for nested irq_disable() calls
  * @wake_depth:		enable depth, for multiple irq_set_irq_wake() callers
-- 
1.7.1

