Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175Ab0FKKR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:17:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37030 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760140Ab0FKKRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:17:22 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/10] trivial: fix typos concerning "acquire"
Date: Fri, 11 Jun 2010 12:16:57 +0200
Message-Id: <1276251424-12806-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100611101624.GD10894@pengutronix.de>
References: <20100611101624.GD10894@pengutronix.de>
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
 arch/arm/mach-omap2/sleep34xx.S |    2 +-
 include/linux/lru_cache.h       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/sleep34xx.S b/arch/arm/mach-omap2/sleep34xx.S
index d522cd7..ba53191 100644
--- a/arch/arm/mach-omap2/sleep34xx.S
+++ b/arch/arm/mach-omap2/sleep34xx.S
@@ -60,7 +60,7 @@
 #define SDRC_DLLA_CTRL_V	OMAP34XX_SDRC_REGADDR(SDRC_DLLA_CTRL)
 
         .text
-/* Function to aquire the semaphore in scratchpad */
+/* Function to acquire the semaphore in scratchpad */
 ENTRY(lock_scratchpad_sem)
 	stmfd	sp!, {lr}	@ save registers on stack
 wait_sem:
diff --git a/include/linux/lru_cache.h b/include/linux/lru_cache.h
index de48d16..78fbf24 100644
--- a/include/linux/lru_cache.h
+++ b/include/linux/lru_cache.h
@@ -262,7 +262,7 @@ extern void lc_seq_dump_details(struct seq_file *seq, struct lru_cache *lc, char
  * @lc: the lru cache to operate on
  *
  * Note that the reference counts and order on the active and lru lists may
- * still change.  Returns true if we aquired the lock.
+ * still change.  Returns true if we acquired the lock.
  */
 static inline int lc_try_lock(struct lru_cache *lc)
 {
-- 
1.7.1

