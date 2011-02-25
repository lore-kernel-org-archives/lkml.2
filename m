Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741Ab1BYTOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 14:14:09 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:34310 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab1BYTOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 14:14:07 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jelle Martijn Kok <jmkok@youcom.nl>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH] RTC: fix typo in drivers/rtc/rtc-at91sam9.c
Date: Fri, 25 Feb 2011 11:13:55 -0800
Message-Id: <1298661235-11926-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jelle Martijn Kok <jmkok@youcom.nl>

Linus, Thomas: Here's a typo fix for 2.6.38

The member of the rtc_class_ops struct is called alarm_irq_enable and
not alarm_irq_enabled

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jelle Martijn Kok <jmkok@youcom.nl>
Signed-off-by: John Stultz <john.stultz@linaro.org>
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
1.7.3.2.146.gca209

