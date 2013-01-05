Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab3AECqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 21:46:14 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:48072 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab3AECoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 21:44:54 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [v3 PATCH 6/9] watchdog/at91sam9_wdt: Remove the __initdata of at91wdt_wdd
Date: Sat,  5 Jan 2013 10:38:46 +0800
Message-Id: <1357353529-20901-7-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357353529-20901-1-git-send-email-wenyou.yang@atmel.com>
References: <1357353529-20901-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 05 Jan 2013 02:44:35.0363 (UTC) FILETIME=[98FFCF30:01CDEAEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For this variable will be used in the timer handler.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: wim@iguana.be
Cc: linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/watchdog/at91sam9_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index 53ede84..94be9d6 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -196,7 +196,7 @@ static struct watchdog_ops at91wdt_ops = {
 	.ping = at91wdt_ping,
 };
 
-static struct watchdog_device at91wdt_wdd __initdata = {
+static struct watchdog_device at91wdt_wdd = {
 	.timeout = WDT_HEARTBEAT,
 	.min_timeout = MIN_HEARTBEAT,
 	.max_timeout = MAX_HEARTBEAT,
-- 
1.7.9.5

