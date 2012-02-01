Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab2BANIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 08:08:51 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:41469
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754328Ab2BANIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 08:08:50 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: chas@cmf.nrl.navy.mil, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] atm: Fix typo in lanai.c
Date: Wed,  1 Feb 2012 22:05:13 +0900
Message-Id: <1328101513-1704-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "reseting" to resetting" in
drivers/atm/lanai.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/atm/lanai.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index f556969..68c7588 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -1572,7 +1572,7 @@ static inline void host_vcc_unbind(struct lanai_dev *lanai,
 
 static void lanai_reset(struct lanai_dev *lanai)
 {
-	printk(KERN_CRIT DEV_LABEL "(itf %d): *NOT* reseting - not "
+	printk(KERN_CRIT DEV_LABEL "(itf %d): *NOT* resetting - not "
 	    "implemented\n", lanai->number);
 	/* TODO */
 	/* The following is just a hack until we write the real
-- 
1.7.6.5

