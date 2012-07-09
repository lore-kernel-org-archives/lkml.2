Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab2GICAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:00:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39289 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2GIB7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 21:59:38 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: andriy.shevchenko@linux.intel.com, jj@chaosbits.net,
        forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 2/5] staging: vt6656: hostap.c: Remove unused macros and some useless comments
Date: Sun,  8 Jul 2012 22:55:47 -0300
Message-Id: <1341798950-11215-3-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341798950-11215-1-git-send-email-marcos.souza.org@gmail.com>
References: <1341798950-11215-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unused macros were reporteds by forgotten-macros
tool(https://github.com/marcosps/forgotten_macros).

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/vt6656/hostap.c |   20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index 51b5adf..f578095 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -41,31 +41,11 @@
 
 #define VIAWGET_HOSTAPD_MAX_BUF_SIZE 1024
 #define HOSTAP_CRYPT_FLAG_SET_TX_KEY BIT0
-#define HOSTAP_CRYPT_FLAG_PERMANENT BIT1
-#define HOSTAP_CRYPT_ERR_UNKNOWN_ALG 2
 #define HOSTAP_CRYPT_ERR_UNKNOWN_ADDR 3
-#define HOSTAP_CRYPT_ERR_CRYPT_INIT_FAILED 4
 #define HOSTAP_CRYPT_ERR_KEY_SET_FAILED 5
-#define HOSTAP_CRYPT_ERR_TX_KEY_SET_FAILED 6
-#define HOSTAP_CRYPT_ERR_CARD_CONF_FAILED 7
 
-
-/*---------------------  Static Definitions -------------------------*/
-
-/*---------------------  Static Classes  ----------------------------*/
-
-/*---------------------  Static Variables  --------------------------*/
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 static int          msglevel                =MSG_LEVEL_INFO;
 
-/*---------------------  Static Functions  --------------------------*/
-
-
-
-
-/*---------------------  Export Variables  --------------------------*/
-
-
 /*
  * Description:
  *      register net_device (AP) for hostap deamon
-- 
1.7.10.4

