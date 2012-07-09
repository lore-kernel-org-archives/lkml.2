Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab2GICyc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:54:32 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51545 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab2GICya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 22:54:30 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: andriy.shevchenko@linux.intel.com, jj@chaosbits.net,
        forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 3/6] staging: vt6655: rf.c: Remove all unused macros
Date: Sun,  8 Jul 2012 23:51:23 -0300
Message-Id: <1341802286-28281-4-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341802286-28281-1-git-send-email-marcos.souza.org@gmail.com>
References: <1341802286-28281-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros were reported by forgotte-macros tool
(https://github.com/marcosps/forgotten_macros).

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/vt6655/rf.c |   36 ------------------------------------
 1 file changed, 36 deletions(-)

diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index a2db0ff..aa69665 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -41,52 +41,16 @@
 
 //static int          msglevel                =MSG_LEVEL_INFO;
 
-#define BY_RF2959_REG_LEN     23 //24bits
-#define CB_RF2959_INIT_SEQ    15
-#define SWITCH_CHANNEL_DELAY_RF2959 200 //us
-#define RF2959_PWR_IDX_LEN    32
-
-#define BY_MA2825_REG_LEN     23 //24bit
-#define CB_MA2825_INIT_SEQ    13
-#define SWITCH_CHANNEL_DELAY_MA2825 200 //us
-#define MA2825_PWR_IDX_LEN    31
-
 #define BY_AL2230_REG_LEN     23 //24bit
 #define CB_AL2230_INIT_SEQ    15
 #define SWITCH_CHANNEL_DELAY_AL2230 200 //us
 #define AL2230_PWR_IDX_LEN    64
 
 
-#define BY_UW2451_REG_LEN     23
-#define CB_UW2451_INIT_SEQ    6
-#define SWITCH_CHANNEL_DELAY_UW2451 200 //us
-#define UW2451_PWR_IDX_LEN    25
-
-//{{ RobertYu: 20041118
-#define BY_MA2829_REG_LEN     23 //24bit
-#define CB_MA2829_INIT_SEQ    13
-#define SWITCH_CHANNEL_DELAY_MA2829 200 //us
-#define MA2829_PWR_IDX_LEN    64
-//}} RobertYu
-
-//{{ RobertYu:20050103
 #define BY_AL7230_REG_LEN     23 //24bit
 #define CB_AL7230_INIT_SEQ    16
 #define SWITCH_CHANNEL_DELAY_AL7230 200 //us
 #define AL7230_PWR_IDX_LEN    64
-//}} RobertYu
-
-//{{ RobertYu: 20041210
-#define BY_UW2452_REG_LEN     23
-#define CB_UW2452_INIT_SEQ    5 //RoberYu:20050113, Rev0.2 Programming Guide(remove R3, so 6-->5)
-#define SWITCH_CHANNEL_DELAY_UW2452 100 //us
-#define UW2452_PWR_IDX_LEN    64
-//}} RobertYu
-
-#define BY_VT3226_REG_LEN     23
-#define CB_VT3226_INIT_SEQ    12
-#define SWITCH_CHANNEL_DELAY_VT3226 200 //us
-#define VT3226_PWR_IDX_LEN    16
 
 /*---------------------  Static Classes  ----------------------------*/
 
-- 
1.7.10.4

