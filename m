Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab1HWFyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 01:54:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:32971 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab1HWFyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 01:54:20 -0400
Subject: [PATCH RESEND] drivers/misc: fix modalias for ab8500-pwm
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Murthy <arun.murthy@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 13:54:12 +0800
Message-ID: <1314078852.3960.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
with "platform:"), the platform modalias is prefixed with "platform:".

This patch changes the MODULE_ALIAS to "platform:ab8500-pwm".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Arun Murthy <arun.murthy@stericsson.com>
---
 drivers/misc/ab8500-pwm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/ab8500-pwm.c b/drivers/misc/ab8500-pwm.c
index 54e3d05..3590315 100644
--- a/drivers/misc/ab8500-pwm.c
+++ b/drivers/misc/ab8500-pwm.c
@@ -164,5 +164,5 @@ subsys_initcall(ab8500_pwm_init);
 module_exit(ab8500_pwm_exit);
 MODULE_AUTHOR("Arun MURTHY <arun.murthy@stericsson.com>");
 MODULE_DESCRIPTION("AB8500 Pulse Width Modulation Driver");
-MODULE_ALIAS("AB8500 PWM driver");
+MODULE_ALIAS("platform:ab8500-pwm");
 MODULE_LICENSE("GPL v2");
-- 
1.7.4.1



