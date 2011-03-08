Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab1CHQYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 11:24:52 -0500
Received: from 64.mail-out.ovh.net ([91.121.185.65]:58534 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752078Ab1CHQYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 11:24:51 -0500
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH] rtc/at91sam9: fix typo .alarm_irq_enabled instead of .alarm_irq_enable
Date: Tue,  8 Mar 2011 17:19:33 +0100
Message-Id: <1299601173-26252-1-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: git-send-email 1.7.2.3
X-Ovh-Tracer-Id: 6363304800336849841
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in struct rtc_class_ops at91_rtc_ops

introduce in commit 16380c153a6
RTC: Convert rtc drivers to use the alarm_irq_enable method

Cc: John Stultz <john.stultz@linaro.org>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 drivers/rtc/rtc-at91sam9.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index c36749e..5469c52 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -309,7 +309,7 @@ static const struct rtc_class_ops at91_rtc_ops = {
 	.read_alarm	= at91_rtc_readalarm,
 	.set_alarm	= at91_rtc_setalarm,
 	.proc		= at91_rtc_proc,
-	.alarm_irq_enabled = at91_rtc_alarm_irq_enable,
+	.alarm_irq_enable = at91_rtc_alarm_irq_enable,
 };
 
 /*
-- 
1.7.4.1

