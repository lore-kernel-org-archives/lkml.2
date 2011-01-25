Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab1AYLJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:09:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50775 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1AYLHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:07:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=iGe8UhHpwClJnObRc+qIy1oTCtT35MXOhDT62I94xkh7G1Y2jzOUrMbwxH+z5HAAp8
         sdWaugrsGZtPgC1Eaqz1Ii6IxyaU3ndh19aCi/E5on2Cw9t0z/F5lx2ZUleRQ0lSmLs+
         wKQ/XGNFx6yB8ca1qUex50iaA0p3VOn8OabrM=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 04/12] staging: ft1000: Fix coding style.
Date: Tue, 25 Jan 2011 12:08:09 +0100
Message-Id: <1295953697-9805-4-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295953697-9805-1-git-send-email-marek.belisko@open-nandra.com>
References: <1295953697-9805-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style in put_handshake() function.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   29 ++++++++++---------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 30501f5..21b42f9 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -255,20 +255,21 @@ static u16 get_handshake(struct ft1000_device *ft1000dev, u16 expected_value)
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
-
-        tempword = (u16)(tempx & 0xffff);
-        status = ft1000_write_dpram16 (ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC, tempword, 0);
-        tempword = (u16)(tempx >> 16);
-        status = ft1000_write_dpram16 (ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC, tempword, 1);
-        status = ft1000_write_register(ft1000dev, FT1000_DB_DNLD_TX, FT1000_REG_DOORBELL);
+	u32 tempx;
+	u16 tempword;
+	u32 status;
+
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

