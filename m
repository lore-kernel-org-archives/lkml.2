Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab1BXHwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 02:52:23 -0500
Received: from ms01.sssup.it ([193.205.80.99]:39191 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754221Ab1BXHwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 02:52:22 -0500
Date: Thu, 24 Feb 2011 08:54:03 +0100
From: Michael Trimarchi <trimarchi@gandalf.sssup.it>
To: linux-kernel@vger.kernel.org
Cc: john.stultz@linaro.org, a.zummo@towertech.it
Subject: [PATCH V2] fix rtc-at91sam9 compilation issue
Message-ID: <20110224075403.GA7841@gandalf.sssup.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix rtc-at91sam9 compilation issue introduced by the commit

16380c153a69c3784d2afaddfe0a22f353046cf6

Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
---
 drivers/rtc/rtc-at91sam9.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index c36749e..62fda98 100644
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
1.7.1

