Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab0FQHm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 03:42:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45649 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab0FQHmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 03:42:25 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/10 v2] trivial: fix typos concerning "precedence"
Date: Thu, 17 Jun 2010 09:42:20 +0200
Message-Id: <1276760540-15161-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1276251424-12806-8-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1276251424-12806-8-git-send-email-u.kleine-koenig@pengutronix.de>
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
compared to (implicit) v1 this now doesn't undo the initiali[zs]e fixes to
drivers/staging.

 arch/sh/kernel/clkdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sh/kernel/clkdev.c b/arch/sh/kernel/clkdev.c
index defdd6e..befc255 100644
--- a/arch/sh/kernel/clkdev.c
+++ b/arch/sh/kernel/clkdev.c
@@ -36,7 +36,7 @@ static DEFINE_MUTEX(clocks_mutex);
  *  If an entry has a device ID, it must match
  *  If an entry has a connection ID, it must match
  * Then we take the most specific entry - with the following
- * order of precidence: dev+con > dev only > con only.
+ * order of precedence: dev+con > dev only > con only.
  */
 static struct clk *clk_find(const char *dev_id, const char *con_id)
 {
-- 
1.7.1

