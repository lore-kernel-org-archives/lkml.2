Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966474Ab2ERSW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 14:22:58 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58151 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932959Ab2ERSW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 14:22:57 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 1/2] mfd: Add r_select to lm3533 platform data
Date: Fri, 18 May 2012 20:22:45 +0200
Message-Id: <1337365366-14385-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add resistor-select parameter to the platform data.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---

Hi Samuel, 

I believe this one needs to go in through mfd as the iio driver
destined for staging-next depends on it.

Thanks,
Johan

 include/linux/mfd/lm3533.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/lm3533.h b/include/linux/mfd/lm3533.h
index 9660feb..594bc59 100644
--- a/include/linux/mfd/lm3533.h
+++ b/include/linux/mfd/lm3533.h
@@ -43,6 +43,7 @@ struct lm3533_ctrlbank {
 
 struct lm3533_als_platform_data {
 	unsigned pwm_mode:1;		/* PWM input mode (default analog) */
+	u8 r_select;			/* 1 - 127 (ignored in PWM-mode) */
 };
 
 struct lm3533_bl_platform_data {
-- 
1.7.8.5

