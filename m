Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab2KTFz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 00:55:26 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41289 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab2KTFzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 00:55:25 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] mfd/twl6040: Remove duplicate inclusion of linux/err.h
Date: Tue, 20 Nov 2012 11:19:15 +0530
Message-Id: <1353390555-25519-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/err.h was included twice.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/twl6040.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index e5f7b79..583be76 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -37,7 +37,6 @@
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/regmap.h>
-#include <linux/err.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/twl6040.h>
 #include <linux/regulator/consumer.h>
-- 
1.7.4.1

