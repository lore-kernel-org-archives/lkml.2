Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292Ab0JZT5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:57:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39481 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760124Ab0JZT5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:57:37 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/22] trivial: fix typos concerning "management"
Date: Tue, 26 Oct 2010 21:57:13 +0200
Message-Id: <1288123039-22368-16-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arm/mach-omap2/cpuidle34xx.c |    2 +-
 drivers/message/fusion/mptsas.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/cpuidle34xx.c b/arch/arm/mach-omap2/cpuidle34xx.c
index 0d50b45..1e6fe6d 100644
--- a/arch/arm/mach-omap2/cpuidle34xx.c
+++ b/arch/arm/mach-omap2/cpuidle34xx.c
@@ -252,7 +252,7 @@ static int omap3_enter_idle_bm(struct cpuidle_device *dev,
 	 * FIXME: we currently manage device-specific idle states
 	 *        for PER and CORE in combination with CPU-specific
 	 *        idle states.  This is wrong, and device-specific
-	 *        idle managment needs to be separated out into 
+	 *        idle management needs to be separated out into 
 	 *        its own code.
 	 */
 
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 83a5115..5651f77 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1146,7 +1146,7 @@ mptsas_target_reset_queue(MPT_ADAPTER *ioc,
  *
  * This function will delete scheduled target reset from the list and
  * try to send next target reset. This will be called from completion
- * context of any Task managment command.
+ * context of any Task management command.
  */
 
 void
-- 
1.7.2.3

