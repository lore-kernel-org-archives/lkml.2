Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760427Ab0G3TC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:02:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53521 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760380Ab0G3TCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 15:02:49 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [PATCH] trivial: fix typo "choosed" -> "chosen"
Date: Fri, 30 Jul 2010 21:02:47 +0200
Message-Id: <1280516567-25754-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <4C52F6C1.5090207@mvista.com>
References: <4C52F6C1.5090207@mvista.com>
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
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 12b3bc0..0e83dfd 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2704,7 +2704,7 @@ void exit_ext4_mballoc(void)
 
 
 /*
- * Check quota and mark choosed space (ac->ac_b_ex) non-free in bitmaps
+ * Check quota and mark chosen space (ac->ac_b_ex) non-free in bitmaps
  * Returns 0 if success or error code
  */
 static noinline_for_stack int
-- 
1.7.1

