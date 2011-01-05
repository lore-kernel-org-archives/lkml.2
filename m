Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab1AEQzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 11:55:39 -0500
Received: from mail.atmel.fr ([81.80.104.162]:61160 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab1AEQzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 11:55:38 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: avictor.za@gmail.com, plagnioj@jcrosoft.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] MAINTAINERS: Update Atmel AT91 entry
Date: Wed,  5 Jan 2011 19:04:58 +0100
Message-Id: <1294250698-13275-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two co-maintainers and update the entry with new information.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 MAINTAINERS |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7585e9d..cb58500 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -552,11 +552,15 @@ M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
-ARM/ATMEL AT91RM9200 ARM ARCHITECTURE
+ARM/ATMEL AT91RM9200 AND AT91SAM ARM ARCHITECTURES
 M:	Andrew Victor <linux@maxim.org.za>
+M:	Nicolas Ferre <nicolas.ferre@atmel.com>
+M:	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://maxim.org.za/at91_26.html
-S:	Maintained
+W:	http://www.linux4sam.org
+S:	Supported
+F:	arch/arm/mach-at91/
 
 ARM/BCMRING ARM ARCHITECTURE
 M:	Jiandong Zheng <jdzheng@broadcom.com>
-- 
1.7.3

