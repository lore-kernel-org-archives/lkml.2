Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab2APGxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 01:53:20 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43341 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2APGxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 01:53:19 -0500
Message-ID: <1326696788.2214.1.camel@phoenix>
Subject: [PATCH] devfreq: Remove MODULE_ALIAS for exynos4 busfreq driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Mon, 16 Jan 2012 14:53:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver can only be built-in, it does not make sense to add modalias for
it (in addition to being incorrect, the platform modalias needs to be prefixed
with "platform:").

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/devfreq/exynos4_bus.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
index 489ccfa..590d686 100644
--- a/drivers/devfreq/exynos4_bus.c
+++ b/drivers/devfreq/exynos4_bus.c
@@ -1124,4 +1124,3 @@ module_exit(exynos4_busfreq_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("EXYNOS4 busfreq driver with devfreq framework");
 MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
-MODULE_ALIAS("exynos4-busfreq");
-- 
1.7.5.4



