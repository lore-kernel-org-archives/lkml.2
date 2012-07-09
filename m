Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab2GICzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:55:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62140 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab2GICy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 22:54:57 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: andriy.shevchenko@linux.intel.com, jj@chaosbits.net,
        forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 6/6] staging: vt6655: hostap.c: Remove all unused macros
Date: Sun,  8 Jul 2012 23:51:26 -0300
Message-Id: <1341802286-28281-7-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341802286-28281-1-git-send-email-marcos.souza.org@gmail.com>
References: <1341802286-28281-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All these macros were reported by forgotten-macros tool
(https://github.com/marcosps/forgotten_macros).

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/vt6655/hostap.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hostap.c
index 7735027..6ac6f45 100644
--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -40,14 +40,8 @@
 
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
 
 /*---------------------  Static Definitions -------------------------*/
 
-- 
1.7.10.4

