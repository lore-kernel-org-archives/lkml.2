Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164Ab0FKKRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:17:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37027 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab0FKKRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:17:22 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] trivial: fix typos concerning "instead"
Date: Fri, 11 Jun 2010 12:16:56 +0200
Message-Id: <1276251424-12806-2-git-send-email-u.kleine-koenig@pengutronix.de>
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
 arch/powerpc/platforms/ps3/htab.c |    2 +-
 drivers/rtc/rtc-fm3130.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/ps3/htab.c b/arch/powerpc/platforms/ps3/htab.c
index 1e8a1e3..15a2510 100644
--- a/arch/powerpc/platforms/ps3/htab.c
+++ b/arch/powerpc/platforms/ps3/htab.c
@@ -136,7 +136,7 @@ static long ps3_hpte_updatepp(unsigned long slot, unsigned long newpp,
 	 * As lv1_read_htab_entries() does not give us the RPN, we can
 	 * not synthesize the new hpte_r value here, and therefore can
 	 * not update the hpte with lv1_insert_htab_entry(), so we
-	 * insted invalidate it and ask the caller to update it via
+	 * instead invalidate it and ask the caller to update it via
 	 * ps3_hpte_insert() by returning a -1 value.
 	 */
 	if (!HPTE_V_COMPARE(hpte_v, want_v) || !(hpte_v & HPTE_V_VALID)) {
diff --git a/drivers/rtc/rtc-fm3130.c b/drivers/rtc/rtc-fm3130.c
index ff6fce6..e4de8f3 100644
--- a/drivers/rtc/rtc-fm3130.c
+++ b/drivers/rtc/rtc-fm3130.c
@@ -104,7 +104,7 @@ static int fm3130_get_time(struct device *dev, struct rtc_time *t)
 	if (!fm3130->data_valid) {
 		/* We have invalid data in RTC, probably due
 		to battery faults or other problems. Return EIO
-		for now, it will allow us to set data later insted
+		for now, it will allow us to set data later instead
 		of error during probing which disables device */
 		return -EIO;
 	}
-- 
1.7.1

