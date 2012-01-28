Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab2A1Nuq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 08:50:46 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:46504
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753236Ab2A1Nup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 08:50:45 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@suse.de, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, standby24x7@gmail.com, trivial@kernel.org
Subject: [PATCH] [trivial] usb: Fix typo in langwell_otg.c
Date: Sat, 28 Jan 2012 22:50:08 +0900
Message-Id: <1327758608-7575-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "reseting" to "resetting" in
drivers/usb/otg/langwell_otg.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/usb/otg/langwell_otg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/otg/langwell_otg.c b/drivers/usb/otg/langwell_otg.c
index f08f784..2500878 100644
--- a/drivers/usb/otg/langwell_otg.c
+++ b/drivers/usb/otg/langwell_otg.c
@@ -633,7 +633,7 @@ static void reset_otg(void)
 	int			delay_time = 1000;
 	u32			val;
 
-	dev_dbg(lnw->dev, "reseting OTG controller ...\n");
+	dev_dbg(lnw->dev, "resetting OTG controller ...\n");
 	val = readl(lnw->iotg.base + CI_USBCMD);
 	writel(val | USBCMD_RST, lnw->iotg.base + CI_USBCMD);
 	do {
-- 
1.7.6.5

