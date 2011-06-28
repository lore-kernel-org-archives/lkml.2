Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab1F1P2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:28:04 -0400
Received: from forward.atmel.no ([194.19.124.53]:60046 "EHLO forward.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab1F1P1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:27:55 -0400
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: wim@iguana.be, linux-kernel@vger.kernel.org
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Subject: [PATCH] watchdog: update author email for at32ap700x_wdt
Date: Tue, 28 Jun 2011 17:01:14 +0200
Message-Id: <1309273274-8778-1-git-send-email-hans-christian.egtvedt@atmel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the email address of the at32ap700x_wdt driver supported by
me to an email account I will use on a more regular basis in the future.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
---
 drivers/watchdog/at32ap700x_wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
index 750bc52..4ca5d40 100644
--- a/drivers/watchdog/at32ap700x_wdt.c
+++ b/drivers/watchdog/at32ap700x_wdt.c
@@ -448,7 +448,7 @@ static void __exit at32_wdt_exit(void)
 }
 module_exit(at32_wdt_exit);
 
-MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
+MODULE_AUTHOR("Hans-Christian Egtvedt <egtvedt@samfundet.no>");
 MODULE_DESCRIPTION("Watchdog driver for Atmel AT32AP700X");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-- 
1.7.4.1

