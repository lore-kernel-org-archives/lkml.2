Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab1CEPFh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 10:05:37 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39740 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab1CEPFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 10:05:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AmdRdAwfR5kM1C9CxuZTjHQFWtT+j5DK1wmhuxEusFzcaD8nS5ZMT/yyYXqmvRQh93
         46XYS13ii3ubRVVWV9bYjJXsj/9ailqZ7PCn0RXgiM4v39ci8OAiYUOgfswrM4gT9c0M
         aTmkcXDYdJxx9Er5chok+Z7oKSwOMMycJuE6I=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Cc: Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH] rtc: fix typo/build error in rtc-at91sam9.c
Date: Sat,  5 Mar 2011 18:05:30 +0300
Message-Id: <1299337530-6795-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build error in rtc-at91sam9.c: it's alarm_irq_enable,
not alarm_irq_enabled!

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
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
1.7.2.3

