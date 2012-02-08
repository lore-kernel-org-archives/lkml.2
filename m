Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab2BHLdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 06:33:32 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:50332
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755846Ab2BHLdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 06:33:31 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: mchehab@infradead.org, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] mantis: Fix typo in mantis_hif.c
Date: Wed,  8 Feb 2012 20:28:23 +0900
Message-Id: <1328700503-1661-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct typo "Adater" to "Adapter" in
drivers/media/dvb/mantis/mantis_hif.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/media/dvb/mantis/mantis_hif.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/mantis/mantis_hif.c b/drivers/media/dvb/mantis/mantis_hif.c
index 672cf4d..10c68df 100644
--- a/drivers/media/dvb/mantis/mantis_hif.c
+++ b/drivers/media/dvb/mantis/mantis_hif.c
@@ -76,7 +76,7 @@ static int mantis_hif_write_wait(struct mantis_ca *ca)
 		udelay(500);
 		timeout++;
 		if (timeout > 100) {
-			dprintk(MANTIS_ERROR, 1, "Adater(%d) Slot(0): Write operation timed out!", mantis->num);
+			dprintk(MANTIS_ERROR, 1, "Adapter(%d) Slot(0): Write operation timed out!", mantis->num);
 			rc = -ETIMEDOUT;
 			break;
 		}
-- 
1.7.6.5

