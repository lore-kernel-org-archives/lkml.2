Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab2JKNjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:39:33 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38100 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab2JKNja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:39:30 -0400
From: Nishanth Menon <nm@ti.com>
To: <linux-pm@vger.kernel.org>
CC: Nishanth Menon <nm@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kevin Hilman <khilman@ti.com>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] PM / devfreq: kernel-doc typo corrections
Date: Thu, 11 Oct 2012 08:39:15 -0500
Message-ID: <1349962755-19598-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parameter documentation needs a ':' for scripts/kernel-doc
to parse properly.

Minor fixes for ones warned by:
./scripts/kernel-doc -text drivers/devfreq/devfreq.c>/dev/null

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@ti.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/devfreq/devfreq.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 70c31d4..e4d48d2 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -123,9 +123,9 @@ int update_devfreq(struct devfreq *devfreq)
 /**
  * devfreq_notifier_call() - Notify that the device frequency requirements
  *			   has been changed out of devfreq framework.
- * @nb		the notifier_block (supposed to be devfreq->nb)
- * @type	not used
- * @devp	not used
+ * @nb:		the notifier_block (supposed to be devfreq->nb)
+ * @type:	not used
+ * @devp:	not used
  *
  * Called by a notifier that uses devfreq->nb.
  */
@@ -431,7 +431,7 @@ err_out:
 
 /**
  * devfreq_remove_device() - Remove devfreq feature from a device.
- * @devfreq	the devfreq instance to be removed
+ * @devfreq:	the devfreq instance to be removed
  */
 int devfreq_remove_device(struct devfreq *devfreq)
 {
@@ -641,9 +641,9 @@ module_exit(devfreq_exit);
 /**
  * devfreq_recommended_opp() - Helper function to get proper OPP for the
  *			     freq value given to target callback.
- * @dev		The devfreq user device. (parent of devfreq)
- * @freq	The frequency given to target function
- * @flags	Flags handed from devfreq framework.
+ * @dev:	The devfreq user device. (parent of devfreq)
+ * @freq:	The frequency given to target function
+ * @flags:	Flags handed from devfreq framework.
  *
  */
 struct opp *devfreq_recommended_opp(struct device *dev, unsigned long *freq,
@@ -674,8 +674,8 @@ struct opp *devfreq_recommended_opp(struct device *dev, unsigned long *freq,
  * devfreq_register_opp_notifier() - Helper function to get devfreq notified
  *				   for any changes in the OPP availability
  *				   changes
- * @dev		The devfreq user device. (parent of devfreq)
- * @devfreq	The devfreq object.
+ * @dev:	The devfreq user device. (parent of devfreq)
+ * @devfreq:	The devfreq object.
  */
 int devfreq_register_opp_notifier(struct device *dev, struct devfreq *devfreq)
 {
@@ -690,8 +690,8 @@ int devfreq_register_opp_notifier(struct device *dev, struct devfreq *devfreq)
  * devfreq_unregister_opp_notifier() - Helper function to stop getting devfreq
  *				     notified for any changes in the OPP
  *				     availability changes anymore.
- * @dev		The devfreq user device. (parent of devfreq)
- * @devfreq	The devfreq object.
+ * @dev:	The devfreq user device. (parent of devfreq)
+ * @devfreq:	The devfreq object.
  *
  * At exit() callback of devfreq_dev_profile, this must be included if
  * devfreq_recommended_opp is used.
-- 
1.7.9.5

