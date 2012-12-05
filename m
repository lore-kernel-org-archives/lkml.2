Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab2LEBkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 20:40:14 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:26042 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab2LEBi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 20:38:59 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [v2 PATCH 5/8] watchdog/at91sam9_wdt: Remove the __initdata of at91wdt_wdd
Date: Wed,  5 Dec 2012 09:34:24 +0800
Message-Id: <1354671267-19277-6-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354671267-19277-1-git-send-email-wenyou.yang@atmel.com>
References: <1354671267-19277-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 05 Dec 2012 01:38:44.0850 (UTC) FILETIME=[43811D20:01CDD289]
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
index f1e21dd..5afd3fb 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -201,7 +201,7 @@ static struct watchdog_ops at91wdt_ops = {
 	.ping = at91wdt_ping,
 };
 
-static struct watchdog_device at91wdt_wdd __initdata = {
+static struct watchdog_device at91wdt_wdd = {
 	.timeout = WDT_HEARTBEAT,
 	.min_timeout = MIN_HEARTBEAT,
 	.max_timeout = MAX_HEARTBEAT,
-- 
1.7.9.5

