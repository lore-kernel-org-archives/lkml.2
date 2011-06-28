Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab1F1Pag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:30:36 -0400
Received: from forward.atmel.no ([194.19.124.53]:60042 "EHLO forward.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757312Ab1F1P1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:27:50 -0400
X-Greylist: delayed 2001 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jun 2011 11:27:50 EDT
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: linux-kernel@vger.kernel.org
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Subject: [PATCH] misc: update author email for atmel-ssc
Date: Tue, 28 Jun 2011 17:00:21 +0200
Message-Id: <1309273221-8729-1-git-send-email-hans-christian.egtvedt@atmel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the email address of the atmel-ssc driver supported by me to
an email account I will use on a more regular basis in the future.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
---
 drivers/misc/atmel-ssc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
index 4afffe6..4701626 100644
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -170,7 +170,7 @@ static void __exit ssc_exit(void)
 }
 module_exit(ssc_exit);
 
-MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
+MODULE_AUTHOR("Hans-Christian Egtvedt <egtvedt@samfundet.no>");
 MODULE_DESCRIPTION("SSC driver for Atmel AVR32 and AT91");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:ssc");
-- 
1.7.4.1

