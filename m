Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab3ADOGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 09:06:51 -0500
Received: from norkia.v3.sk ([91.210.183.14]:59202 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab3ADOGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 09:06:48 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] orion_wdt: Add platform alias
Date: Fri,  4 Jan 2013 15:06:28 +0100
Message-Id: <1357308388-19566-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...so that it's automatically picked up on relevant platforms.
Tested on Kirkwood-based GuruPlug.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/watchdog/orion_wdt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index c20f96b..c9dd66f 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -223,4 +223,5 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:orion_wdt");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-- 
1.7.1

