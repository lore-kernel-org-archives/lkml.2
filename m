Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab1FQLf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 07:35:58 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:46674 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab1FQLf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 07:35:56 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.11 with qID p5HBZgvq009752, This message is released by code: ctaloc0852
From: <edwin_rong@realsil.com.cn>
To: <error27@gmail.com>, <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: edwin_rong <edwin_rong@realsil.com.cn>
Subject: [PATCH 2/3] Realtek cr: Remove unused Macros
Date: Fri, 17 Jun 2011 19:35:10 +0800
X-BOX-Message-Id: p5HBZgvq009752
Message-ID: <1308310511-5659-2-git-send-email-edwin_rong@realsil.com.cn>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308310511-5659-1-git-send-email-edwin_rong@realsil.com.cn>
References: <1308310511-5659-1-git-send-email-edwin_rong@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: edwin_rong <edwin_rong@realsil.com.cn>

Remove Macros wait_timeout() and wait_timeout_x().

Signed-off-by: edwin_rong <edwin_rong@realsil.com.cn>
---
 drivers/usb/storage/realtek_cr.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index 0b6e30b..2ea0da2 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -119,15 +119,6 @@ struct rts51x_chip {
 #define CHECK_ID(chip, pid, fw_ver)	\
 		(CHECK_PID((chip), (pid)) && CHECK_FW_VER((chip), (fw_ver)))
 
-#define wait_timeout_x(task_state, msecs)	\
-do {						\
-	set_current_state((task_state));	\
-	schedule_timeout((msecs) * HZ / 1000);	\
-} while (0)
-
-#define wait_timeout(msecs)		\
-		wait_timeout_x(TASK_INTERRUPTIBLE, (msecs))
-
 static int init_realtek_cr(struct us_data *us);
 
 /*
-- 
1.7.4.1

