Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab2KNHVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:21:17 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:20231 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab2KNHTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:19:48 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, wenyou.yang@atmel.com, JM.Lin@atmel.com
Subject: [PATCH 07/11] watchdog/at91sam9_wdt: add nowayout helpers to Watchdog Timer Driver Kernel API
Date: Wed, 14 Nov 2012 15:16:05 +0800
Message-Id: <1352877369-19740-8-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
References: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 14 Nov 2012 07:19:36.0619 (UTC) FILETIME=[6708A7B0:01CDC238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/watchdog/at91sam9_wdt.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index d764f36..187e33f 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -225,6 +225,8 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	watchdog_set_nowayout(&at91_wddev, nowayout);
+
 	ret = watchdog_register_device(&at91_wddev);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register watchdog (%d)\n", ret);
-- 
1.7.9.5

