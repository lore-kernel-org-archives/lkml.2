Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab2GICyl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:54:41 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51545 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2GICyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 22:54:38 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: andriy.shevchenko@linux.intel.com, jj@chaosbits.net,
        forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 4/6] staging: vt6655: baseband.h: Remove all unused macros
Date: Sun,  8 Jul 2012 23:51:24 -0300
Message-Id: <1341802286-28281-5-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341802286-28281-1-git-send-email-marcos.souza.org@gmail.com>
References: <1341802286-28281-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros were reported by forgotten-macros tool
(https://github.com/marcosps/forgotten_macros).

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/vt6655/baseband.h |   30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.h b/drivers/staging/vt6655/baseband.h
index 8294bdb..be2d689 100644
--- a/drivers/staging/vt6655/baseband.h
+++ b/drivers/staging/vt6655/baseband.h
@@ -46,36 +46,6 @@
 // Baseband RF pair definition in eeprom (Bits 6..0)
 //
 
-/*
-#define RATE_1M         0
-#define RATE_2M         1
-#define RATE_5M         2
-#define RATE_11M        3
-#define RATE_6M         4
-#define RATE_9M         5
-#define RATE_12M        6
-#define RATE_18M        7
-#define RATE_24M        8
-#define RATE_36M        9
-#define RATE_48M       10
-#define RATE_54M       11
-#define RATE_AUTO      12
-#define MAX_RATE       12
-
-
-//0:11A 1:11B 2:11G
-#define BB_TYPE_11A    0
-#define BB_TYPE_11B    1
-#define BB_TYPE_11G    2
-
-//0:11a,1:11b,2:11gb(only CCK in BasicRate),3:11ga(OFDM in Basic Rate)
-#define PK_TYPE_11A     0
-#define PK_TYPE_11B     1
-#define PK_TYPE_11GB    2
-#define PK_TYPE_11GA    3
-*/
-
-
 #define PREAMBLE_LONG   0
 #define PREAMBLE_SHORT  1
 
-- 
1.7.10.4

