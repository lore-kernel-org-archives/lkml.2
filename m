Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab2GICA0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:00:26 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39289 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab2GICAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 22:00:00 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: andriy.shevchenko@linux.intel.com, jj@chaosbits.net,
        forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 5/5] staging: vt6656: Remove unsed macros
Date: Sun,  8 Jul 2012 22:55:50 -0300
Message-Id: <1341798950-11215-6-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341798950-11215-1-git-send-email-marcos.souza.org@gmail.com>
References: <1341798950-11215-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros were reported by forgotten-macros tool
(https://github.com/marcosps/forgotten_macros).

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/vt6656/card.c    |    1 -
 drivers/staging/vt6656/channel.c |    2 --
 drivers/staging/vt6656/rxtx.c    |    2 --
 3 files changed, 5 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 9d09e9f..e3ddc0b 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -66,7 +66,6 @@ static int          msglevel                =MSG_LEVEL_INFO;
 
 
 /*---------------------  Static Definitions -------------------------*/
-#define CB_TXPOWER_LEVEL            6
 
 /*---------------------  Static Classes  ----------------------------*/
 
diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index 99e054d..6502176 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -368,8 +368,6 @@ static  struct
 /*                                           1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  */
 };
 
-#define NUM_RULES	ARRAY_SIZE(ChannelRuleTab)
-
 /*---------------------  Export function  -------------------------*/
 /************************************************************************
  * Country Channel Valid
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 9b64b10..bb46452 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -73,8 +73,6 @@ static int          msglevel                = MSG_LEVEL_INFO;
 /*---------------------  Static Functions  --------------------------*/
 
 /*---------------------  Static Definitions -------------------------*/
-#define CRITICAL_PACKET_LEN      256    // if packet size < 256 -> in-direct send
-                                        //    packet size >= 256 -> direct send
 
 const WORD wTimeStampOff[2][MAX_RATE] = {
         {384, 288, 226, 209, 54, 43, 37, 31, 28, 25, 24, 23}, // Long Preamble
-- 
1.7.10.4

