Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab1AMRfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:35:34 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38965 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839Ab1AMRfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:35:33 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>
Subject: [PATCH] Cleanup removed UIE emulation declaration
Date: Thu, 13 Jan 2011 09:30:49 -0800
Message-Id: <1294939849-20608-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtc_dev_update_irq_enable_emul was removed in commit
042620a018afcfba1d678062b62e463b9e43a68d (UIE emulation is
now handled via hrtimer), but the declaration was missed.
This patch cleans it up.

Cc:Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/rtc.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 3c995b4..ea76069 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -235,8 +235,6 @@ extern int rtc_irq_set_freq(struct rtc_device *rtc,
 				struct rtc_task *task, int freq);
 extern int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled);
 extern int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled);
-extern int rtc_dev_update_irq_enable_emul(struct rtc_device *rtc,
-						unsigned int enabled);
 
 void rtc_aie_update_irq(void *private);
 void rtc_uie_update_irq(void *private);
-- 
1.7.3.2.146.gca209

