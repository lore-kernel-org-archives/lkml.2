Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab2BLNht (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 08:37:49 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:52368
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753909Ab2BLNhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 08:37:48 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: isdn@linux-pingi.de, netdev@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] mISDN: Fix typo in dsp_core.c
Date: Sun, 12 Feb 2012 22:37:06 +0900
Message-Id: <1329053826-1635-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "modul" to "module" in
drivers/isdn/mISDN/dsp_core.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/isdn/mISDN/dsp_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_core.c b/drivers/isdn/mISDN/dsp_core.c
index 0c41553..742f9f4 100644
--- a/drivers/isdn/mISDN/dsp_core.c
+++ b/drivers/isdn/mISDN/dsp_core.c
@@ -1119,7 +1119,7 @@ static int __init dsp_init(void)
 	int err;
 	int tics;
 
-	printk(KERN_INFO "DSP modul %s\n", mISDN_dsp_revision);
+	printk(KERN_INFO "DSP module %s\n", mISDN_dsp_revision);
 
 	dsp_options = options;
 	dsp_debug = debug;
-- 
1.7.6.5

