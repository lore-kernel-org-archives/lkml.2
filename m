Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1AYNEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:04:44 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64668 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab1AYNEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:04:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=qfQyDe3Oud7t4Ok4VMEb5yERdnkUF5L/QbKY9zUig8reBPIbXGuSW6UEvhrJSG3XCN
         diHWE/5E7F+su5zkUiWNUCqRX+3w/h7pCXNpRkPNX4h2bNEVWVicfbNMthCi98P+A5jC
         B4ziEJfeZH8CUsbU8N/hx+RnCR3DTaNphsprA=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 03/11] staging: ft1000: Fix coding style in put_handshake() function.
Date: Tue, 25 Jan 2011 14:04:58 +0100
Message-Id: <1295960706-15667-4-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295960706-15667-1-git-send-email-marek.belisko@open-nandra.com>
References: <1295960706-15667-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   27 ++++++++++---------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 03694db..1472943 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -254,20 +254,21 @@ static u16 get_handshake(struct ft1000_device *ft1000dev, u16 expected_value)
 //---------------------------------------------------------------------------
 static void put_handshake(struct ft1000_device *ft1000dev,u16 handshake_value)
 {
-    u32 tempx;
-    u16 tempword;
-    u32 status;
-
-
-
-        tempx = (u32)handshake_value;
-        tempx = ntohl(tempx);
+	u32 tempx;
+	u16 tempword;
+	u32 status;
 
-        tempword = (u16)(tempx & 0xffff);
-        status = ft1000_write_dpram16 (ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC, tempword, 0);
-        tempword = (u16)(tempx >> 16);
-        status = ft1000_write_dpram16 (ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC, tempword, 1);
-        status = ft1000_write_register(ft1000dev, FT1000_DB_DNLD_TX, FT1000_REG_DOORBELL);
+	tempx = (u32)handshake_value;
+	tempx = ntohl(tempx);
+
+	tempword = (u16)(tempx & 0xffff);
+	status = ft1000_write_dpram16(ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC,
+					tempword, 0);
+	tempword = (u16)(tempx >> 16);
+	status = ft1000_write_dpram16(ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC,
+					tempword, 1);
+	status = ft1000_write_register(ft1000dev, FT1000_DB_DNLD_TX,
+					FT1000_REG_DOORBELL);
 }
 
 static u16 get_handshake_usb(struct ft1000_device *ft1000dev, u16 expected_value)
-- 
1.7.1

