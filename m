Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050Ab2EJRSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:18:52 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40538 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758813Ab2EJRSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:18:48 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Richard Purdie <rpurdie@rpsys.net>, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 1/2] mfd: lm3533: remove unused max-current function
Date: Thu, 10 May 2012 19:18:28 +0200
Message-Id: <1336670309-20858-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1336670309-20858-1-git-send-email-jhovold@gmail.com>
References: <20120510120742.GA29437@localhost>
 <1336670309-20858-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max-current attributes of the subdrivers have been dropped so
remove the no longer used lm3533_ctrlbank_get_max_current function.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/mfd/lm3533-ctrlbank.c |    1 -
 include/linux/mfd/lm3533.h    |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/lm3533-ctrlbank.c b/drivers/mfd/lm3533-ctrlbank.c
index c2732a3..adf4c1a 100644
--- a/drivers/mfd/lm3533-ctrlbank.c
+++ b/drivers/mfd/lm3533-ctrlbank.c
@@ -113,7 +113,6 @@ lm3533_ctrlbank_get(brightness, BRIGHTNESS);
  *   31 - 29.8 mA
  */
 lm3533_ctrlbank_set(max_current, MAX_CURRENT);
-lm3533_ctrlbank_get(max_current, MAX_CURRENT);
 
 /*
  * PWM-input control mask:
diff --git a/include/linux/mfd/lm3533.h b/include/linux/mfd/lm3533.h
index 3361137..7cfef9e 100644
--- a/include/linux/mfd/lm3533.h
+++ b/include/linux/mfd/lm3533.h
@@ -92,8 +92,6 @@ extern int lm3533_ctrlbank_disable(struct lm3533_ctrlbank *cb);
 extern int lm3533_ctrlbank_set_brightness(struct lm3533_ctrlbank *cb, u8 val);
 extern int lm3533_ctrlbank_get_brightness(struct lm3533_ctrlbank *cb, u8 *val);
 extern int lm3533_ctrlbank_set_max_current(struct lm3533_ctrlbank *cb, u8 val);
-extern int lm3533_ctrlbank_get_max_current(struct lm3533_ctrlbank *cb,
-								u8 *val);
 extern int lm3533_ctrlbank_set_pwm(struct lm3533_ctrlbank *cb, u8 val);
 extern int lm3533_ctrlbank_get_pwm(struct lm3533_ctrlbank *cb, u8 *val);
 
-- 
1.7.8.5

