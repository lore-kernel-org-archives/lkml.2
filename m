Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab1LLHvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:51:39 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:58237 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab1LLHvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:51:38 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-af-4ee5b264c7d8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'H Hartley Sweeten'" <hsweeten@visionengravers.com>
Subject: [PATCH] backlight: ep93xx_bl: remove duplicated header include
Date: Mon, 12 Dec 2011 16:51:00 +0900
Message-id: <001201ccb8a2$ca235e30$5e6a1a90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acy4osnwbgdZQ6pVT2KpCyJbhfF1fA==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes duplicated module header for EP93xx backlight
driver.
drivers/video/backlight/ep93xx_bl.c: module.h is included more
than once.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ep93xx_bl.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/ep93xx_bl.c b/drivers/video/backlight/ep93xx_bl.c
index c74a6f4..4893dff 100644
--- a/drivers/video/backlight/ep93xx_bl.c
+++ b/drivers/video/backlight/ep93xx_bl.c
@@ -10,10 +10,8 @@
  * This driver controls the pulse width modulated brightness control output,
  * BRIGHT, on the Cirrus EP9307, EP9312, and EP9315 processors.
  */
-
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/module.h>
 #include <linux/io.h>
 #include <linux/fb.h>
 #include <linux/backlight.h>
-- 
1.7.1


