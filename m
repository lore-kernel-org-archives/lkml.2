Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab2AKFi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 00:38:59 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41156 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab2AKFi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 00:38:58 -0500
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-kernel@vger.kernel.org>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH RFC] spi-pl022.c: Make the suspend functions depend on CONFIG_PM_SLEEP.
Date: Wed, 11 Jan 2012 11:08:45 +0530
Message-ID: <1326260325-3644-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro SET_SYSTEM_SLEEP_PM_OPS  depends CONFIG_PM_SLEEP. The patch
defines the suspend and resume functions for CONFIG_PM_SLEEP.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-pl022.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 5559b22..4709475 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -2293,7 +2293,7 @@ pl022_remove(struct amba_device *adev)
 	return 0;
 }
 
-#ifdef CONFIG_SUSPEND
+#ifdef CONFIG_PM_SLEEP
 static int pl022_suspend(struct device *dev)
 {
 	struct pl022 *pl022 = dev_get_drvdata(dev);
-- 
1.7.1

