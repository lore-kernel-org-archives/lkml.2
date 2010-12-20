Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab0LTOdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 09:33:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55541 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755057Ab0LTOdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 09:33:09 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ben Dooks <ben-linux@fluff.org>, Jean Delvare <khali@linux-fr.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] PM: Prototype the pm_generic_ operations
Date: Mon, 20 Dec 2010 14:33:12 +0000
Message-Id: <1292855593-30608-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pm_generic_ operations are all exported but are not prototyped in any
header file for direct use. Do so.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/pm.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index 40f3f45..f7b5bed 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -610,4 +610,11 @@ extern unsigned int	pm_flags;
 #define PM_APM	1
 #define PM_ACPI	2
 
+int pm_generic_suspend(struct device *dev);
+int pm_generic_resume(struct device *dev);
+int pm_generic_freeze(struct device *dev);
+int pm_generic_thaw(struct device *dev);
+int pm_generic_restore(struct device *dev);
+int pm_generic_poweroff(struct device *dev);
+
 #endif /* _LINUX_PM_H */
-- 
1.7.2.3

