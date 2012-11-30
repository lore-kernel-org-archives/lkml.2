Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031065Ab2K3RA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:00:59 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57821 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031052Ab2K3RAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:00:55 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 09/32] staging: wlags49_h2: wl_enc: corrects spacing around colons
Date: Fri, 30 Nov 2012 18:58:34 +0200
Message-Id: <1354294737-5735-9-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes incorrect use of spaces around colons.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_enc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_enc.c b/drivers/staging/wlags49_h2/wl_enc.c
index 1d143cd..2cf3a113 100644
--- a/drivers/staging/wlags49_h2/wl_enc.c
+++ b/drivers/staging/wlags49_h2/wl_enc.c
@@ -126,7 +126,7 @@ int wl_wep_code(char *szCrypt, char *szDest, void *Data, int nLen)
 
 	switch (i % 3) {
 
-	case 0 :
+	case 0:
 
 		szDest[t]   = ((k & 0xFC) >> 2) + CH_START ;
 		szDest[t+1] = ((k & 0x03) << 4) + CH_START ;
@@ -135,7 +135,7 @@ int wl_wep_code(char *szCrypt, char *szDest, void *Data, int nLen)
 		break;
 
 
-	case 1 :
+	case 1:
 
 		szDest[t]  += ((k & 0xF0) >> 4);
 		szDest[t+1] = ((k & 0x0F) << 2) + CH_START ;
@@ -144,7 +144,7 @@ int wl_wep_code(char *szCrypt, char *szDest, void *Data, int nLen)
 		break;
 
 
-	case 2 :
+	case 2:
 
 		szDest[t]  += ((k & 0xC0) >> 6);
 		szDest[t+1] = (k & 0x3F) + CH_START ;
@@ -201,20 +201,20 @@ int wl_wep_decode(char *szCrypt, void *Dest, char *szData)
 
 	for (i = t = 0; i < nLen; i++, t++) {
 		switch (i % 3) {
-		case 0 :
+		case 0:
 
 			szDest[i] = (((szData[t] - CH_START) & 0x3f) << 2) +
 				    (((szData[t+1] - CH_START) & 0x30) >> 4);
 			break;
 
 
-		case 1 :
+		case 1:
 			szDest[i] = (((szData[t] - CH_START) & 0x0f) << 4) +
 				    (((szData[t+1] - CH_START) & 0x3c) >> 2);
 			break;
 
 
-		case 2 :
+		case 2:
 			szDest[i] = (((szData[t] - CH_START) & 0x03) << 6) +
 				     ((szData[t+1] - CH_START) & 0x3f);
 			t++;
-- 
1.7.10.4

