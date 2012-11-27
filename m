Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab2K0GFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:05:23 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48343 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab2K0GFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:05:20 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, cbouatmailru@gmail.com, dwmw2@infradead.org,
        sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/3] power: bq2415x_charger: Remove unneeded version.h inclusion
Date: Tue, 27 Nov 2012 11:28:44 +0530
Message-Id: <1353995926-4621-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353995926-4621-1-git-send-email-sachin.kamat@linaro.org>
References: <1353995926-4621-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<linux/version.h> is not required here.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/power/bq2415x_charger.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index ee842b3..2d1b568 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -28,7 +28,6 @@
  * http://www.ti.com/product/bq24155
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/param.h>
-- 
1.7.4.1

