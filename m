Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab0KSPtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 10:49:33 -0500
Received: from smtp.nokia.com ([147.243.128.24]:60555 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab0KSPtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 10:49:32 -0500
From: Aaro Koskinen <aaro.koskinen@nokia.com>
To: linux-pm@lists.linux-foundation.org, rjw@sisk.pl,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pm: fix comments to match runtime callback code
Date: Fri, 19 Nov 2010 17:48:52 +0200
Message-Id: <1290181732-9124-1-git-send-email-aaro.koskinen@nokia.com>
X-Mailer: git-send-email 1.5.6.5
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 05aa55dddb9ee4045c320661068bea78dad6a6e5 changed routines to
succeed if the driver handler is not defined. Comments were not updated.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
---
 drivers/base/power/generic_ops.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/generic_ops.c b/drivers/base/power/generic_ops.c
index 81f2c84..3d2c350 100644
--- a/drivers/base/power/generic_ops.c
+++ b/drivers/base/power/generic_ops.c
@@ -39,7 +39,7 @@ EXPORT_SYMBOL_GPL(pm_generic_runtime_idle);
  *
  * If PM operations are defined for the @dev's driver and they include
  * ->runtime_suspend(), execute it and return its error code.  Otherwise,
- * return -EINVAL.
+ * return 0.
  */
 int pm_generic_runtime_suspend(struct device *dev)
 {
@@ -58,7 +58,7 @@ EXPORT_SYMBOL_GPL(pm_generic_runtime_suspend);
  *
  * If PM operations are defined for the @dev's driver and they include
  * ->runtime_resume(), execute it and return its error code.  Otherwise,
- * return -EINVAL.
+ * return 0.
  */
 int pm_generic_runtime_resume(struct device *dev)
 {
-- 
1.5.6.5

