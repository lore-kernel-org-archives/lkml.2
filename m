Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab1ADX2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:28:18 -0500
Received: from 232.Red-88-26-245.staticIP.rima-tde.net ([88.26.245.232]:49737
	"HELO sysvalve.homelinux.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751078Ab1ADX2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:28:03 -0500
From: =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
To: linux-kernel@vger.kernel.org
Cc: devel@linuxdriverproject.org, Greg Kroah-Hartman <gregkh@suse.de>,
        =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
Subject: [PATCH 3/3] Staging: rt2860: Fix space after unary '*' operator.
Date: Wed,  5 Jan 2011 00:27:45 +0100
Message-Id: <1294183665-5995-4-git-send-email-agimenez@sysvalve.es>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1294183665-5995-1-git-send-email-agimenez@sysvalve.es>
References: <1294183665-5995-1-git-send-email-agimenez@sysvalve.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch error.

Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>
---
 drivers/staging/rt2860/wpa.h |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rt2860/wpa.h b/drivers/staging/rt2860/wpa.h
index 116fc2c..a7796d3 100644
--- a/drivers/staging/rt2860/wpa.h
+++ b/drivers/staging/rt2860/wpa.h
@@ -369,19 +369,15 @@ struct PACKED rt_rsn_capability {
 /*========================================
 	The prototype is defined in cmm_wpa.c
   ========================================*/
-BOOLEAN WpaMsgTypeSubst(u8 EAPType, int * MsgType);
+BOOLEAN WpaMsgTypeSubst(u8 EAPType, int *MsgType);
 
-void PRF(u8 * key,
-	 int key_len,
-	 u8 * prefix,
-	 int prefix_len,
-	 u8 * data, int data_len, u8 * output, int len);
+void PRF(u8 *key, int key_len, u8 *prefix, int prefix_len,
+	 u8 *data, int data_len, u8 *output, int len);
 
 int PasswordHash(char *password,
 		 unsigned char *ssid, int ssidlength, unsigned char *output);
 
-u8 *GetSuiteFromRSNIE(u8 *rsnie,
-			 u32 rsnie_len, u8 type, u8 * count);
+u8 *GetSuiteFromRSNIE(u8 *rsnie, u32 rsnie_len, u8 type, u8 *count);
 
 void WpaShowAllsuite(u8 *rsnie, u32 rsnie_len);
 
-- 
1.7.2.3

